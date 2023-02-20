import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget{
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String text;
  const StatusCard(this.backgroundColor,this.foregroundColor,this.text,{super.key});
  @override
  Widget build(BuildContext context){
    return Card(
      color: backgroundColor ?? Theme.of(context).colorScheme.primary,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          Center(
              child: Text(
                text,
                style: TextStyle(
                    color: foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              )
          )
      ),
    ) ;
  }
}