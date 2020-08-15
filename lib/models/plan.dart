import 'dart:math';
import '../database/exam_provider.dart';
import 'subject.dart';
import 'exam.dart';

class Plan {

  int weeksNb;
  DateTime begin;
  List<Subject> listOfSubjects;

  Plan();

  createPlan() async {
    //add as many strings (subject name) as kholle number for each subject
    //shuffle the list with subject ids and check that there aren't exams of the
    //same subject following each other (five times better than one)
    List<String> listOfStrings = List<String>();
    for (Subject subject in listOfSubjects) {
      for (int i=0;i<subject.khNb;i++) {
        listOfStrings.add(subject.name);
      }
    }
    listOfStrings.shuffle();
    for (int i=0; i<5;i++) {
      listOfStrings = rearrangeList(listOfStrings);
    }

    //calculate how many weeks have three kholles and how many have two
    // then create a list to match what weeks have three kholles and what
    // weeks have two, shuffle it and hope there won't be two following weeks
    //with three kholles
    int khNb3weeks = listOfStrings.length % weeksNb;
    int khNb2weeks = weeksNb - khNb3weeks;
    List<int> khNumberPerWeek = List();

    for (int i=0;i<khNb2weeks;i++) {
      khNumberPerWeek.add(2);
    }
    for (int i=0;i<khNb3weeks;i++) {
      khNumberPerWeek.add(3);
    }
    assert(khNumberPerWeek.length == weeksNb);
    khNumberPerWeek.shuffle();

    List<Exam> listOfExams = createListOfExams(listOfStrings.length, khNumberPerWeek, listOfStrings);
    insertListOfExamsInDatabase(listOfExams);

  }

  List<String> rearrangeList(List<String> list) {
    for (int y = 0; y<list.length-1;y++) {
      if (list[y] == list[y+1]) {
        if (y == list.length-1) {
          String temp = list[y];
          list[y] = list[y-1];
          list[y-1] = temp;
        }
        else {
          String temp = list[y];
          list[y] = list[y+1];
          list[y+1] = temp;
        }
      }
    }
    return list;
  }

  List<Exam> createListOfExams(int khNb, List<int> nbKhPerWeek, List<String> subjectNames) {
    List<Exam> list = List<Exam>();
    int khNumber = 1;

    //first, find the next date being a Monday from the begin date's weekday
    //set it to 18h
    int numDaysToAdd = begin.weekday == 1 ? 0 : 8-begin.weekday;
    begin = begin.add(Duration(days: numDaysToAdd));
    DateTime currentDate = DateTime(begin.year, begin.month, begin.day, 18, 00);

    int weeklyNb = 1;
    var randNb = new Random();

    for (int i in nbKhPerWeek) {
      khNb++;
      if (i == 2) {
        currentDate = currentDate.add(Duration(days: 1));
        //tuesday
        //to test later :
        // if (currentDate.weekday != 1) currentDate = currentDate.add(Duration(days: 8-currentDate.weekday));
        list.add(Exam(
          examName: 'Khôlle n°' + khNumber.toString(),
          subjectName: subjectNames[khNumber-1], durationInMinutes: 30,
          grade: randNb.nextInt(20).toDouble(), isKholle: true, isFromUni: false, date: currentDate));

        khNumber++;
        currentDate = currentDate.add(Duration(days: 2));

        //thursday
        list.add(Exam(
          examName: 'Khôlle n°' + khNumber.toString(),
          subjectName: subjectNames[khNumber-1], durationInMinutes: 30,
          grade: randNb.nextInt(20).toDouble(), isKholle: true, isFromUni: false, date: currentDate));

        khNumber++;
        currentDate = currentDate.add(Duration(days: 3));

      }
      else {
        //monday
        list.add(Exam(
          examName: 'Khôlle n°' + khNumber.toString(),
          subjectName: subjectNames[khNumber-1], durationInMinutes: 30,
          grade: randNb.nextInt(20).toDouble(), isKholle: true, isFromUni: false, date: currentDate));

        khNumber++;
        currentDate = currentDate.add(Duration(days: 2));

        //wednesday
        list.add(Exam(
          examName: 'Khôlle n°' + khNumber.toString(),
          subjectName: subjectNames[khNumber-1], durationInMinutes: 30,
          grade: randNb.nextInt(20).toDouble(), isKholle: true, isFromUni: false, date: currentDate));

        khNumber++;
        currentDate = currentDate.add(Duration(days: 2));

        //friday
        list.add(Exam(
          examName: 'Khôlle n°' + khNumber.toString(),
          subjectName: subjectNames[khNumber-1], durationInMinutes: 30,
          grade: randNb.nextInt(20).toDouble(), isKholle: true, isFromUni: false, date: currentDate));

        khNumber++;
        currentDate = currentDate.add(Duration(days: 2));
      }

      //weekly exam on Sundays
      list.add(Exam(
          examName: 'DS n° $weeklyNb',
          subjectName: listOfSubjects[weeklyNb % listOfSubjects.length].name,
          durationInMinutes: 60,
          grade: randNb.nextInt(20).toDouble(), isKholle: false, isFromUni: false, date: currentDate));

      weeklyNb++;
      currentDate = currentDate.add(Duration(days: 1));
    }
    return list;
  }

  void insertListOfExamsInDatabase(List<Exam> listOfExams) async {
    for (Exam exam in listOfExams) {
      await ExamProvider.dbExams.insertExam(exam);
    }
  }

}


