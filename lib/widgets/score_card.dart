import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget{
  final String option;
  final int score;
  final bool winner;
  const ScoreCard(this.option,this.score,this.winner,{super.key});
  @override
  Widget build(BuildContext context){
    var theme = Theme.of(context);
    var winnerStyle = TextStyle(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0) ,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(option,
                    style: (winner) ? winnerStyle : null
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(score.toString(),style: (winner) ? winnerStyle : null),
                    Icon(winner ? Icons.check : Icons.star,color: (winner) ? theme.colorScheme.primary : null)
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }
}