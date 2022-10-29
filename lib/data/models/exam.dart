
class Exam {

  int examId;
  String subjectName;
  String examName;
  DateTime date;
  bool isKholle;
  bool isFromUni;
  int durationInMinutes;
  double grade;

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
      'grade': grade,
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
    grade = map['grade'];
  }

}