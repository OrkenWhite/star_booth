import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:polling_booth/model/new_poll_model.dart';
import 'package:polling_booth/screens/fatal_error_screen.dart';
import 'package:polling_booth/screens/poll_code_screen.dart';
import 'package:polling_booth/widgets/status_card.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class NewVoteScreen extends StatelessWidget {
  NewVoteScreen({super.key});
  final dateController = TextEditingController();
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Consumer<NewPollModel>(builder: (context, newPoll, child) {
      codeController.text = newPoll.code ?? "";
      String? titleError =
          newPoll.title.length < 4 ? locProvider.titleTooShort : null;
      var validForm = titleError == null && newPoll.fatalError == null && newPoll.options.length >= 2 &&
          newPoll.options.fold(true, (previousValue, element) => previousValue && element.length >= 2) &&
          newPoll.deadline.compareTo(DateTime.now()) > 0;
      dateController.text =
          "${DateFormat.yMd(Localizations.maybeLocaleOf(context)?.toLanguageTag()).format(newPoll.deadline)} ${DateFormat('Hm', Localizations.maybeLocaleOf(context)?.toLanguageTag()).format(newPoll.deadline)}";
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
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: (validForm ? IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      newPoll.submitPoll().then((value) => (newPoll.error == null) ? Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                            return PollCodeScreen(newPoll);
                      }),(r) => r.isFirst) : null);
                    },
                  ) : null)
              )
            ],
            title: Text(locProvider.newPoll),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: newPoll.fatalError != null
                ? const FatalErrorScreen(FatalErrors.serviceUnavailable)
                : newPoll.appState.fireBaseMutex.isLocked
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (newPoll.error != null) Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: StatusCard(
                                  theme.colorScheme.error,
                                  theme.colorScheme.onError,
                                  locProvider.submitPollError)),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: codeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                  label: Text(locProvider.code),
                                  border: const OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextFormField(
                              initialValue: newPoll.title,
                              onChanged: (newTitle) =>
                                  newPoll.setTitle(newTitle),
                              decoration: InputDecoration(
                                  label: Text(locProvider.title),
                                  errorText: titleError,
                                  border: const OutlineInputBorder()),
                            ),
                          ),
                          Card(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                if(newPoll.options.length < 2) StatusCard(theme.colorScheme.error,theme.colorScheme.onError, locProvider.needMoreOptions),
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: newPoll.options.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        initialValue: newPoll.options[index],
                                        onChanged: (newOption) =>
                                            newPoll.setOption(newOption, index),
                                        decoration: InputDecoration(
                                            errorText: newPoll.options[index].length < 2 ? locProvider.optionTooShort : null,
                                            label: Text(
                                                "${locProvider.option} ${index + 1}"),
                                            border: const OutlineInputBorder(),
                                            suffixIcon: index > 0
                                                ? Transform.rotate(
                                                    angle: math.pi / 4,
                                                    child: IconButton(
                                                        onPressed: () => newPoll
                                                            .removeOption(
                                                                index),
                                                        icon: const Icon(
                                                            Icons.add)),
                                                  )
                                                : null),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          newPoll.addOption("");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: const OvalBorder(
                                              eccentricity: 0.0),
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        child: const Icon(Icons.add)),
                                  ],
                                )
                              ],
                            ),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: dateController,
                              decoration: InputDecoration(
                                errorText: newPoll.deadline.compareTo(DateTime.now()) <= 0 ? locProvider.needLaterDate : null,
                                  border: const OutlineInputBorder(),
                                  label: Text(
                                      locProvider.deadline ?? "Vote ends"),
                                  suffixIcon: const Icon(Icons.date_range)),
                              readOnly: true,
                              onTap: () async {
                                DateTime? day = await showDatePicker(
                                    context: context,
                                    initialDate: newPoll.deadline
                                                .compareTo(DateTime.now()) >
                                            0
                                        ? newPoll.deadline
                                        : DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365 * 5)));
                                if (day != null) {
                                  TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now());
                                  if (time != null) {
                                    newPoll.setDeadline(day.add(Duration(
                                        hours: time.hour,
                                        minutes: time.minute)));
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      )),
          ));
    });
  }
}
