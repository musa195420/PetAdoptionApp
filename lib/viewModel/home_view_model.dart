
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import 'package:petadoption/viewModel/startup_viewmodel.dart';
class HomeViewModel extends BaseViewModel {
  
  
  
  StartupViewModel get _startupViewModel => locator<StartupViewModel>();

  bool checkVersion = true;
Future<void>logout() async {
await   _startupViewModel.logout();
}
}
