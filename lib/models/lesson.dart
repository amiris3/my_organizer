
class Lesson {

  final String subjectName;
  final String teacher;
  final DateTime dateTime;
  final String location;

  Lesson({this.subjectName, this.teacher, this.dateTime, this.location});

}

final List<Lesson> dummyLesson = [
  Lesson(
    subjectName: "M&I",
    teacher: "E. Fouassier",
    dateTime: DateTime.now(),
    location: "Amphi Ampère"
  ),
  Lesson(
      subjectName: "LIFAP6",
      teacher: "V. Nivoliers",
      dateTime: DateTime.now().add(Duration(hours: 2)),
      location: "Amphi Jussieu"
  ),
];