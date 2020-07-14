import 'package:OrganiZer/database/database.dart';
import 'package:flutter/material.dart';
import 'package:OrganiZer/models/exam.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddExam extends StatefulWidget {
  final List<String> subjectNames;
  AddExam({this.subjectNames});

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {

  final _formKey = GlobalKey<FormState>();
  final _exam = Exam();

  @override
  Widget build(BuildContext context) {
    DateTime timeOfDay = DateTime.now();
    DateTime chosenDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.deepPurple[900],
          centerTitle: true,
          title: Text('Add an exam',
            style: TextStyle(
                fontSize: 23,
            ),)),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(226, 212, 250, 1),
                      Color.fromRGBO(144, 202, 226, 1),
                    ],
                  ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Builder(
                builder: (context) => Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration:
                          InputDecoration(labelText: 'Exam name'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your first name';
                            }
                          },
                          onSaved: (val) =>
                              setState(() => _exam.examName = val),
                        ),
                        DropdownButtonFormField(
                          hint: Text('Select a subject'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the subject';
                            }
                          },
                          items: widget.subjectNames.map((String subjectName) {
                            return DropdownMenuItem<String>(
                              value: subjectName,
                              child: Text(subjectName),
                            );
                          }).toList(),
                          onChanged: (String newValue) {},
                            onSaved: (subjectName) => setState(()=> _exam.subjectName = subjectName),
                            ),
                            TextFormField(
                            decoration:
                            InputDecoration(labelText: 'Duration in minutes'),
                            validator: (value) {
                              var potentialNb = int.tryParse(value);
                              if (potentialNb == null) {
                              return 'Please enter the duration in minutes';
                              }
                            },
                            onSaved: (val) =>
                            setState(() => _exam.durationInMinutes = int.parse(val)),
                        ),
                        InputDatePickerFormField(
                          fieldLabelText: 'Date',
                          onDateSaved: (date) =>
                              setState(() => chosenDate = date),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        ),
                        SizedBox(height: 30,),
                        TimePickerSpinner(
                          is24HourMode: false,
                          normalTextStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.blue[900],
                          ),
                          highlightedTextStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.deepPurple[900]
                          ),
                          spacing: 20,
                          itemHeight: 30,
                          isForce2Digits: true,
                          onTimeChange: (time) {
                            setState(() {
                              timeOfDay = time;
                            });
                          },
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: RaisedButton(
                              color: Colors.deepPurple[900],
                              onPressed: () async {
                                  final form = _formKey.currentState;
                                  if (form.validate()) {
                                    form.save();
                                    print(_exam.examName);
                                    _exam.date = DateTime(chosenDate.year,
                                        chosenDate.month, chosenDate.day,
                                        timeOfDay.hour, timeOfDay.minute);
                                    _exam.grade = 0.0;
                                    _exam.isFromUni = true;
                                    _exam.isDone = false;
                                    _exam.isKholle = false;
                                    _exam.notes = "";
                                    await ExamProvider.dbExams.insertExam(_exam).then((value) {
                                      Navigator.pop(context);
                                    });
                                  }
                                  else {
                                    print('form did not validate');
                                  }
                                },
                                child: Text(
                                  'Save'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white
                                  ),
                                ),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}