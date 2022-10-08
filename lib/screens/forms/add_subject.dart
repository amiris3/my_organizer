import '../../widgets/basic_form.dart';
import '../../database/subject_provider.dart';
import '../../styling.dart';
import 'package:flutter/material.dart';
import '../../models/subject.dart';

class AddSubject extends StatefulWidget {
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State {
  final _formKey = GlobalKey<FormState>();
  final _subject = Subject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: Text(
            'Add a subject',
            style: TextStyle(fontSize: 23),
          ),
        ),
        body: BasicForm(
          widgets: getWidgets(),
          formKey: _formKey,
          button: getButton(),
        ));
  }

  List<Widget> getWidgets() {
    return [
      TextFormField(
        maxLength: 13,
        decoration: InputDecoration(labelText: 'Subject name'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter your first name';
          }
        },
        onSaved: (val) => setState(() => _subject.name = val),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Khôlles number'),
        validator: (value) {
          var potentialNb = int.tryParse(value);
          if (potentialNb == null) {
            return 'Please enter the khôlles number';
          }
        },
        onSaved: (val) => setState(() => _subject.khNb = int.parse(val)),
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
          await SubjectProvider.dbSubjects
              .insertSubject(_subject)
              .then((value) {
            Navigator.pop(context);
          });
        } else {
          print('form did not validate');
        }
      },
      child: Text(
        'save'.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
