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

  factory Session.fromJson(Map<String , dynamic> json) {
    return Session(
        id: json['id'],
        number: json['number'],
        points: json['points'],
        week_number: json['week_number'],
        unLock_date: json['unLock_date'],
        complete_state: json['complete_state'],
        challenge_id: json['challenge_id']);
  }
}
