
class Lesson {

  int lessonId;
  String subjectName;
  String teacher;
  DateTime date;
  String location;

  Lesson({this.lessonId, this.subjectName, this.teacher, this.date,
    this.location});

  toMap() {
    return {
      'lessonId': lessonId,
      'subjectName': subjectName,
      'teacher' : teacher,
      'date': date.toIso8601String(),
      'location': location,
    };
  }

  Lesson.fromMap(Map<String, dynamic> map) {
    lessonId = map['lessonId'];
    subjectName = map['subjectName'];
    teacher = map['teacher'];
    date = DateTime.parse(map['date']);
    location = map['location'];
  }

}