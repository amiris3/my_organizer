import '../../widgets/basic_form.dart';
import '../../database/lesson_provider.dart';
import '../../styling.dart';
import 'package:flutter/material.dart';
import '../../models/lesson.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddLesson extends StatefulWidget {
  final String subjectName;
  AddLesson({this.subjectName});

  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {
  final _formKey = GlobalKey<FormState>();
  final _lesson = Lesson();
  DateTime timeOfDay = DateTime.now();
  DateTime chosenDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            centerTitle: true,
            title: Text(
              'Add a lesson for ' + widget.subjectName,
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
        decoration: InputDecoration(labelText: 'Teacher'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the lesson\'s teacher';
          }
        },
        onSaved: (val) => setState(() => _lesson.teacher = val),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Location'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the lesson\'s location';
          }
        },
        onSaved: (val) => setState(() => _lesson.location = val),
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
          _lesson.subjectName = widget.subjectName;
          _lesson.date = DateTime(chosenDate.year, chosenDate.month,
              chosenDate.day, timeOfDay.hour, timeOfDay.minute);
          await LessonProvider.dbLessons.insertLesson(_lesson).then((value) {
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
