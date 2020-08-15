import '../database/exam_provider.dart';
import '../styling.dart';
import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../models/subject.dart';
import '../database/subject_provider.dart';
import 'subject_details_screen.dart';

class AllSubjectsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AllSubjectsScreenState();

}

class _AllSubjectsScreenState extends State<AllSubjectsScreen>{
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
          decoration: BoxDecoration(
              gradient: mainGradient),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
          top: 120,
          child: Container(
            height: MediaQuery.of(context).size.height - 210,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: loading ?
                Center(
                  child: CircularProgressIndicator(),
                )
            : ListView.builder(
              itemCount: allSubjects.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    List<Exam> list = await ExamProvider.dbExams.getAllExams();
                    list.removeWhere((element) =>
                    element.subjectName != allSubjects[index].name);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context)
                            => SubjectDetailsScreen(
                                subjectName: allSubjects[index].name,
                                allExams: list),
                            ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 20.0, right: 20.0),
                    padding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      gradient: listGradient,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
      ],
    );
  }
}