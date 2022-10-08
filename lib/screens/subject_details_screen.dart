import 'forms/add_lesson.dart';
import 'forms/add_exam.dart';
import '../database/exam_provider.dart';
import '../database/subject_provider.dart';
import '../models/subject.dart';
import '../models/exam.dart';
import '../styling.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;
  final List<Exam> allExams;
  SubjectDetailsScreen({this.allExams, this.subject});

  @override
  State<StatefulWidget> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Map> choices = [
      {'title': 'add an exam'},
      {'title': 'add a lesson'},
      {'title': 'edit this subject'},
      {'title': 'delete this subject'},
    ];
    List<Map> choicesExam = [
      {'title': 'edit this exam'},
      {'title': 'delete this exam'},
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subject.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: primaryColor,
          actions: [
            PopupMenuButton<Map>(
              offset: Offset(0, 55),
              icon: Icon(Icons.more_horiz),
              onSelected: (Map map) {
                _callAction(map);
              },
              itemBuilder: (context) => [
                for (Map map in choices)
                  PopupMenuItem(
                    value: map,
                    child: Text(map['title']),
                  ),
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: BoxDecoration(gradient: mainGradient),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(4),
                  height: MediaQuery.of(context).size.height / 6,
                  width: MediaQuery.of(context).size.height / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: MediaQuery.of(context).size.height / 6,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          child: CircularPercentIndicator(
                            footer: new Text(
                              "completed",
                              style: new TextStyle(
                                  fontSize: 15.0, color: Colors.grey),
                            ),
                            radius: 40,
                            lineWidth: 8.0,
                            animation: true,
                            percent: getCompletionRate() / 100,
                            center: new Text(
                              getCompletionRate().toString().replaceAll(
                                      RegExp(r"([.]*0)(?!.*\d)"), "") +
                                  '%',
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: primaryColor,
                            backgroundColor:
                                Color.fromRGBO(144, 202, 226, 0.25),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5.0),
                          elevation: 0,
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'current average',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              SizedBox(height: 18),
                              Text(
                                calculateMedian() == -1
                                    ? 'unknown'
                                    : calculateMedian().toString() + '/20',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  height: 465,
                  child: widget.allExams.length == 0
                      ? Center(
                          child: Text(
                            'no exams available',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.allExams.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  top: 5.0,
                                  bottom: 8.0,
                                  left: 10.0,
                                  right: 10.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                gradient: listGradient,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 23,
                                        backgroundColor: barColor,
                                        child: Text(
                                          widget.allExams[index].grade == -1
                                              ? '?'
                                              : widget.allExams[index].grade
                                                  .toString(),
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        widget.allExams[index].examName
                                            .toUpperCase(),
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      PopupMenuButton<Map>(
                                        offset: Offset(0, 45),
                                        icon: Icon(Icons.expand_more),
                                        onSelected: (Map map) {
                                          _callActionExam(
                                              map, widget.allExams[index]);
                                        },
                                        itemBuilder: (context) => [
                                          for (Map map in choicesExam)
                                            PopupMenuItem(
                                              value: map,
                                              child: Text(map['title']),
                                            ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ));
  }

  calculateMedian() {
    if (widget.allExams.length == null || widget.allExams.length == 0) {
      return -1;
    }
    double finalGrade = 0;
    for (Exam exam in widget.allExams) {
      if (exam.date.isBefore(DateTime.now()) && (exam.grade >= 0.0))
        finalGrade += exam.grade;
    }
    if (finalGrade == 0) return -1;
    finalGrade = finalGrade /
        widget.allExams
            .where((element) =>
                element.date.isBefore(DateTime.now()) && (element.grade >= 0.0))
            .length;
    return finalGrade.toStringAsFixed(2);
  }

  getCompletionRate() {
    double completionRate = 0;
    if (widget.allExams.length != 0) {
      for (Exam exam in widget.allExams) {
        if (exam.date.isBefore(DateTime.now())) completionRate++;
      }
      completionRate = completionRate / widget.allExams.length;
      completionRate *= 100;
      completionRate = completionRate.roundToDouble();
    }
    return completionRate;
  }

  Future<void> _callAction(Map map) async {
    switch (map['title']) {
      case 'add an exam':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddExam(
                      subjectName: widget.subject.name,
                    )));
        break;
      case 'add a lesson':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddLesson(
                      subjectName: widget.subject.name,
                    )));
        break;
      case 'edit this subject':
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Edit the subject'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: widget.subject.name,
                        decoration: InputDecoration(labelText: 'Subject name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the subject\'s name';
                          }
                        },
                        onChanged: (value) => widget.subject.name = value,
                      ),
                      TextFormField(
                        initialValue: widget.subject.khNb.toString(),
                        decoration:
                            InputDecoration(labelText: 'Khôlles number'),
                        validator: (value) {
                          var potentialNb = int.tryParse(value);
                          if (potentialNb == null) {
                            return 'Please enter the khôlles number';
                          }
                        },
                        onChanged: (value) =>
                            widget.subject.khNb = int.parse(value),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('SAVE'),
                      onPressed: () async {
                        await SubjectProvider.dbSubjects
                            .updateSubject(this.widget.subject);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            barrierDismissible: true);
        break;
      case 'delete this subject':
        await SubjectProvider.dbSubjects.deleteSubject(this.widget.subject);
        /* not working because wrong context :
        Scaffold.of(context).showSnackBar(
            SnackBar(
                content: Text(
              widget.subject.name + ' has been successfully deleted',)
        ));*/
        Navigator.pop(context);
        break;
    }
  }

  Future<void> _callActionExam(Map map, Exam exam) async {
    switch (map['title']) {
      case 'edit this exam':
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('Edit this exam'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: exam.examName,
                        decoration: InputDecoration(labelText: 'Exam name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the exam\'s name';
                          }
                        },
                        onChanged: (value) => exam.examName = value,
                      ),
                      TextFormField(
                        initialValue: exam.grade.toString(),
                        decoration: InputDecoration(labelText: 'grade'),
                        validator: (value) {
                          var potentialNb = double.tryParse(value);
                          if (potentialNb == null) {
                            return 'Please enter the grade';
                          }
                        },
                        onChanged: (value) => exam.grade = double.parse(value),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text('SAVE'),
                      onPressed: () async {
                        await ExamProvider.dbExams.updateExam(exam);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
            barrierDismissible: true);
        break;
      case 'delete this exam':
        await ExamProvider.dbExams.deleteExam(exam);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          exam.examName + ' has been successfully deleted',
        )));
        break;
    }
  }
}
