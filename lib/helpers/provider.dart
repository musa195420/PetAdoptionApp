import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/viewModel/admin_view_models/donor_admin_view_model.dart';
import 'package:petadoption/viewModel/admin_view_models/general_config_view_model.dart';
import 'package:petadoption/viewModel/admin_view_models/secureMeetup_admin_view_model.dart';
import 'package:petadoption/viewModel/authentication_view_model.dart';
import 'package:petadoption/viewModel/signup_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../viewModel/admin_view_models/admin_view_model.dart';
import '../viewModel/admin_view_models/adopter_admin_view_model.dart';
import '../viewModel/admin_view_models/pet_admin_view_model.dart';
import '../viewModel/admin_view_models/user_admin_view_model.dart';
import '../viewModel/detail_view_model.dart';
import '../viewModel/home_view_model.dart';
import '../viewModel/pet_view_model.dart';

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
    ChangeNotifierProvider(create: (_) => locator<AdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<UserAdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<HomeViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<AdopterAdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<DonorAdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<StartupViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<PetViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<PetAdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<GeneralConfigViewModel>()),
    ChangeNotifierProvider(
        create: (_) => locator<SecuremeetupAdminViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<DetailViewModel>()),
  ];

  static final List<SingleChildWidget> _dependentServices = [];

  static final List<SingleChildWidget> _consumableServices = [];
}
