import '../../widgets/basic_form.dart';
import '../../database/exam_provider.dart';
import '../../styling.dart';
import 'package:flutter/material.dart';
import '../../models/exam.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddExam extends StatefulWidget {
  final String subjectName;
  AddExam({this.subjectName});

  @override
  _AddExamState createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final _formKey = GlobalKey<FormState>();
  final _exam = Exam();
  DateTime timeOfDay = DateTime.now();
  DateTime chosenDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text(
              'Add an exam for ' + widget.subjectName,
              style: TextStyle(
                fontSize: 23,
              ),
            )),
        body: BasicForm(
          widgets: getWidgets(),
          formKey: _formKey,
          button: getButton(),
        ));
  }

  List<Widget> getWidgets() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Exam name'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the exam\'s name';
          }
        },
        onSaved: (val) => setState(() => _exam.examName = val),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Duration in minutes'),
        validator: (value) {
          var potentialNb = int.tryParse(value);
          print('parsed the nb');
          if (potentialNb == null) {
            return 'Please enter the duration in minutes';
          }
        },
        onSaved: (val) =>
            setState(() => _exam.durationInMinutes = int.parse(val)),
      ),
      InputDatePickerFormField(
        fieldLabelText: 'Date',
        onDateSaved: (date) => setState(() => chosenDate = date),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)),
      ),
      Row(
        children: [
          Text(
            'Time:',
            style: TextStyle(
              color: primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TimePickerSpinner(
            is24HourMode: false,
            normalTextStyle: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
            highlightedTextStyle: TextStyle(fontSize: 20, color: primaryColor),
            spacing: 20,
            itemHeight: 25,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                timeOfDay = time;
              });
            },
          ),
        ],
      ),
    ];
  }

  ElevatedButton getButton() {
    return ElevatedButton(
      //padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      //color: primaryColor,
      onPressed: () async {
        final form = _formKey.currentState;
        if (form.validate()) {
          form.save();
          _exam.subjectName = widget.subjectName;
          _exam.date = DateTime(chosenDate.year, chosenDate.month,
              chosenDate.day, timeOfDay.hour, timeOfDay.minute);
          _exam.grade = -1;
          _exam.isFromUni = true;
          _exam.isKholle = false;
          await ExamProvider.dbExams.insertExam(_exam).then((value) {
            Navigator.pop(context);
          });
        } else {
          print('form did not validate');
        }
      },
      child: Text(
        'save'.toUpperCase(),
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

/*
DropdownButtonFormField(
value: widget.subjectNames[0],
decoration:
InputDecoration(labelText: 'Subject'),
validator: (value) {
if (value.isEmpty) {
return 'Please choose a subject';
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
),*/
