import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/model/new_poll_model.dart';
import 'package:polling_booth/screens/about_star.dart';
import 'package:polling_booth/widgets/card_button.dart';
import 'package:provider/provider.dart';

import 'new_vote.dart';

enum BarMenuItem {showAboutDialog}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var iconColor = Theme.of(context).canvasColor.computeLuminance() > 0.5 ? Theme.of(context).primaryColor : Colors.white;
    var orientation = MediaQuery.of(context).orientation;
    var locProvider = AppLocalizations.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(locProvider?.appName ?? "StarBooth",style:const TextStyle(fontFamily: 'cursive')),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: PopupMenuButton<BarMenuItem>(
                onSelected: (value) {
                  switch(value){
                    case BarMenuItem.showAboutDialog:
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(locProvider?.about ?? "About"),
                            content: Text((locProvider?.appName ?? "StarBooth") + "\r\n" + (locProvider?.copyright ?? "(C) 2023 Patrik Fábián") ),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: (){Navigator.of(context).pop(context);},
                                  child: Text(locProvider?.ok ?? "OK")
                              )
                            ],
                          )
                      );
                      break;
                    default:
                      throw UnimplementedError();
                  }
                },
                itemBuilder: (_) => <PopupMenuItem<BarMenuItem>>[
                  PopupMenuItem<BarMenuItem>(
                      value: BarMenuItem.showAboutDialog,
                      onTap: () {

                      },
                      child:
                        Row(
                          children:[
                            Icon(Icons.question_mark_rounded,color: iconColor),
                            const SizedBox(width: 10),
                            Text(locProvider?.about ?? "About")
                          ]
                        )
                  )
                ]
              ),
            )
          ],
        ),
        body: Padding(
            padding: EdgeInsets.only(
                left: 25.0, right: 25.0, top: orientation == Orientation.portrait ? 160.0 : 25.0, bottom: orientation == Orientation.portrait ? 160.0 : 25.0),
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
                          child: CardButton(
                              Icons.add,
                              locProvider?.newPoll ??
                                  "New poll",
                              () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context){
                                        return ChangeNotifierProvider(
                                            create:(context) => NewPollModel(),
                                            child: const NewVoteScreen()
                                        );
                                      }
                                    ));
                              }),
                        ),
                        const SizedBox(width:40.0),
                        Expanded(
                          child: CardButton(Icons.how_to_vote_rounded,locProvider?.enterCode ?? "Enter code",(){}),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height:40.0),
                  Expanded(
                      child: Row(children: [
                    Expanded(
                        child: CardButton(
                            Icons.star_border,
                            locProvider?.aboutStar ??
                                "About STAR voting...",
                            () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => const AboutStarScreen()));
                            })),
                  ])),
                ])));
  }
}
