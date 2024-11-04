import 'dart:html';

class StorageService {
  void saveData(String key, String value) {
    window.localStorage[key] = value;
  }

  String? loadData(String key) {
    return window.localStorage[key];
  }
}
