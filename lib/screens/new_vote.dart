import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:polling_booth/model/new_poll_model.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;


class NewVoteScreen extends StatelessWidget{
  const NewVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context);
    return Consumer<NewPollModel>(
        builder: (context,newPoll,child) {
          var dateController = TextEditingController();
          dateController.text =
          "${DateFormat.yMd(Localizations.maybeLocaleOf(context)?.toLanguageTag()).format(newPoll.deadline)} ${DateFormat('Hm',Localizations.maybeLocaleOf(context)?.toLanguageTag()).format(newPoll.deadline)}";
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
              onPressed: (){newPoll.submitPoll();},
            )
          )
        ],
        title: Text(locProvider?.newPoll ?? "New poll..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                        initialValue: newPoll.title,
                        onChanged: (newTitle) => newPoll.setTitle(newTitle),
                        decoration: InputDecoration(
                          label: Text(locProvider?.title ?? "Title"),
                          border: const OutlineInputBorder()
                        ),
                      ),
                    ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                         ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: newPoll.options.length,
                              itemBuilder: (BuildContext context, int index) {
                                var controller = TextEditingController(text: newPoll.options[index]);
                                controller.text = newPoll.options[index];
                                return
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextField(
                                      controller: controller,
                                      onChanged: (newOption) =>
                                          newPoll.setOption(newOption, index),
                                      decoration: InputDecoration(
                                          label: Text(
                                              (locProvider?.option ?? "Option") + " " + (index + 1).toString()
                                          ),
                                          border: const OutlineInputBorder(),
                                          suffixIcon: index > 0 ?
                                          Transform.rotate(
                                            angle: math.pi / 4,
                                            child: IconButton(
                                                onPressed: () => newPoll.removeOption(index),
                                                icon: const Icon(Icons.add)
                                            ),
                                          ) : null
                                      ),
                                    ),
                                  );
                              },
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                             ElevatedButton(
                                    onPressed: (){newPoll.addOption("");},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        shape: const OvalBorder(eccentricity: 0.0),
                                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    child: const Icon(Icons.add)
                                ),
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: dateController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        label: Text(locProvider?.deadline ?? "Vote ends"),
                        suffixIcon: const Icon(Icons.date_range)
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? day = await showDatePicker(
                            context: context,
                            initialDate: newPoll.deadline.compareTo(DateTime.now()) > 0 ? newPoll.deadline : DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365 * 5))
                        );
                        if(day != null){
                          TimeOfDay? time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now()
                          );
                          if(time != null){
                            newPoll.setDeadline(day.add(Duration(hours: time.hour,minutes: time.minute)));
                          }
                        }
                      },
                    ),
                  )
                ],
              )
          ),
        )
      );
    }
    );
  }

}