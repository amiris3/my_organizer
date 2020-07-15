import 'package:OrganiZer/database/subject_provider.dart';
import 'package:OrganiZer/models/plan.dart';
import 'package:OrganiZer/screens/screen_start.dart';
import 'package:flutter/material.dart';
import 'package:OrganiZer/models/subject.dart';
import 'add_subject.dart';

class CreatePlanScreen extends StatefulWidget {
  @override
  _CreatePlanScreenState createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State {
  final _plan = Plan();
  final _formKey = GlobalKey<FormState>();
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
          title: Text(
            'New khôlloscope',
            style: TextStyle(
              fontSize: 25
            ),
          ),
        backgroundColor: Colors.deepPurple[900],
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
                      decoration:
                      InputDecoration(labelText: 'Number of weeks'),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        var potentialNumber = int.tryParse(value);
                        if (potentialNumber == null) {
                          return 'Please enter a number of weeks';
                        }
                      },
                      onSaved: (val) =>
                          setState(() => _plan.weeksNb = int.parse(val)),
                    ),
                    InputDatePickerFormField(
                      fieldLabelText: 'Beginning date',
                      onDateSaved: (date) =>
                          setState(() => _plan.begin = date),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365,)),
                    ),
                    SizedBox(height: 15),
                    Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                        ),
                        height: MediaQuery.of(context).size.height-400,
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
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    heroTag:  "btn$index",
                                    backgroundColor: Colors.red[900],
                                    child: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        allSubjects.removeAt(index);
                                      });
                                      },
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
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
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              allSubjects[index].name.toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.deepPurple[900],
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                    ],
                    ),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AddSubject()),
                            ).then((value) => refreshList());
                          },
                          child: Icon(Icons.add),
                          backgroundColor: Colors.deepPurple[900],
                        ),
                      ],
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: RaisedButton(
                          color: Colors.deepPurple[900],
                            onPressed: () async {
                              final form = _formKey.currentState;
                              if (form.validate()) {
                                form.save();
                                setState(() {
                                  loading = true;
                                });
                                _plan.listOfSubjects = allSubjects;
                                await _plan.createPlan();
                                Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context)
                                          => ScreenStart()
                                      ));
                              }
                            },
                            child: Text(
                                'Start'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
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