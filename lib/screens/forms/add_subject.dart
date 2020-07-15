import 'package:OrganiZer/database/subject_provider.dart';
import 'package:flutter/material.dart';
import 'package:OrganiZer/models/subject.dart';

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
            backgroundColor: Colors.deepPurple[900],
            centerTitle: true,
            title: Text('Add a subject',
            style: TextStyle(
                fontSize: 23
            ),
            ),
        ),
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
                                    maxLength: 13,
                                    decoration:
                                    InputDecoration(labelText: 'Subject name'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                    },
                                    onSaved: (val) =>
                                        setState(() => _subject.name = val),
                                  ),
                                  DropdownButtonFormField(
                                    hint: Text('Select a semester'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter the semester';
                                      }
                                    },
                                    items: ['S1', 'S2', 'S3', 'S4', 'S5', 'S6', 'S7']
                                        .map((semester) => DropdownMenuItem(
                                        value: semester, child: Text("$semester")))
                                        .toList(),
                                    onChanged: (String value) {},
                                    onSaved: (semester) => setState(()=> _subject.semester = semester),
                                  ),
                                  TextFormField(
                                    decoration:
                                    InputDecoration(labelText: 'Khôlles number'),
                                    validator: (value) {
                                      var potentialNb = int.tryParse(value);
                                      if (potentialNb == null) {
                                        return 'Please enter the khôlles number';
                                      }
                                    },
                                    onSaved: (val) =>
                                        setState(() => _subject.khNb = int.parse(val)),
                                  ),
                                  SizedBox(height: 30,),
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 16.0),
                                      child: RaisedButton(
                                          color: Colors.deepPurple[900],
                                          onPressed: () async {
                                            final form = _formKey.currentState;
                                            if (form.validate()) {
                                              form.save();
                                              print(_subject.name);
                                              await SubjectProvider.dbSubjects.insertSubject(_subject).then((value) {
                                                Navigator.pop(context);
                                              });
                                            }
                                            else {
                                              print('form did not validate');
                                            }
                                          },
                                          child: Text('Save'.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                              )))),
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