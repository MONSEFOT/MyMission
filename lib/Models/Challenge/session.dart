import 'package:flutter/material.dart';

class Session {
  int id, number, points, week_number, challenge_id;
  DateTime unLock_date;
  bool complete_state;

  Session({
    this.id,
    @required this.number,
    @required this.points,
    @required this.week_number,
    @required this.unLock_date,
    @required this.complete_state,
    @required this.challenge_id,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['number'] = this.number;
    map['points'] = this.points;
    map['week_number'] = this.week_number;
    map['unLock_date'] = this.unLock_date;
    map['complete_state'] = this.complete_state;
    map['challenge_id'] = this.challenge_id;
  }

  factory Session.fromJson(List<dynamic> json) {
    return Session(
        id: json[0]['id'],
        number: json[0]['number'],
        points: json[0]['points'],
        week_number: json[0]['week_number'],
        unLock_date: json[0]['unLock_date'],
        complete_state: json[0]['complete_state'],
        challenge_id: json[0]['challenge_id']);
  }
}
