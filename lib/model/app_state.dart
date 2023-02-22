import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AppStates{
  loggingIn,
  loggedIn,
  loginFailed
}

class AppState extends ChangeNotifier {
  ThemeMode? _themeMode;
  ThemeMode? get themeMode => (_themeMode == null) ? ThemeMode.system : _themeMode;
  bool get useSystemTheme => (_themeMode == null);
  UserCredential? userCredential;
  AppStates? _appStateOverride;
  AppStates get appStates {
    if(_appStateOverride != null) return _appStateOverride!;
    if(userCredential == null) {
      return AppStates.loggingIn;
    } else if(userCredential?.credential == null) {
      return AppStates.loginFailed;
    } else {
      return AppStates.loggedIn;
    }
  }
  void startLogin() async{
    try {
      userCredential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch(e){
      _appStateOverride = AppStates.loginFailed;
    }
    notifyListeners();
  }
  void toggleSystemThemeMode(){
    _themeMode = _themeMode == null ? ThemeMode.light : null;
    notifyListeners();
  }
  void toggleDarkMode(){
    if (_themeMode == null) return;
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
