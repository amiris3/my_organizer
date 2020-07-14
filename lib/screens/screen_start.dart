import 'add_stuff.dart';
import 'all_subjects_screen.dart';
import 'weekly_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class ScreenStart extends StatefulWidget {
  @override
  _ScreenStartState createState() => _ScreenStartState();
}

class _ScreenStartState extends State<ScreenStart> {
  int _selectedItemIndex = 2;
  final List pages = [
    HomeScreen(),
    WeeklyScreen(),
    AllSubjectsScreen(),
    AddStuffScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          backgroundColor: Colors.lightBlue[100].withOpacity(0.5),
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.deepPurple[600],
          selectedIconTheme: IconThemeData(
              color: Colors.deepPurple[700]
          ),
          currentIndex: _selectedItemIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedItemIndex = index;
            });
            },
          items: [
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(Icons.today),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(Icons.assessment),
            ),
            BottomNavigationBarItem(
              title: Text(''),
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
          iconSize: 28,
        ),
        body: pages[_selectedItemIndex]);
  }
}


