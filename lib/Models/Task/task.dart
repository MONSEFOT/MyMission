import 'package:flutter/material.dart';

class Task {
  int id, user_id;
  String title, description;
  bool complete_state;

  Task({
    this.id,
    @required this.title,
    @required this.description,
    @required this.complete_state,
    @required this.user_id,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['title'] = this.title;
    map['description'] = this.description;
    map['complete_state'] = this.complete_state;
    map['user_id'] = this.user_id;
  }

  factory Task.fromJson(Map<String , dynamic> json ) {
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        complete_state: json['complete_state'],
        user_id: json['user_id']);
  }
}
