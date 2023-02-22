import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:polling_booth/model/poll.dart';

import 'app_state.dart';

class VotablePoll extends ChangeNotifier{
  final String _title;
  String code;
  String get title => _title;
  Map<String,int> _options;
  UnmodifiableMapView<String,int> get options => UnmodifiableMapView(_options);
  String? _error;
  String? get error => _error;
  void setScore(int index, int score){
    _options[_options.keys.elementAt(index)] = score;
    notifyListeners();
  }
  static VotablePoll fromPoll(Poll poll){
    Map<String,int> voteMap = {};
    for (var element in poll.options) {voteMap[element] = 0; }
    return VotablePoll(poll.code,poll.title, voteMap,null);
  }
  Future<void> submitVote(AppState appState) async {
    var voteList = [];
    options.forEach((key, value) {voteList.add(value); });
    try{
      _error = null;
      await appState.fireBaseMutex.acquire();
      await FirebaseFirestore.instance.collection("polls/$code/votes").doc(appState.userCredential!.user!.uid).set({"votes": voteList});
    }
    on FirebaseException catch(e){
      _error = e.message;
    }
    finally{
      appState.fireBaseMutex.release();
    }
  }
  VotablePoll(this.code,this._title,this._options,this._error);
}