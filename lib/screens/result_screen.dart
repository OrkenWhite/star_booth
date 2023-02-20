import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/poll.dart';
import '../widgets/score_card.dart';

class ResultScreen extends StatelessWidget {
  final Poll poll;
  final bool canGoBack;
  const ResultScreen(this.poll,this.canGoBack,{super.key});
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var winnerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary
    );
    return Scaffold(
        appBar: AppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(canGoBack) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          }),
      centerTitle: true,
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Theme.of(context).primaryColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white,
      title: Text(locProvider.liveResults),
    ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(poll.title,style:theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: poll.options.length,
                    itemBuilder: (context,index) => ScoreCard(
                      poll.options.keys.elementAt(index),
                      poll.options[poll.options.keys.elementAt(index)]!,
                        (index < 2)
                    )
                ),
              ),
              SizedBox.fromSize(size: const Size(1.0,15.0)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(locProvider.automaticRunoff,style:theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
              ),
              Expanded(child: ListView.builder(
                  itemCount: poll.runoffOptions!.length,
                  itemBuilder: (context,index) => ScoreCard(
                      poll.runoffOptions!.keys.elementAt(index),
                      poll.runoffOptions![poll.runoffOptions!.keys.elementAt(index)]!,
                      (index == 0))
              )
              ),
              Text("${locProvider.winner}: ${poll.runoffOptions!.keys.first}",style: winnerStyle)
            ],
          )
        )
      );
  }
}
