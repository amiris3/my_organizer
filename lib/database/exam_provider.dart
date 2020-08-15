import '../models/exam.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ExamProvider {

  static const String TABLE_EXAM_NAME = "exam";
  static const String COLUMN_EXAM_ID = "examId";
  static const String COLUMN_EXAM_SUBJECT_NAME = "subjectName";
  static const String COLUMN_EXAM_NAME = "examName";
  static const String COLUMN_EXAM_DATE = "date";
  static const String COLUMN_EXAM_IS_KHOLLE = 'isKholle';
  static const String COLUMN_EXAM_IS_FROM_UNI = 'isFromUni';
  static const String COLUMN_EXAM_DURATION = 'durationInMinutes';
  static const String COLUMN_EXAM_IS_DONE = 'isDone';
  static const String COLUMN_EXAM_GRADE = 'grade';
  static const String COLUMN_EXAM_NOTES = 'notes';


  ExamProvider._();

  static final ExamProvider dbExams = ExamProvider._();
  Database _examsDatabase;

  Future<Database> get database async {
    if (_examsDatabase != null) return _examsDatabase;
    _examsDatabase = await createExamDatabase();
    return _examsDatabase;
  }

  Future<Database> createExamDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
        join(dbPath, 'examsDb.db'),
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(
              "CREATE TABLE $TABLE_EXAM_NAME ("
                  "$COLUMN_EXAM_ID INTEGER PRIMARY KEY,"
                  "$COLUMN_EXAM_SUBJECT_NAME TEXT,"
                  "$COLUMN_EXAM_NAME TEXT,"
                  "$COLUMN_EXAM_DATE TEXT,"
                  "$COLUMN_EXAM_IS_KHOLLE INTEGER,"
                  "$COLUMN_EXAM_IS_FROM_UNI INTEGER,"
                  "$COLUMN_EXAM_DURATION INTEGER,"
                  "$COLUMN_EXAM_IS_DONE INTEGER,"
                  "$COLUMN_EXAM_GRADE FLOAT,"
                  "$COLUMN_EXAM_NOTES TEXT)"
          );
        }
    );
  }

  Future<List<Exam>> getAllExams() async {
    final db = await database;
    List exams = await db.query(
      TABLE_EXAM_NAME,
      columns: [
        COLUMN_EXAM_ID,
        COLUMN_EXAM_SUBJECT_NAME,
        COLUMN_EXAM_NAME,
        COLUMN_EXAM_DATE,
        COLUMN_EXAM_IS_KHOLLE,
        COLUMN_EXAM_IS_FROM_UNI,
        COLUMN_EXAM_DURATION,
        COLUMN_EXAM_IS_DONE,
        COLUMN_EXAM_GRADE,
        COLUMN_EXAM_NOTES
      ],
    );
    List<Exam> examsList = List<Exam>();
    exams.forEach((currentExam) {
      Exam exam = Exam.fromMap(currentExam);
      examsList.add(exam);
    });
    return examsList;
  }

  Future<Exam> insertExam(Exam exam) async {
    final db = await database;
    exam.examId = await db.insert(
        TABLE_EXAM_NAME,
        exam.toMap());
    return exam;
  }

  Future<void> updateExam(Exam exam) async {
    final db = await database;
    await db.update(
        TABLE_EXAM_NAME,
        exam.toMap(),
        where: '$COLUMN_EXAM_ID = ?',
        whereArgs: [exam.examId]);
  }

}

