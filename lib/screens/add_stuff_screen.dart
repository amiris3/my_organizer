import 'forms/add_exam.dart';
import 'forms/add_subject.dart';
import 'forms/create_plan_screen.dart';
import '../database/subject_provider.dart';
import '../models/subject.dart';
import '../styling.dart';
import 'package:flutter/material.dart';

class AddStuffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddStuffScreenState();
}

class _AddStuffScreenState extends State<AddStuffScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(gradient: mainGradient),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 90),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add stuff",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 22,
                ),
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
            child: Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildButton('add a subject', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddSubject(),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  _buildButton('add an exam', () async {
                      List<Subject> subjects =
                          await SubjectProvider.dbSubjects.getAllSubjects();
                      List<String> names = List<String>();
                      for (Subject subject in subjects) {
                        names.add(subject.name);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddExam(subjectNames: names),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                 _buildButton('new khôlloscope', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CreatePlanScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  RaisedButton _buildButton(String s, Function onPressed) {
    return RaisedButton(
      child: Text(
        s.toUpperCase(),
        style: TextStyle(
          color: primaryColor,
          fontSize: 20.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      color: barColor,
      elevation: 10,
      onPressed: onPressed,
    );
  }
}
