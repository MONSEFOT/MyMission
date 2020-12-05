import 'package:flutter/material.dart';
import 'package:mymission_full_version/Screens/User/login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        primaryColor: Colors.black,
        backgroundColor: Colors.black,
        accentColor: Colors.amber,
        canvasColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
