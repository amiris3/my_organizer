import 'package:OrganiZer/database/exam_provider.dart';
import 'package:flutter/material.dart';
import 'package:OrganiZer/models/exam.dart';
import 'package:OrganiZer/models/subject.dart';
import 'package:OrganiZer/database/subject_provider.dart';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment, color: Colors.deepPurple[900],),
              SizedBox(
                width: 15,
              ),
              Text(
                "Your subjects",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[600],
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
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange[100].withOpacity(0.5),
                          Colors.green[100].withOpacity(0.35),
                          Colors.orange[100].withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          allSubjects[index].name.toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepPurple[900],
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