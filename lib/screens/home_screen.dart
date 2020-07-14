import 'package:flutter/material.dart';
import 'package:OrganiZer/models/lesson.dart';
import 'package:OrganiZer/models/exam.dart';
import 'package:OrganiZer/database/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Exam> allExams = List<Exam>();
  bool loading = true;

  Future<void> refreshList() async {
    allExams = await ExamProvider.dbExams.getAllExams();
    allExams.removeWhere((element) => element.date.isBefore(DateTime.now()));
    if (allExams.length >= 3) allExams.removeRange(3, allExams.length);
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(226, 212, 250, 1),
                  Color.fromRGBO(144, 202, 226, 1),
                ],
              )),
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                      text: _getWeekDayFromInt(DateTime.now().weekday) + " ",
                      style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      children: [
                        TextSpan(
                          text:
                          DateTime.now().day.toString() + ", " +
                              _getMonthFromInt(DateTime.now().month),
                          style: TextStyle(
                              color: Colors.deepPurple[800],
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 8,
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://images.pexels.com/photos/2377965/pexels-photo-2377965.jpeg?cs=srgb&dl=pexels-2377965.jpg&fm=jpg"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi Lou,",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF343E87),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "here is your schedule for today:",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
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
          top: 175,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            height: MediaQuery.of(context).size.height - 265,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView(
              children: [
                buildTitleRow("TODAY'S CLASSES ", 2),
                SizedBox(
                  height: 15,
                ),
                buildLessonItem(dummyLesson[0]),
                buildLessonItem(dummyLesson[1]),
                SizedBox(
                  height: 22,
                ),
                buildTitleRow("THIS WEEK'S EXAMS ", allExams.length),
                SizedBox(
                  height: 15,
                ),
                loading ? CircularProgressIndicator() : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      buildExamItem(allExams[0]),
                      buildExamItem(allExams[1]),
                      buildExamItem(allExams[2]),

                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Container buildExamItem(Exam exam) {
    int numDays = exam.date.day - DateTime.now().day;
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.all(12),
      height: 130,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: numDays <= 3 ?
        Colors.red.withOpacity(0.3) : Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Coming up",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          SizedBox(
            height: 7,
          ),
          Row(
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: numDays <= 3 ? Colors.red.withOpacity(0.3)
                      : Colors.green.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "$numDays days left",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 100,
            child: Text(
              exam.subjectName,
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: 100,
            child: Text(
              exam.isKholle ? "Khôlle  n° " + exam.examId.toString()
                  : "DS  n° " + exam.examId.toString(),
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Row buildTitleRow(String title, int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "($number)",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ]),
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
              Text(
                (lesson.dateTime.hour%12).toString() + " h " +
                    lesson.dateTime.minute.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                lesson.dateTime.hour <= 12 ? "AM" : "PM",
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
          Container(
            height: 100,
            width: 1,
            color: Colors.deepPurple,
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
  List<String> months = ["January", "February", "March", "April", "May",
    "June", "July", "August", "September", "October", "November", "December"];
  return months[month-1];
}

String _getWeekDayFromInt(int weekday) {
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  return days[weekday-1];
}