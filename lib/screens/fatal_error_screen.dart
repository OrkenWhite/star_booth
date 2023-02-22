import 'package:flutter/material.dart';
import 'package:polling_booth/widgets/action_button.dart';
import 'package:polling_booth/widgets/status_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/app_state.dart';

enum FatalErrors{
  loginFailed,
  fireBaseUnsupported,
  serviceUnavailable
}

class FatalErrorScreen extends StatelessWidget{
  final FatalErrors reason;
  const FatalErrorScreen(this.reason,{super.key});

  @override
  Widget build(BuildContext context){
    AppState appState = Provider.of(context);
    var locProvider = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    return Padding(
      padding:const  EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StatusCard(theme.colorScheme.error, theme.colorScheme.onError, reason == FatalErrors.loginFailed ? locProvider.loginFailed : reason == FatalErrors.serviceUnavailable ? locProvider.serviceUnavailable : locProvider.unsupportedPlatform),
          if (reason == FatalErrors.loginFailed) const SizedBox(height: 30.0), if (reason == FatalErrors.loginFailed) ActionButton(() { appState.startLogin(); }, locProvider.retry)
        ],
      ),
    );
  }
}