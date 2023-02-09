import 'dart:collection';
import 'package:flutter/material.dart';

class NewPollModel extends ChangeNotifier{
  String _title = "";
  String get title => _title;
  final List<String> _options = [""];
  UnmodifiableListView<String> get options => UnmodifiableListView<String>(_options);
  DateTime _deadline = DateTime.now();
  DateTime get deadline => _deadline;
  String? _error;
  String? get error => _error;
  String? _code;
  String? get code => _code;
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
  }
  void reset(){
    _title = "";
    _options.clear();
    _deadline = DateTime.now();
    _code = null;
    _error = null;

  }
  void submitPoll() async{
    //TODO: implement this
    notifyListeners();
  }
}