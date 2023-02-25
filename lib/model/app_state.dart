import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mutex/mutex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:polling_booth/model/poll.dart';

enum AppStates{
  loggingIn,
  loggedIn,
  loginFailed,
}

class AppState extends ChangeNotifier {
  ThemeMode? _themeMode;
  final fireBaseMutex = Mutex();
  ThemeMode? get themeMode => (_themeMode == null) ? ThemeMode.system : _themeMode;
  bool get useSystemTheme => (_themeMode == null);
  UserCredential? userCredential;
  AppStates? _appStateOverride;
  Poll? currentPoll;
  PackageInfo? packageInfo;
  bool? notMaterial3Compatible;
  bool? canSystemTheme;
  AppStates get appStates {
    if(_appStateOverride != null) return _appStateOverride!;
    if(userCredential == null) {
      return AppStates.loggingIn;
    } else if(userCredential?.user == null) {
      return AppStates.loginFailed;
    } else {
      return AppStates.loggedIn;
    }
  }
  void startLogin() async{
    try {
      _appStateOverride = null;
      userCredential = null;
      await fireBaseMutex.acquire();
      userCredential = await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch(e){
      _appStateOverride = AppStates.loginFailed;
    }
    finally{
      fireBaseMutex.release();
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
  void getPackageInfo() async{
    packageInfo = await PackageInfo.fromPlatform();
  }
  void getCompatibilityMode() async{
    if(Platform.isAndroid){
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      notMaterial3Compatible = androidInfo.version.sdkInt < 31;
      canSystemTheme = androidInfo.version.sdkInt  >= 29;
      if(!canSystemTheme!) _themeMode = ThemeMode.light;
    }
    else{
      notMaterial3Compatible = false;
    }
  }
  void initEnvData() async{
    getPackageInfo();
    getCompatibilityMode();
  }
}
