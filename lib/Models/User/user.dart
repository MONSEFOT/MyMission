import 'package:flutter/material.dart';
import 'package:mymission_full_version/Utils/utils.dart';

class User {
  int id;
  String token , display_name, social_id, password, role;
  bool is_banned;
  DateTime created_at  , updated_at;

  User({
    this.id,
    @required this.token,
    @required this.display_name,
    @required this.social_id,
    @required this.password,
    @required this.role,
    @required this.is_banned,
    @required this.created_at,
    @required this.updated_at,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['token'] = this.token;
    map['display_name'] = this.display_name;
    map['email'] = this.social_id;
    map['password'] = this.password;
    map['role'] = this.role;
    map['is_banned'] = this.is_banned;
    map['created_at'] = this.created_at;
    map['updated_at'] = this.updated_at;
    return map;
  }

  factory User.fromJson(Map<String , dynamic> json) {
    return User(
        id: json['id'],
        token: json['token'],
        display_name: json['display_name'],
        social_id: json['social_id'],
        password: json['password'],
        role: json['role'],
        is_banned:  (json['is_banned'] == 1)? true : false,
        created_at: dateTimeGenerate(json['created_at']),
        updated_at: dateTimeGenerate(json['updated_at']),
);
  }
}
