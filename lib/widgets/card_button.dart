import 'package:flutter/material.dart';

class CardButton extends StatelessWidget{
  final IconData icon;
  final String text;
  final Function() onPressed;
  const CardButton(this.icon,this.text,this.onPressed, {super.key});
  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)
          )
        ) ,
        child:
        Padding(
          padding: const EdgeInsets.all(5.0),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,size: 64.0),
              Text(text,textAlign: TextAlign.center,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0))
            ],
          ),
        )
    );
 }
}