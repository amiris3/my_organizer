import 'screens/splash_screen.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(Organizer());
}

class Organizer extends StatefulWidget {
  @override
  _OrganizerState createState() => _OrganizerState();
}

class _OrganizerState extends State<Organizer> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

