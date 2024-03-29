import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:polling_booth/screens/result_screen.dart';
import 'package:polling_booth/screens/vote_screen.dart';
import 'package:polling_booth/widgets/action_button.dart';
import 'package:provider/provider.dart';

import '../model/app_state.dart';
import '../model/poll.dart';
import '../model/votable_poll.dart';
import '../widgets/status_card.dart';

enum CodeValidationStatus { tooShort, invalid, validating, valid }

class VoteJoinState extends State<VoteJoinScreen> {
  var status = CodeValidationStatus.tooShort;
  var code = "";
  var codeInputController = TextEditingController();
  Future<void> validateCode(AppState appState) async{
    if(code.length != 5){
      setState(() {
        status = code.length < 2 ? CodeValidationStatus.tooShort : CodeValidationStatus.invalid;
      });
      return;
    }
    try{
      setState(() {
        status = CodeValidationStatus.validating;
      });
      await appState.fireBaseMutex.acquire();
      var poll = await FirebaseFirestore.instance.collection("polls").doc(code).get();
      setState(() {
        status = poll.exists ? CodeValidationStatus.valid : CodeValidationStatus.invalid;
      });
    }
    finally{
      appState.fireBaseMutex.release();
    }
  }
  Future<void> navigateWithVoteCode(AppState appState,NavigatorState navigator,String code) async{
    appState.currentPoll = await Poll.getByCode(appState, code);
    if(appState.currentPoll?.error != null) return;
    if(await appState.currentPoll!.getVotability(appState)){
      navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create:(context) => VotablePoll.fromPoll(appState.currentPoll!),child: const VoteScreen())), (route) => route.isFirst);
    }
    else{
      navigator.pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ChangeNotifierProvider(create: (context) => appState.currentPoll!,child: const ResultScreen(true))), (route) => route.isFirst);
    }
  }
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    AppState appState = Provider.of(context);
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
        body: SingleChildScrollView(
          child: Padding(
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
                          child: Text(locProvider.codeEntryHelp,textAlign: TextAlign.center,style: theme.textTheme.titleMedium?.copyWith(fontSize: 20))),
                      TextField(
                        controller: codeInputController,
                        onChanged: (it) {
                          code = it.toUpperCase();
                          validateCode(appState);
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
                                  navigateWithVoteCode(appState, Navigator.of(context), code);
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
