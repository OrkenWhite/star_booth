import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/model/app_state.dart';
import 'package:polling_booth/screens/home_screen.dart';
import 'package:polling_booth/screens/login_failed_screen.dart';
import 'package:polling_booth/screens/poll_code_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
    return DynamicColorBuilder(builder:(lightScheme,darkScheme){
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
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
                builder: (context) => const LoginFailedScreen()
              )
            );
          }
        )
    );
    }
    );
  }
}
