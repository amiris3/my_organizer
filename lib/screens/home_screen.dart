import 'dart:math';

import '../styling.dart';
import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/exam.dart';
import '../database/exam_provider.dart';
import '../database/lesson_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Exam> allExams = List<Exam>();
  List<Lesson> allLessons = List<Lesson>();
  bool loading = true;

  Future<void> refreshList() async {
    allExams = await ExamProvider.dbExams.getAllExams();
    allExams.removeWhere((element) => element.date.isBefore(DateTime.now()));
    allExams.sort((exam1, exam2) => exam1.date.compareTo(exam2.date));
    if (allExams.length >= 3) allExams.removeRange(3, allExams.length);
    allLessons = await LessonProvider.dbLessons.getAllLessons();
    allLessons.removeWhere((element) => element.date.isBefore(DateTime.now()));
    allLessons.sort((lesson1, lesson2) => lesson1.date.compareTo(lesson2.date));
    //if (allLessons.length > 2) allLessons.removeRange(2, allExams.length);
    setState(() {
      loading = false;
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: mainGradient),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 32,
              vertical: MediaQuery.of(context).size.height / 16),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                      text: _getWeekDayFromInt(DateTime.now().weekday) + " ",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      children: [
                        TextSpan(
                          text: DateTime.now().day.toString() +
                              ", " +
                              _getMonthFromInt(DateTime.now().month),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 48,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 6,
                    height: MediaQuery.of(context).size.height / 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.white),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://images.pexels.com/photos/2377965/pexels-photo-2377965.jpeg?cs=srgb&dl=pexels-2377965.jpg&fm=jpg"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Lou,",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "here is your upcoming schedule:",
                        style: TextStyle(
                          fontSize: 16,
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4.5,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 32),
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: loading
                ? CircularProgressIndicator()
                : ListView(
                    children: [
                      buildTitleRow("NEXT TWO CLASSES"),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 32,
                      ),
                      ((allLessons.length == 0) || (allLessons.length == null))
                          ? Text('There are no classes available')
                          : Column(
                              children: [
                                for (int i = 0;
                                    i < min(allLessons.length, 2);
                                    i++)
                                  buildLessonItem(allLessons[i]),
                              ],
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      buildTitleRow("NEXT THREE EXAMS"),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 32,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (allExams.length > 0)
                            ? Row(
                                children: [
                                  for (int i = 0;
                                      i < min(allExams.length, 3);
                                      i++)
                                    buildExamItem(allExams[i]),
                                ],
                              )
                            : Text('There are no exams  available'),
                      ),
                    ],
                  ),
          ),
        )
      ],
    );
  }

  Container buildExamItem(Exam exam) {
    int numDays = exam.date.difference(DateTime.now()).inDays;
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 24),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width / 32),
      height: MediaQuery.of(context).size.height / 7,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            width: 1,
            color: numDays <= 3
                ? Colors.red.withOpacity(0.3)
                : Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 7,
                width: 7,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: numDays <= 3
                      ? Colors.red.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 64,
              ),
              Text(
                numDays == 0 ? 'today' : "$numDays days left",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 64,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              exam.subjectName,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 64,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              exam.examName,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Row buildTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
                fontSize: 13, color: primaryColor, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  Container buildLessonItem(Lesson lesson) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9FB),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.5),
                child: Text(
                  lesson.date.month.toString() +
                      "/" +
                      lesson.date.day.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  (lesson.date.hour % 12).toString() +
                      " h " +
                      lesson.date.minute.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                lesson.date.hour <= 12 ? "AM" : "PM",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: primaryColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 160,
                child: Text(
                  lesson.subjectName,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      lesson.location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 16,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      lesson.teacher,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

String _getMonthFromInt(int month) {
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

String _getWeekDayFromInt(int weekday) {
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  return days[weekday - 1];
}
