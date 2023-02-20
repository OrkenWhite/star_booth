import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/screens/vote_screen.dart';
import 'package:polling_booth/widgets/action_button.dart';
import 'package:provider/provider.dart';

import '../model/poll.dart';
import '../widgets/status_card.dart';

enum CodeValidationStatus { tooShort, invalid, validating, valid }

class VoteJoinState extends State<VoteJoinScreen> {
  var status = CodeValidationStatus.tooShort;
  var code = "";
  var codeInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Scaffold(
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
          title: Text(locProvider.enterCode),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status != CodeValidationStatus.tooShort) Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: (status == CodeValidationStatus.invalid)
                      ? StatusCard(theme.colorScheme.error,
                          theme.colorScheme.onError, locProvider.codeInvalid)
                      : status == CodeValidationStatus.valid
                          ? StatusCard(null, null, locProvider.codeValid)
                          : (status == CodeValidationStatus.validating)
                              ? const Center(child: CircularProgressIndicator())
                              : null),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 22),
                        child: Text(locProvider.codeEntryHelp,style: theme.textTheme.titleMedium?.copyWith(fontSize: 20))),
                    TextField(
                      controller: codeInputController,
                      onChanged: (it) {
                        setState(() {
                          code = it;
                          status = it.length == 5
                              ? CodeValidationStatus.valid
                              : CodeValidationStatus.invalid;
                        });
                      },
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: theme.colorScheme.primary),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          label: Text(locProvider.code)),
                    ),
                    if (status == CodeValidationStatus.valid)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: ActionButton(() {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                          create: (context) => Poll(
                                              "Test title",
                                              {
                                                "Test option 1 about the long text present here":
                                                    0,
                                                "Test option 2": 0,
                                                "Test option 3": 0
                                              },
                                              null,
                                              true,
                                              null),
                                          child: const VoteScreen(),
                                        )));
                              }, locProvider.join),
                            ),
                          )
                        ],
                      )
                  ],
                ),
              )),
            ],
          ),
        ));
  }
}

class VoteJoinScreen extends StatefulWidget {
  const VoteJoinScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return VoteJoinState();
  }
}
