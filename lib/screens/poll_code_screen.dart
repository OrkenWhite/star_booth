import 'package:flutter/material.dart';
import 'package:polling_booth/model/new_poll_model.dart';
import 'package:polling_booth/screens/result_screen.dart';
import 'package:polling_booth/widgets/action_button.dart';
import 'package:polling_booth/widgets/status_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

import '../model/poll.dart';

class PollCodeScreen extends StatelessWidget {
  final NewPollModel newPoll;
  const PollCodeScreen(this.newPoll,{super.key});
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            title: Text(newPoll.title),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, left: 10,right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: StatusCard(
                          null,null,locProvider.pollCreated
                        ),
                      ),
                    )],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              locProvider.votingCode,
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0) ,
                              child: Text(
                                  newPoll.code ?? "????",
                                  style: TextStyle(fontSize: 30.0,color: Theme.of(context).colorScheme.primary),
                              ),
                            ),
                            ActionButton(() {Clipboard.setData(ClipboardData(text: newPoll.code)); }, locProvider.copy)
                          ],
                        ),
                      ),
                  ),
                    )],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [ActionButton(() async {
                    Poll poll = await Poll.getByCode(Provider.of(context,listen: false), newPoll.code ?? "");
                    Navigator.of(context).push((MaterialPageRoute(builder:(_) =>
                        ChangeNotifierProvider(
                          create: (context) => poll,
                          child: const ResultScreen(true),) )));
                  }, locProvider.liveResults)],
                )
              ],
            ),
          ));
  }
}
