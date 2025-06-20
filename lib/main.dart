// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:petadoption/services/db_service.dart';
import 'package:petadoption/services/error_reporting_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/logging_service.dart';
import 'package:petadoption/services/network_service.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/themes/pet_theme.dart';
import 'package:provider/provider.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'helpers/provider.dart';
import 'models/hive_models/user.dart';
import 'services/navigation_service.dart';

void main() async {
  runZonedGuarded(
    () async {
      registerLoader();
      await LocatorInjector.setupLocator();

      await Hive.initFlutter();

      await configSettings();
      HttpOverrides.global = CustomHttpOverrides();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
      WidgetsFlutterBinding.ensureInitialized();
      runApp(const MyApp());
    },
    (Object error, StackTrace stack) {},
  );
}

Future<void> registerLoader() async {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.pulse
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

Future configSettings() async {
  // Init Services

  try {
    await locator<PrefService>().init();
    await locator<GlobalService>().init();
    //await locator<ScheduleService>().init();
    await locator<LoggingService>().init();
    await locator<NetworkService>().init();
    await locator<IErrorReportingService>().initErrors();
    // Init Repos
    final appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init("${appDocumentDirectory.path}/pet_adoption");
    await locator<IHiveService<User>>().init();

    locator<GlobalService>().log('-----------------------------------------');
    locator<GlobalService>().log('---------------- App Start --------------');
    locator<GlobalService>().log('-----------------------------------------');
  } catch (e) {
    debugPrint("Error => $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: ProviderInjector.providers,
        child: MaterialApp(
          title: 'Pet Adoption',
          debugShowCheckedModeBanner: false,
          theme: petTheme,
          builder: EasyLoading.init(),
          initialRoute: Routes.startup,
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: RouteManager.generateRoute,
        ));
  }
}

class CustomHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
