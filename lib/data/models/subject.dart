
class Subject {

  int id;
  int khNb;
  String name;

  Subject({this.id, this.khNb, this.name});

  Subject.fill() {
    id = 0;
    khNb = 0;
    name = "Subject";
  }

  toMap() {
    return {
     'id': id,
     'khNb': khNb,
     'name': name
    };
  }

  Subject.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    khNb = map['khNb'];
    name = map['name'];
  }

}