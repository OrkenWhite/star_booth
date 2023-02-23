import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget{
  final String label;
  final void Function() onClick;
  const ActionButton(this.onClick,this.label, {super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
            foregroundColor: Theme.of(context)
                .colorScheme
                .onPrimary,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary,
        minimumSize: const Size(70.0,50.0)),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0)),
        )
    );
  }

}