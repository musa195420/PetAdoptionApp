import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BaseViewModel extends ChangeNotifier {
  bool _busy;
  bool _isDisposed = false;
  bool _spinner = false;
  bool _listSpinner = false;
  bool _loadMoreSpinner = false;

  BaseViewModel({
    bool busy = false,
  }) : _busy = busy;

  bool get busy => _busy;
  bool get spinner => _spinner;
  bool get listSpinner => _listSpinner;
  bool get loadMoreSpinner => _loadMoreSpinner;
  bool get isDisposed => _isDisposed;

  setBusy(bool busy) async {
    _busy = busy;
  }

  setSpinner(bool spinner) async {
    _spinner = spinner;
    notifyListeners();
  }

  setListSpinner(bool listSpinner) async {
    _listSpinner = listSpinner;
    notifyListeners();
  }

  setLoadMoreSpinner(bool loadMoreSpinner) async {
    _loadMoreSpinner = loadMoreSpinner;
    notifyListeners();
  }

  Future<void> loading(bool state, {loadingText = 'Loading...'}) async {
    if (state) {
      await EasyLoading.show(status: loadingText);
    } else {
      await EasyLoading.dismiss();
    }
  }

  @override
  void notifyListeners() {
    if (!isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
