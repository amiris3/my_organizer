import 'package:simple_speed_dial/simple_speed_dial.dart';
import '../../data/database/exam_provider.dart';
import '../styling.dart';
import 'package:flutter/material.dart';
import '../../data/models/exam.dart';
import '../../data/models/subject.dart';
import '../../data/database/subject_provider.dart';
import 'forms/add_subject.dart';
import 'forms/create_plan_screen.dart';
import 'subject_details_screen.dart';

class AllSubjectsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AllSubjectsScreenState();
}

class _AllSubjectsScreenState extends State<AllSubjectsScreen> {
  List<Subject> allSubjects = List<Subject>();
  bool loading = true;

  Future<void> refreshList() async {
    allSubjects = await SubjectProvider.dbSubjects.getAllSubjects();
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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
              ),
              Text(
                "Your subjects",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 22,
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
            child: loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: allSubjects.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          List<Exam> list =
                              await ExamProvider.dbExams.getAllExams();
                          list.removeWhere((element) =>
                              element.subjectName != allSubjects[index].name);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  SubjectDetailsScreen(
                                      subject: allSubjects[index],
                                      allExams: list),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 6.0, bottom: 6.0, left: 20.0, right: 20.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(5, 5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  color: primaryColor.withOpacity(0.3))
                            ],
                            color: barColor.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                allSubjects[index].name.toUpperCase(),
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 50,
          child: SpeedDial(
            child: Icon(Icons.add),
            closedForegroundColor: Colors.white,
            openForegroundColor: Colors.grey[100],
            closedBackgroundColor: checkBoxColor,
            openBackgroundColor: primaryColor,
            labelsStyle: TextStyle(
              color: primaryColor,
              fontSize: 18,
            ),
            speedDialChildren: <SpeedDialChild>[
              SpeedDialChild(
                child: Icon(Icons.class_),
                foregroundColor: Colors.green[100],
                backgroundColor: primaryColor,
                label: 'Add a subject',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => AddSubject(),
                    ),
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(Icons.fiber_new),
                foregroundColor: Colors.orange[100],
                backgroundColor: primaryColor,
                label: 'New khôlloscope',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => CreatePlanScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
