import 'package:furEmotion/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
  }

  void clearValue() {
    _user = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
    _user?.printInfo();
  }

  void updateUserWithoutNotify(User user) {
    _user = user;
  }

  bool isUserExist() {
    return _user != null;
  }
}
