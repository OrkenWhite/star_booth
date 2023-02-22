import 'dart:collection';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_state.dart';

class NewPollModel extends ChangeNotifier{
  AppState appState;
  Random _random = Random();
  String _title = "";
  String get title => _title;
  final List<String> _options = [""];
  UnmodifiableListView<String> get options => UnmodifiableListView<String>(_options);
  DateTime _deadline = DateTime.now();
  DateTime get deadline => _deadline;
  String? _error;
  String? get error => _error;
  String? _fatalError;
  String? get fatalError => _fatalError;
  String? _code;
  String? get code => _code;
  NewPollModel(this.appState){
    setRandomCode();
  }
  void setTitle(String newTitle){
    _title = newTitle;
    notifyListeners();
  }
  void setDeadline(DateTime newDeadline){
    _deadline = newDeadline;
    notifyListeners();
  }
  void addOption(String newOption){
    _options.add(newOption);
    notifyListeners();
  }
  void removeOption(int index){
    _options.removeAt(index);
    notifyListeners();
  }
  void setOption(String newOption,int index){
    if(index < options.length) {
      _options[index] = newOption;
    }
    notifyListeners();
  }
  void reset(){
    _title = "";
    _options.clear();
    _deadline = DateTime.now();
    _code = null;
    _error = null;

  }
  void setCode(String newCode){
    _code = newCode;
    notifyListeners();
  }
  void setRandomCode() async{
    const String availableCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    bool success = false;
    String tempCode = "";
    try {
      while (!success) {
        tempCode = List.generate(
            5, (index) =>
        availableCharacters[_random.nextInt(
            availableCharacters.length)]).join();
        await appState.fireBaseMutex.acquire();
        var db = FirebaseFirestore.instance;
        var poll = await db.collection("polls").doc(tempCode).get();
        success = !poll.exists;
      }
      if(success) setCode(tempCode);
    }
    on FirebaseException catch(e){
      _fatalError = e.message;
    }
    finally{
      appState.fireBaseMutex.release();
    }
    notifyListeners();
  }
  Future<void> submitPoll() async{
    try{
      appState.fireBaseMutex.acquire();
      var submittable = <String,dynamic>{
        "uid": appState.userCredential!.user!.uid,
        "title": title,
        "options": options.toList(),
        "deadline": deadline,
        "votes": []
      };
      var db = FirebaseFirestore.instance;
      await db.collection("polls").doc(code).set(submittable);
    }
    on FirebaseException catch(e){
      _error = e.message;
    }
    finally{
      appState.fireBaseMutex.release();
    }
    notifyListeners();
  }
}