import 'package:OrganiZer/database/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:OrganiZer/models/exam.dart';

class WeeklyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  List<Widget> myTabs = [];
  List<Exam> allExams = List<Exam>();
  bool loading = true;

  void fillListTabs() {
    for (int i=0; i<7; i++) {
      myTabs.add(Tab(child: buildDateColumn(thisWeek[i], i),));
    }
  }

  Future<void> refreshList() async {
    allExams = await ExamProvider.dbExams.getAllExams();
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
    fillListTabs();
    _tabController = TabController(length: thisWeek.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _tabController.index = 0;
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(226, 212, 250, 1),
              Color.fromRGBO(144, 202, 226, 1),
            ],
          )),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.deepPurple[600]),
                  SizedBox(
                    width: 15,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Your schedule for today",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[600],
                          fontSize: 22,
                        ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 120,
          child: Container(
            height: MediaQuery.of(context).size.height - 210,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                        color: Colors.deepPurple[100],
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15),
                    ),
                    tabs: myTabs,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loading ? CircularProgressIndicator() :
                    [
                      buildExamsList(0),
                      buildExamsList(1),
                      buildExamsList(2),
                      buildExamsList(3),
                      buildExamsList(4),
                      buildExamsList(5),
                      buildExamsList(6)
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

  ListView buildExamsList(int page) {
    return ListView.builder(
        itemCount: allExams.where((element) =>
        (element.date.day == thisWeek[page].day)
            &&(element.date.month == thisWeek[page].month)
        ).length,
        itemBuilder: (BuildContext context, int index)  {
          allExams.removeWhere((element)  => element.date.day != thisWeek[page].day);
          allExams.removeWhere((element) => element.date.month != thisWeek[page].month);
          final Exam exam = allExams[index];
          return buildExam(exam);
        }
    );
  }

  Container buildExam(Exam exam) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.deepPurple[600],
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
                      (exam.durationInMinutes ~/ 60).toString() +
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
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(20)),
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
                      backgroundColor: Colors.deepPurple,
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
                          exam.isKholle
                              ? "Kholle n° " + exam.examId.toString()
                              : "Exam n° " + exam.examId.toString(),
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
          )
        ],
      ),
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

Widget buildDateColumn(DateTime dateTime, int index) {
  return Column(
    children: [
      SizedBox(
        height: 5,
      ),
     Text(
          getShortWeekDay(dateTime.weekday),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Colors.black,
            fontSize: 13,
          )),
      SizedBox(
        height: 9,
      ),
      Text(
        dateTime.day.toString(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ],
  );
}
