import 'package:flutter/material.dart';
import 'package:polling_booth/model/poll.dart';
import 'package:polling_booth/screens/result_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/action_button.dart';

class VoteScreen extends StatelessWidget {
  const VoteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Consumer<Poll>(
      builder: (context, poll, child) => Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor:
                  Theme.of(context).primaryColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
              title: Text(locProvider.vote)),
          body: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0,bottom: 25.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child:
                        Text(poll.title, style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.primary)),
                  ),
                  Text(
                    locProvider.voteHelp,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ListView.builder(
                          itemCount: poll.options.length,
                          itemBuilder: (context, i) {
                            return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 125,child: Text(poll.options.keys.elementAt(i))),
                                      Row(
                                        children: [
                                          Slider(
                                              min: 0.0,
                                              max: 5.0,
                                              value: poll.options[poll
                                                      .options.keys
                                                      .elementAt(i)]!
                                                  .toDouble(),
                                              onChanged: (it) {
                                                poll.setScore(i, it.toInt());
                                              }),
                                          Text(poll.options[poll.options.keys
                                                  .elementAt(i)]!
                                              .toString())
                                        ],
                                      )
                                    ],
                                  ),
                                )));
                          }),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(children: [
                        Expanded(child: ActionButton(() {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                      Poll(
                                          "Test title",
                                          {
                                            "Test option 1 about the long text present here":
                                            2311,
                                            "Test option 2": 1211,
                                            "Test option 3": 333
                                          },
                                          {"Test option 1 about the long text present here":
                                          1111, "Test option 2": 1222,},
                                          false,
                                          null)
                                      ,false
                                  )
                              )
                          );
                        }, locProvider.submit))
                      ]))
                ],
              ))),
    );
  }
}
