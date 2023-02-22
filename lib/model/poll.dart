import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'app_state.dart';

class Poll extends ChangeNotifier{
  final String title;
  final String code;
  final List<String> options;
  final DateTime deadline;
  final String creator;
  List<List<int>> votes;
  bool winnersCalculated = false;
  String? error;

  late List<int> scores;
  late List<int> runoffIndexes;
  late List<int> runoffScores;
  late int winnerIndex;
  Future<void> calculateWinners() async{
    scores = List.generate(options.length,
            (index) => votes.fold(0, (previousValue, element) => previousValue + element[index]));
    runoffIndexes = [0,0];
    int buffer = -1;
    for(int i = 0; i < options.length ; ++i){
      if (buffer == -1){ runoffIndexes[0] = i;buffer=i; continue;}
      if(scores[i] > scores[runoffIndexes[0]]) runoffIndexes[0] = i;
    }
    buffer = -1;
    for(int i = 0; i < options.length ; ++i){
      if(i == runoffIndexes[0]) continue;
      if(buffer == -1){ runoffIndexes[1] = i; buffer=i;continue;}
      if(scores[i] > scores[runoffIndexes[1]]) runoffIndexes[1] = i;
    }
    runoffScores = [0,0];
    for (var element in votes) {
      if (element[runoffIndexes[0]] > element[runoffIndexes[1]]) {
        runoffScores[0]++;
      } else if(element[runoffIndexes[1]] > element[runoffIndexes[0]]) {
        runoffScores[1]++;
      }
    }
    if(runoffScores[1] > runoffScores[0]) winnerIndex = runoffIndexes[1];
    else winnerIndex = runoffIndexes[0];
    winnersCalculated = true;
    notifyListeners();
  }
  Future<bool> getVotability(AppState appState) async{
    bool votable;
    try{
      await appState.fireBaseMutex.acquire();
      votable = !(await FirebaseFirestore.instance.collection("polls/$code/votes").doc(appState.userCredential?.user?.uid).get()).exists && deadline.isAfter(DateTime.now());
    }
    on FirebaseException catch (_){
      votable = false;
    }
    finally{
      appState.fireBaseMutex.release();
    }
    return votable;
  }
  void onVoteEvent(QuerySnapshot snap){
    votes = snap.docs.fold([], (previousValue, element) { previousValue.add(List.from(element.get("votes"))); return previousValue;});
    calculateWinners();
    notifyListeners();
  }
  static Future<Poll> getByCode(AppState appState,String code) async{
    Poll poll;
    try{
      await appState.fireBaseMutex.acquire();
      var db = FirebaseFirestore.instance.collection("polls");
      var pollDoc = await db.doc(code).get();
      if(pollDoc.exists){
        var votesDoc = (await FirebaseFirestore.instance.collection("polls/$code/votes").get()).docs;
        List<List<int>> votes = votesDoc.fold([], (previousValue, element) { previousValue.add(List.from(element.get("votes"))); return previousValue;});
        poll = Poll(code,pollDoc.get("title"),List.from(pollDoc.get("options")),DateTime.fromMillisecondsSinceEpoch(pollDoc.get("deadline").millisecondsSinceEpoch),pollDoc.get("uid"),votes,null);
        FirebaseFirestore.instance.collection("polls/$code/votes").snapshots().listen(poll.onVoteEvent);
        await poll.calculateWinners();
      }
      else{
        poll = Poll(code,"",[],DateTime.now(),"",[],"Does not exist");
      }
    }
    on FirebaseException catch(e){
      poll = Poll(code,"",[],DateTime.now(),"",[],e.message);
    }
    finally{
      appState.fireBaseMutex.release();
    }
    return poll;
  }
  Poll(this.code,this.title,this.options,this.deadline,this.creator,this.votes,this.error);
}