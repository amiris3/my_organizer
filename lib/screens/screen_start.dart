import '../styling.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'weekly_screen.dart';
import 'all_subjects_screen.dart';

class ScreenStart extends StatefulWidget {
  @override
  _ScreenStartState createState() => _ScreenStartState();
}

class _ScreenStartState extends State<ScreenStart> {
  int _selectedItemIndex = 0;
  final List pages = [
    HomeScreen(),
    WeeklyScreen(),
    AllSubjectsScreen(),
  ];

  List<IconData> icons = [
    Icons.home, Icons.today, Icons.assessment
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          backgroundColor: barColor,
          unselectedItemColor: Colors.black45,
          selectedIconTheme: IconThemeData(
              color: primaryColor
          ),
          currentIndex: _selectedItemIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _selectedItemIndex = index;
            });
            },
          items: [
            for (IconData icon in icons)
              BottomNavigationBarItem(
                title: Text(''),
                icon: Icon(icon),
              ),
          ],
          iconSize: 28,
        ),
        body: pages[_selectedItemIndex]);
  }
}


