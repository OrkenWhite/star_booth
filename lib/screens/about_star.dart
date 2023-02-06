import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutStarScreen extends StatelessWidget{
  const AboutStarScreen({super.key});
  @override
  Widget build(BuildContext context){
    var locProvider = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {Navigator.of(context).pop();}
        ) ,
        title: Text(locProvider?.aboutStar ?? "About STAR voting...")
    ),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  child:
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        locProvider?.starDescription ?? "Star voting description missing"
                      ),
                    )
            ),
              )],
          )
      )
    );
  }
}