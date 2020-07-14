
import 'dart:ui';

import 'package:flutter/material.dart';

class Subject {

  int id;
  //TODO: find way to keep color in db ?
  int khNb;
  String name;
  String semester;

  Subject({this.id, this.khNb, this.name, this.semester});

  Subject.fill() {
    id = 0;
    khNb = 0;
    name = "Subject";
    semester = "S3";
  }

  toMap() {
    return {
     'id': id,
     'khNb': khNb,
     'name': name,
      'semester': semester
    };
  }

  Subject.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    khNb = map['khNb'];
    name = map['name'];
    semester = map['semester'];
  }

  getColorForSubject() {
    List<Color> colors = [
      Colors.green, Colors.deepPurple, Colors.orange
    ];

    return colors[id-1];
  }

}