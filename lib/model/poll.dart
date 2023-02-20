import 'dart:collection';

import 'package:flutter/material.dart';

/*
  The poll class contains details about a certain poll, and has two usages:
    - To store and submit the scores the user gave when on the voting screen
    - To store the results received from the server when on the result screen
 */

class Poll extends ChangeNotifier{
  final String _title;
  String get title => _title;
  Map<String,int> _options;
  UnmodifiableMapView<String,int> get options => UnmodifiableMapView(_options);
  Map<String,int>? _runoffOptions;
  UnmodifiableMapView<String,int>? get runoffOptions => _runoffOptions != null ? UnmodifiableMapView(_runoffOptions!) : null;
  final String? _error;
  String? get error => _error;
  final bool _votable;
  bool get votable => _votable;
  void setScore(int index, int score){
    if(!votable) return;
    _options[_options.keys.elementAt(index)] = score;
    notifyListeners();
  }
  void calculateWinner(){
    if(!votable) {
      _options = Map.fromEntries(_options.entries.toList()..sort((x,y) => y.value - x.value));
      _runoffOptions = Map.fromEntries(_runoffOptions!.entries.toList()..sort((x,y) => y.value - x.value));
      notifyListeners();
    }
  }
  Poll(this._title,this._options,this._runoffOptions,this._votable,this._error){
    calculateWinner();
  }
}