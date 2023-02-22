import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/model/app_state.dart';
import 'package:polling_booth/screens/home_screen.dart';
import 'package:polling_booth/screens/fatal_error_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  var fireBaseSupported = true;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
  }
  on UnsupportedError catch(_){
    fireBaseSupported = false;
  }
  runApp(MyApp(fireBaseSupported));
}

class MyApp extends StatelessWidget {
  final bool fireBaseSupported;
  final appState = AppState();
  MyApp(this.fireBaseSupported,{super.key});
  static final _defaultLightColorScheme =
  ColorScheme.fromSwatch(primarySwatch: Colors.red);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.red, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    appState.startLogin();
    return DynamicColorBuilder(builder:(lightScheme,darkScheme){
    return ChangeNotifierProvider<AppState>(
      create: (context) => appState,
      child:
        Consumer<AppState>(
          builder: (context,appState,child) {
            return MaterialApp(
              title: 'StarBooth',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightScheme ?? _defaultLightColorScheme),
              themeMode: appState.themeMode ,
              darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: darkScheme ?? _defaultDarkColorScheme),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) {
                  if(!fireBaseSupported) return const FatalErrorScreen(FatalErrors.fireBaseUnsupported);
                  switch(appState.appStates){
                    case AppStates.loginFailed:
                      return const FatalErrorScreen(FatalErrors.loginFailed);
                    case AppStates.loggingIn:
                      return const Center(child: CircularProgressIndicator());
                    case AppStates.loggedIn:
                      return const HomeScreen();
                  }
                }
              )
            );
          }
        )
    );
    }
    );
  }
}
