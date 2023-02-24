import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutStarScreen extends StatelessWidget {
  const AboutStarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
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
            title: Text(locProvider.aboutStar)),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Card(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Text(locProvider.starDescriptionLead),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0,bottom: 8.0),
                            child: Text(locProvider.voteCounting,style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.center),
                          ),
                          Text(locProvider.starDescriptionVoteCounting),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Image(image: const AssetImage("assets/star_infographic.jpg"),width: MediaQuery.of(context).size.width / 2),
                          ),
                          TextButton(onPressed:() async{
                            if(await canLaunch("https://starvoting.org/star")){
                              launchUrl(Uri.parse("https://starvoting.org/star"));
                            }
                          }, child: Text(locProvider.aboutStarFurtherRead))
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            )));
  }
}
