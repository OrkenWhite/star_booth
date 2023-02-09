import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewVoteScreen extends StatelessWidget{
  const NewVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {Navigator.of(context).pop();}
        ) ,
        centerTitle: true,
        actions: [
          Padding(
            padding:const EdgeInsets.only(right: 5.0),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: (){},
            )
          )
        ],
        title: Text(locProvider?.newPoll ?? "New poll..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column()
      )
    );
  }

}