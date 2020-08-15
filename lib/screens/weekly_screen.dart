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
      myTabs = List<Widget>();
      fillListTabs();
      refreshList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: mainGradient
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 45,),
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
                    indicatorColor: Colors.transparent,
                    controller: _tabController,
                    tabs: myTabs,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: loading ? CircularProgressIndicator() :
                    [for (int i=0;i<7;i++) _buildExamsList(i),]
                    [_tabController.index],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ListView _buildExamsList(int page) {
    return ListView.builder(
        itemCount: allExams.where((element) =>
        (element.date.day == thisWeek[page].day)
            &&(element.date.month == thisWeek[page].month)
        ).length,
        itemBuilder: (BuildContext context, int index)  {
          allExams.removeWhere((element)  => element.date.day != thisWeek[page].day);
          allExams.removeWhere((element) => element.date.month != thisWeek[page].month);
          final Exam exam = allExams[index];
          return _buildExam(exam);
        }
    );
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
                    )
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
                      (exam.durationInMinutes ~/ 60).toString() == "0" ?
                      exam.durationInMinutes.toString() + " min" :
                      (exam.durationInMinutes ~/ 60).toString() + " h " +
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
              Transform.scale(
                scale: 1.7,
                child: Checkbox(
                  value: exam.isDone,
                  onChanged: (bool newValue) async {
                    exam.isDone = newValue;
                    await ExamProvider.dbExams.updateExam(exam);
                    refreshList();
                  },
                  activeColor: checkBoxColor,
                ),
              ),
              Container(
                height: 90,
                width: MediaQuery.of(context).size.width -110,
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
                          backgroundColor: primaryColor,
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
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDateColumn(DateTime dateTime, int index) {
    return Container(
      height: 60,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
              padding: EdgeInsets.only(
                  top: 4,
              bottom: 3,),
            decoration: BoxDecoration(
              color: _tabController.index == index ? barColor : Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Text(
                getShortWeekDay(dateTime.weekday),
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 13,
                )),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
               top: 5,
                bottom: 3),
            decoration: BoxDecoration(
              color: _tabController.index == index ?
              barColor : Colors.white,
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
      ),
    );
  }
}

String getShortWeekDay(int weekday) {
  List<String> weekdays = ["M", "T", "W", "T", "F", "S", "S"];
  return weekdays[weekday - 1];
}
List<DateTime> thisWeek = [
  for (int i = 0; i<7;i++)   DateTime.now().add(Duration(days: i)),
];


