import 'package:flutter/material.dart';

class User {
  int id;
  String token , display_name, email, password, role;

  User({
    this.id,
    @required this.token,
    @required this.display_name,
    @required this.email,
    @required this.password,
    @required this.role,
  });

  Map<String , dynamic> toMap(){
    var map = new Map<String , dynamic>();
    map['id'] = this.id;
    map['token'] = this.token;
    map['display_name'] = this.display_name;
    map['email'] = this.email;
    map['password'] = this.password;
    map['role'] = this.role;
  }

  factory User.fromJson(List<dynamic> json) {
    return User(
        id: json[0]['id'],
        token: json[0]['token'],
        display_name: json[0]['display_name'],
        email: json[0]['email'],
        password: json[0]['password'],
        role: json[0]['role'],
        );
  }
}
