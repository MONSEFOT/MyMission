
import 'package:flutter/material.dart';
import 'package:mymission_full_version/Screens/login.dart';
  
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.black,
        accentColor: Colors.amber,
        appBarTheme: AppBarTheme(
            color: Colors.black,
            iconTheme: IconThemeData(
              color: Colors.white,
              size: 25,
            )),
      ),
      home: LoginScreen(),
    );
  }
}
