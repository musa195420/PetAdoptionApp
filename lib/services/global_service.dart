import 'package:flutter/material.dart';
import 'package:petadoption/models/hive_models/user.dart';
import 'package:petadoption/services/logging_service.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/services/pref_service.dart';

import '../helpers/constants.dart';
import '../viewModel/favourite_viewmodel.dart';

class GlobalService {
  PrefService get _prefService => locator<PrefService>();
  LoggingService get _loggingService => locator<LoggingService>();
  FavouriteViewmodel get favouriteViewmodel => locator<FavouriteViewmodel>();
  User? _user = User(
      userId: '1',
      email: 'user@gmail.com',
      phoneNumber: '324234234324',
      password: 'Connect@32434',
      role: 'Adopter',
      deviceId: '4353455345');

  User? getuser() {
    return _user;
  }

  setuser(value) {
    _user = value;
  }

  Future<void> getfavourites() async {
    await favouriteViewmodel.getFavourites();
  }

  log(String message, {bool vti = false}) {
    if (vti) {
      _loggingService.logVti(message);
    } else {
      _loggingService.logInfo(message);
    }
  }

  logCC(String message, {bool request = false}) {
    _loggingService.logCC(message, request: request);
  }

  logError(String message, dynamic error, StackTrace? stack) {
    _loggingService.logError(message, error, stack);
  }

  logWarning(String message) {
    _loggingService.logWarning(message);
  }

  init() async {
    try {
      if (await _prefService.getBool(PrefKey.isProduction)) {
      } else {}
    } catch (e, s) {
      logError("Error Occured When Init Global Service", e.toString(), s);
      debugPrint(e.toString());
    }
  }

  Future<String> getHost() async {
    try {
      if (await _prefService.getBool(PrefKey.isProduction)) {
        return server_url;
      }
    } catch (e, s) {
      logError("Error Occured When get Host", e.toString(), s);
      debugPrint(e.toString());
    }
    return server_url;
  }
}
