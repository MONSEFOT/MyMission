import 'package:flutter/material.dart';

class Challenge {
  int id, points, user_id;
  String hero_instagram, hero_target;
  bool is_verefied, in_leader_board;
  DateTime created_at , updated_at;

  Challenge({
    this.id,
    @required this.hero_instagram,
    @required this.hero_target,
    @required this.points,
    @required this.in_leader_board,
    @required this.is_verefied,
    @required this.user_id,
    @required this.created_at,
    @required this.updated_at,
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
    map['created_at'] = this.created_at;
    map['updated_at'] = this.updated_at;
    return map;
  }

  factory Challenge.fromJson(Map<String , dynamic> json) {
    return Challenge(
        id: json['id'],
        hero_instagram: json['hero_instagram'],
        hero_target: json['hero_target'],
        points: json['points'],
        in_leader_board: (json['in_leader_board'] == 1)? true : false,
        is_verefied: (json['is_verefied'] == 1)? true : false,
        user_id: json['user_id'],
        created_at: DateTime.parse(json['created_at']),
        updated_at: DateTime.parse(json['updated_at']),
        );
  }
}
