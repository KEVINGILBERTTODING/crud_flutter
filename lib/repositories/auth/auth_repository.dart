import 'package:crud_flutter/constants/auth/auth_constans.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future<void> saveUserInfo(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthConstants.sfUsername, username);
  }

  Future<bool> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(AuthConstants.sfUsername);
    return username != null;
  }

  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(AuthConstants.sfUsername);
    String? unmd = '';
    if (username != null) {
      unmd = username;
    } else {
      unmd = 'Guest';
    }
    return unmd;
  }
}
