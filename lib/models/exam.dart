
class Exam {

  int examId;
  String subjectName;
  String examName;
  DateTime date;
  bool isKholle;
  bool isFromUni;
  int durationInMinutes;
  bool isDone = false;
  double grade;
  String notes = "";

  Exam({this.examId, this.subjectName, this.examName, this.date, this.grade, this.isKholle, this.isFromUni,
    this.durationInMinutes});

  toMap() {
    return {
      'examId': examId,
      'subjectName': subjectName,
      'examName': examName,
      'date': date.toIso8601String(),
      'isKholle': isKholle ? 1 : 0,
      'isFromUni': isFromUni ? 1 : 0,
      'durationInMinutes': durationInMinutes,
      'isDone': isDone ? 1 : 0,
      'grade': grade,
      'notes': notes
    };
  }

  Exam.fromMap(Map<String, dynamic> map) {
    examId = map['examId'];
    subjectName = map['subjectName'];
    examName = map['examName'];
    date = DateTime.parse(map['date']);
    isKholle = map['isKholle'] == 1 ? true : false;
    isFromUni = map['isFromUni'] == 1 ? true : false;
    durationInMinutes = map['durationInMinutes'];
    isDone = map['isDone'] == 1 ? true : false;
    grade = map['grade'];
    notes = map['notes'];
  }

}