import 'package:flutter/material.dart';

class Challenge {
  int id, points, user_id;
  String hero_instagram, hero_target;
  bool is_verefied, in_leader_board;

  Challenge({
    this.id,
    @required this.hero_instagram,
    @required this.hero_target,
    @required this.points,
    @required this.in_leader_board,
    @required this.is_verefied,
    @required this.user_id,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['hero_instagram'] = this.hero_instagram;
    map['hero_target'] = this.hero_target;
    map['points'] = this.points;
    map['in_leader_board'] = this.in_leader_board;
    map['is_verefied'] = this.is_verefied;
    map['user_id'] = this.user_id;
  }

  factory Challenge.fromJson(List<dynamic> json) {
    return Challenge(
        id: json[0]['id'],
        hero_instagram: json[0]['hero_instagram'],
        hero_target: json[0]['hero_target'],
        points: json[0]['points'],
        in_leader_board: json[0]['in_leader_board'],
        is_verefied: json[0]['is_verefied'],
        user_id: json[0]['user_id']);
  }
}
