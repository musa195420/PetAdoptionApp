import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:petadoption/services/error_reporting_service.dart';
import 'package:petadoption/services/logging_service.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/repos/user_repo.dart';
import 'package:petadoption/services/db_service.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/http_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/network_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/authentication_view_model.dart';
import 'package:petadoption/viewModel/home_view_model.dart';

import '../viewModel/signup_view_model.dart';
import '../viewModel/startup_viewmodel.dart';


GetIt locator = GetIt.instance;

class LocatorInjector {
  static Future<void> setupLocator() async {
   try{
     locator.registerLazySingleton(() => GlobalService());
    //locator.registerLazySingleton(() => ScheduleService());
    locator.registerLazySingleton(() => NetworkService());
     locator.registerLazySingleton(() => NavigationService());
    locator.registerLazySingleton(() => PrefService());
    locator.registerLazySingleton(() => HttpService());
        locator.registerLazySingleton(() => LoggingService());
    locator.registerLazySingleton<IAPIService>(() => APIService());
      locator.registerLazySingleton<IErrorReportingService>(() => ErrorReportingService());
    locator.registerLazySingleton<IDialogService>(() => DialogService());
    


    // ViewModels
    // locator.registerLazySingleton(() => HomeViewModel());
     locator.registerLazySingleton(() => AuthenticationViewModel());
      locator.registerLazySingleton(() => SignupViewModel());
       locator.registerLazySingleton(() => StartupViewModel());
       locator.registerLazySingleton(() => HomeViewModel());
    

    // Repos
    
    locator.registerLazySingleton<IHiveService<User>>(() => UserRepo());
    //locator.registerLazySingleton<IHiveService<APIQueue>>(() => APIQueueRepo());
    
   }catch(e,s)
   {
    debugPrint("Error ==> ${e.toString()}");
   }
  }
}