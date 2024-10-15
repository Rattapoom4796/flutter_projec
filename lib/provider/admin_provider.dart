import 'package:flutter/material.dart';
import 'package:flutterpro/models/admin_model.dart';

class AdminProviders extends ChangeNotifier {
  String? _user;
  String? accesToken;
  String? refreshToken;

  String get user => _user!;
  String get accessToken => accesToken!;
  String get RefreshToken => refreshToken!;

  void onLogin(Admin adminModel) {
    _user = adminModel.admin.userName;
    accesToken = adminModel.accessToken;
    refreshToken = adminModel.refreshToken;
    notifyListeners();
  }

  void onLogout() {
    user;
    accesToken = null;
    refreshToken = null;
    notifyListeners();
  }

  void updadateAccessToken(String token) {
    accesToken = token;
    if (RefreshToken != null) {
      refreshToken = RefreshToken;
    }
    notifyListeners();
  }
}
