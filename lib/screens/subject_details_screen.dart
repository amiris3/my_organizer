import 'package:OrganiZer/models/exam.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final String subjectName;
  final List<Exam> allExams;
  SubjectDetailsScreen({this.allExams, this.subjectName});

  @override
  State<StatefulWidget> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.subjectName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.deepPurple[900],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(226, 212, 250, 1),
                  Color.fromRGBO(144, 202, 226, 1),
                ],
              )),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 0,
                      child: CircularPercentIndicator(
                        footer: new Text(
                          "completed",
                          style:
                          new TextStyle(fontSize: 15.0, color: Colors.grey),
                        ),
                        radius: 80,
                        lineWidth: 13.0,
                        animation: true,
                        percent: getCompletionRate(),
                        center: new Text(
                          (getCompletionRate()*100).toString() + '%',
                          style:
                          new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[900],
                        backgroundColor: Color.fromRGBO(144, 202, 226, 0.25),
                      ),
                    ),
                    Card(
                      elevation: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'current average',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey
                            ),
                          ),
                          SizedBox(
                              height: 10),
                          Text(
                            calculateMedian() == -1 ? 'unknown' :
                            calculateMedian().toString() + '/20',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 51,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(10),
                height: 455,
                child: widget.allExams.length == 0 ?
                    Center(
                      child: Text(
                        'no exams available',
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    )
                    : ListView.builder(
                  itemCount: widget.allExams.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.deepPurple[900],
                                child: Text(
                                  widget.allExams[index].grade == -1 ? '?'
                                      : widget.allExams[index].grade.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.allExams[index].examName.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.deepPurple[900],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.allExams[index].date.day.toString()
                                    + '/' +
                                    widget.allExams[index].date.month
                                        .toString(),
                                style: TextStyle(
                                  color: Colors.deepPurple[900],
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400,
                                ),
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
        )
    );
  }

  calculateMedian() {
    if (widget.allExams.length == null || widget.allExams.length == 0) {
      return -1;
    }
    int finalGrade = 0;
    for (Exam exam in widget.allExams) {
      finalGrade += exam.grade.toInt();
    }
    finalGrade = finalGrade ~/ widget.allExams.length;
    return finalGrade;
  }

  getCompletionRate() {
    double completionRate = 0;
    for (Exam exam in widget.allExams) {
      if (exam.isDone) completionRate++;
    }
    return completionRate/widget.allExams.length;
  }

}
