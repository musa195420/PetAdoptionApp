import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/viewModel/authentication_view_model.dart';
import 'package:petadoption/viewModel/signup_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../viewModel/startup_viewmodel.dart';

class ProviderInjector {
  static List<SingleChildWidget> providers = [
    ..._independentServices,
    ..._dependentServices,
    ..._consumableServices,
  ];

  static final List<SingleChildWidget> _independentServices = [
    // ViewModels
    ChangeNotifierProvider(create: (_) => locator<AuthenticationViewModel>()),
     ChangeNotifierProvider(create: (_) => locator<SignupViewModel>()),
    // ChangeNotifierProvider(create: (_) => locator<HomeViewModel>()),
    // ChangeNotifierProvider(create: (_) => locator<DashboardViewModel>()),
     ChangeNotifierProvider(create: (_) => locator<StartupViewModel>()),
  
  ];

  static final List<SingleChildWidget> _dependentServices = [];
  
  static final List<SingleChildWidget> _consumableServices = [];
}