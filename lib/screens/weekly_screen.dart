import '../database/lesson_provider.dart';
import '../models/lesson.dart';
import '../database/exam_provider.dart';
import '../styling.dart';
import 'package:flutter/material.dart';
import '../models/exam.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<Widget> myTabs = [];
  List all = List<dynamic>();
  bool loading = true;

  void fillListTabs() {
    for (int i = 0; i < 7; i++) {
      myTabs.add(Tab(
        child: buildDateColumn(thisWeek[i]),
      ));
    }
  }

  Future<void> refreshList() async {
    List<Exam> allExams = List<Exam>();
    List<Lesson> allLessons = List<Lesson>();
    allExams = await ExamProvider.dbExams.getAllExams();
    allExams.removeWhere((element) => element.date.isBefore(DateTime.now()));
    allExams.sort((exam1, exam2) => exam1.date.compareTo(exam2.date));
    allLessons = await LessonProvider.dbLessons.getAllLessons();
    allLessons.removeWhere((element) => element.date.isBefore(DateTime.now()));
    allLessons.sort((lesson1, lesson2) => lesson1.date.compareTo(lesson2.date));
    all = List<dynamic>();
    all.addAll(allExams);
    all.addAll(allLessons);
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: thisWeek.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _tabController.index = 0;
    fillListTabs();
    super.initState();
    refreshList();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
      refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: mainGradient),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
              ),
              RichText(
                text: TextSpan(
                  text: "Your schedule for this week",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 130,
          child: Container(
            height: MediaQuery.of(context).size.height - 220,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    controller: _tabController,
                    tabs: myTabs,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loading
                        ? CircularProgressIndicator()
                        : [
                            _buildList(0),
                            _buildList(1),
                            _buildList(2),
                            _buildList(3),
                            _buildList(4),
                            _buildList(5),
                            _buildList(6)
                          ][_tabController.index],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ListView _buildList(int page) {
    List<dynamic> list = List<dynamic>();
    list = [...all];
    list.removeWhere((element) => (element.date.day != thisWeek[page].day));
    list.removeWhere((element) => (element.date.month != thisWeek[page].month));
    list.sort((elem1, elem2) => elem1.date.compareTo(elem2.date));
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          if (list[index] is Exam) {
            final Exam exam = list[index];
            return _buildExam(exam);
          } else {
            final Lesson lesson = list[index];
            return _buildLesson(lesson);
          }
        });
  }

  Container _buildExam(Exam exam) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5),
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: exam.date.hour.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " h",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ),
                    Text(
                      (exam.durationInMinutes ~/ 60).toString() == "0"
                          ? exam.durationInMinutes.toString() + " min"
                          : (exam.durationInMinutes ~/ 60).toString() +
                              " h " +
                              (exam.durationInMinutes % 60 != 0
                                  ? (exam.durationInMinutes % 60).toString()
                                  : ""),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 14),
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width - 110,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: checkBoxColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1,
                          offset: Offset(4, 6),
                          color: checkBoxColor.withOpacity(0.4),
                          blurRadius: 5
                      )
                    ]
                ),
                margin: EdgeInsets.only(right: 10, left: 30),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: primaryColor.withOpacity(0.6),
                          child: Text(
                            exam.isKholle ? "K" : "DS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.subjectName,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              exam.examName,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildLesson(Lesson lesson) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: checkBoxColor,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(5),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: lesson.date.hour.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: " h " + lesson.date.minute.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 14),
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width - 110,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        offset: Offset(3, 6),
                        color: primaryColor.withOpacity(0.2),
                        blurRadius: 4
                      )
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDateColumn(DateTime dateTime) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 4,
            bottom: 3,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Text(getShortWeekDay(dateTime.weekday),
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 13,
              )),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 5, bottom: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Text(
            dateTime.day.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

String getShortWeekDay(int weekday) {
  List<String> weekdays = ["M", "T", "W", "T", "F", "S", "S"];
  return weekdays[weekday - 1];
}

List<DateTime> thisWeek = [
  DateTime.now(),
  DateTime.now().add(Duration(days: 1)),
  DateTime.now().add(Duration(days: 2)),
  DateTime.now().add(Duration(days: 3)),
  DateTime.now().add(Duration(days: 4)),
  DateTime.now().add(Duration(days: 5)),
  DateTime.now().add(Duration(days: 6))
];
