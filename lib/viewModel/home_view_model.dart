import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/db_service.dart';
import 'package:petadoption/services/dialog_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/services/navigation_service.dart';
import 'package:petadoption/services/pref_service.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import '../models/request_models/refresh_token_request.dart';
import '../models/response_models/refresh_token_response.dart';
import 'package:http/http.dart' as http;
class HomeViewModel extends BaseViewModel {
  PrefService get _prefService => locator<PrefService>();
  NavigationService get _navigationService => locator<NavigationService>();
  
  IDialogService get _dialogService => locator<IDialogService>();
  IAPIService get _apiService => locator<IAPIService>();
  
  GlobalService get _globalService => locator<GlobalService>();

  bool checkVersion = true;
Future<void> uploadProfileImage() async {
  String userId= _globalService.getuser()!.userId;
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile == null) return;

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('${await _globalService.getHost()}/api/users/upload-profile'),
  );

  request.fields['user_id'] = userId;
  request.files.add(await http.MultipartFile.fromPath('image', pickedFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    print("Upload successful");
    final responseBody = await response.stream.bytesToString();
    print(responseBody); // Contains image URL
  } else {
    print("Upload failed with status: ${response.statusCode}");
  }
}
}
