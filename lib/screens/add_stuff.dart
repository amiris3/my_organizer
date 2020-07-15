import 'file:///C:/Users/Public/Documents/my_organizer/lib/screens/forms/add_exam.dart';
import 'file:///C:/Users/Public/Documents/my_organizer/lib/screens/forms/add_subject.dart';
import 'file:///C:/Users/Public/Documents/my_organizer/lib/screens/forms/create_plan_screen.dart';
import 'package:OrganiZer/database/subject_provider.dart';
import 'package:OrganiZer/models/subject.dart';
import 'package:flutter/material.dart';

class AddStuffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddStuffScreenState();
}

class _AddStuffScreenState extends State<AddStuffScreen>{

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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 90),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.deepPurple[900],),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Add stuff",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[600],
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height - 550,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ListView(
                children: [
                  Container(
                  margin:
                  EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(
                          'add a subject'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        color: Color.fromRGBO(144, 202, 226, 1),
                        elevation: 0,
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (BuildContext context)
                              => AddSubject(),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        child: Text(
                          'add an exam'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        color: Color.fromRGBO(144, 202, 226, 1),
                        elevation: 0,
                        onPressed: () async {
                          List<Subject> subjects = await SubjectProvider.dbSubjects.getAllSubjects();
                          List<String> names = List<String>();
                          for (Subject subject in subjects) {
                            names.add(subject.name);
                          }
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (BuildContext context)
                              => AddExam(subjectNames: names),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        child: Text(
                          'new khôlloscope'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.deepPurple[900],
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        color: Color.fromRGBO(144, 202, 226, 1),
                        elevation: 0,
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (BuildContext context)
                              => CreatePlanScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ],
            ),
          ),
        ),
      ],
    );
  }
}