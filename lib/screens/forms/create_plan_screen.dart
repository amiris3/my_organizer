import '../../widgets/basic_form.dart';
import '../../database/subject_provider.dart';
import '../../models/plan.dart';
import '../../screens/screen_start.dart';
import '../../styling.dart';
import 'package:flutter/material.dart';
import '../../models/subject.dart';
import 'add_subject.dart';

class CreatePlanScreen extends StatefulWidget {
  @override
  _CreatePlanScreenState createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State {
  final Plan _plan = Plan();
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
            style: TextStyle(fontSize: 25),
          ),
          backgroundColor: primaryColor,
        ),
        body: BasicForm(
          widgets: getWidgets(),
          formKey: _formKey,
          button: getButton(),
        ));
  }

  RaisedButton getButton() {
    return RaisedButton(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      color: primaryColor,
      onPressed: () async {
        final form = _formKey.currentState;
        if (form.validate()) {
          form.save();
          setState(() {
            loading = true;
          });
          if (allSubjects.isNotEmpty) {
            _plan.listOfSubjects = allSubjects;
            await _plan.createPlan();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ScreenStart()));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Please add your subjects'),
            ));
          }
        }
      },
      child: Text(
        'create it'.toUpperCase(),
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> getWidgets() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Number of weeks'),
        keyboardType: TextInputType.phone,
        validator: (value) {
          var potentialNumber = int.tryParse(value);
          if (potentialNumber == null) {
            return 'Please enter a number of weeks';
          }
        },
        onSaved: (val) => setState(() => _plan.weeksNb = int.parse(val)),
      ),
      InputDatePickerFormField(
        fieldLabelText: 'Beginning date',
        onDateSaved: (date) => setState(() => _plan.begin = date),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(
          days: 365,
        )),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Add your subjects below:',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Align(
                  alignment: FractionalOffset.topRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => AddSubject()),
                      ).then((value) => refreshList());
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  height: 250,
                  child: ListView.builder(
                    itemCount: allSubjects.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            mini: true,
                            heroTag: "btn$index",
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                allSubjects.removeAt(index);
                              });
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              gradient: listGradient,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  allSubjects[index].name.toUpperCase(),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
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
    ];
  }
}
