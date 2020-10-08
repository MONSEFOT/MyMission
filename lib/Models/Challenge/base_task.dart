import 'package:flutter/cupertino.dart';

class BaseTask {
  int id, session_id, points;
  String title;
  bool complete_state;

  BaseTask({
    this.id,
    @required this.title,
    @required this.points,
    @required this.complete_state,
    @required this.session_id,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['points'] = this.points;
    map['complete_state'] = this.complete_state;
    map['session_id'] = this.session_id;
  }

  factory BaseTask.fromJson(List<dynamic> json) {
    return BaseTask(
        id: json[0]['id'],
        title: json[0]['title'],
        points: json[0]['points'],
        complete_state: json[0]['complete_state'],
        session_id: json[0]['session_id']);
  }
}
