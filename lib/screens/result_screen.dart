import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../model/app_state.dart';
import '../model/poll.dart';
import '../widgets/score_card.dart';

class ResultScreen extends StatelessWidget {
  final bool canGoBack;
  const ResultScreen(this.canGoBack,{super.key});
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var winnerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary
    );
    return Consumer<Poll>(
      builder: (context,poll,child) => Scaffold(
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
                          poll.options[index],
                          poll.scores[index],
                          poll.runoffIndexes.contains(index)
                      )
                  ),
                ),
                SizedBox.fromSize(size: const Size(1.0,15.0)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(locProvider.automaticRunoff,style:theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                ),
                Expanded(child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context,index) => ScoreCard(
                        poll.options[poll.runoffIndexes[index]],
                        poll.runoffScores[index],
                        (poll.runoffIndexes[index] == poll.winnerIndex))
                )
                ),
                Text("${locProvider.winner}: ${poll.options[poll.winnerIndex]}",style: winnerStyle)
              ],
            )
          )
        ),
    );
  }
}
