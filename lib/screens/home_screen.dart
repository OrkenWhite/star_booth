import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/model/new_poll_model.dart';
import 'package:polling_booth/screens/about_star.dart';
import 'package:polling_booth/screens/vote_join_screen.dart';
import 'package:polling_booth/widgets/card_button.dart';
import 'package:provider/provider.dart';

import '../model/app_state.dart';
import 'new_vote.dart';

enum BarMenuItem { showAboutDialog, useSystemTheme, toggleDarkMode }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).canvasColor.computeLuminance() > 0.5
        ? Theme.of(context).primaryColor
        : Colors.white;
    var orientation = MediaQuery.of(context).orientation;
    var locProvider = AppLocalizations.of(context)!;
    AppState appState = Provider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(locProvider.appName,
              style: const TextStyle(fontFamily: 'cursive', fontSize: 32.0)),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor:
              Theme.of(context).primaryColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton<BarMenuItem>(
                  onSelected: (value) {
                    switch (value) {
                      case BarMenuItem.showAboutDialog:
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text(locProvider.about),
                                  content: Text(
                                      "${locProvider.appName}\r\n${locProvider.copyright}"),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(context);
                                        },
                                        child: Text(locProvider.ok))
                                  ],
                                ));
                        break;
                      case BarMenuItem.useSystemTheme:
                        appState.toggleSystemThemeMode();
                        break;
                      case BarMenuItem.toggleDarkMode:
                        appState.toggleDarkMode();
                        break;
                      default:
                        throw UnimplementedError();
                    }
                  },
                  itemBuilder: (_) => <PopupMenuItem<BarMenuItem>>[
                        PopupMenuItem<BarMenuItem>(
                            value: BarMenuItem.useSystemTheme,
                            onTap: () {},
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Icon(Icons.phone_android, color: iconColor),
                                    const SizedBox(width: 10),
                                    Text(locProvider.useSystemTheme)
                                  ]),
                                  Text(appState.useSystemTheme
                                      ? locProvider.on
                                      : locProvider.off)
                                ])),
                        PopupMenuItem<BarMenuItem>(
                            value: BarMenuItem.toggleDarkMode,
                            enabled: !appState.useSystemTheme,
                            onTap: () {},
                            child: Row(children: [
                              Icon(appState.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode, color: iconColor),
                              const SizedBox(width: 10),
                              Text(
                                  "${appState.themeMode == ThemeMode.dark ? locProvider.light : locProvider.dark} ${locProvider.mode}")
                            ])),
                    PopupMenuItem<BarMenuItem>(
                        value: BarMenuItem.showAboutDialog,
                        onTap: () {},
                        child: Row(children: [
                          Icon(Icons.question_mark_rounded,
                              color: iconColor),
                          const SizedBox(width: 10),
                          Text(locProvider.about)
                        ]))
                      ]),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(
                left: 25.0,
                right: 25.0,
                top: orientation == Orientation.portrait ? 160.0 : 25.0,
                bottom: orientation == Orientation.portrait ? 160.0 : 25.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: CardButton(Icons.add, locProvider.newPoll, () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                  create: (context) => NewPollModel(appState),
                                  child: NewVoteScreen());
                            }));
                          }),
                        ),
                        const SizedBox(width: 40.0),
                        Expanded(
                          child: CardButton(
                              Icons.how_to_vote_rounded, locProvider.enterCode,
                              () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return const VoteJoinScreen();
                            }));
                          }),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  Expanded(
                      child: Row(children: [
                    Expanded(
                        child: CardButton(
                            Icons.star_border, locProvider.aboutStar, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AboutStarScreen()));
                    })),
                  ])),
                ])));
  }
}
