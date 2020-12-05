import 'package:flutter/cupertino.dart';

class BaseTask {
  int id, session_id, points;
  String title;
  bool complete_status;

  BaseTask({
    this.id,
    @required this.title,
    @required this.points,
    @required this.complete_status,
    @required this.session_id,
  });

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['points'] = this.points;
    map['complete_state'] = this.complete_status;
    map['session_id'] = this.session_id;
    return map;
  }

  factory BaseTask.fromJson(Map<String, dynamic> json) {
    return BaseTask(
      id: json['id'],
      title: json['title'],
      points: json['points'],
      complete_status: (json['complete_state'] == 1) ? true  : false,
      session_id: json['session_id'],
    );
  }
}
