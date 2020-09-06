import '../models/lesson.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LessonProvider {

  static const String TABLE_LESSON_NAME = "lesson";
  static const String COLUMN_LESSON_ID = "lessonId";
  static const String COLUMN_LESSON_SUBJECT_NAME = "subjectName";
  static const String COLUMN_LESSON_DATE = "date";
  static const String COLUMN_LESSON_LOCATION = 'location';
  static const String COLUMN_LESSON_TEACHER = 'teacher';

  LessonProvider._();

  static final LessonProvider dbLessons = LessonProvider._();
  Database _lessonsDatabase;

  Future<Database> get database async {
    if (_lessonsDatabase != null) return _lessonsDatabase;
    _lessonsDatabase = await createLessonDatabase();
    return _lessonsDatabase;
  }

  Future<Database> createLessonDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
        join(dbPath, 'lessonsDb.db'),
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(
              "CREATE TABLE $TABLE_LESSON_NAME ("
                  "$COLUMN_LESSON_ID INTEGER PRIMARY KEY,"
                  "$COLUMN_LESSON_SUBJECT_NAME TEXT,"
                  "$COLUMN_LESSON_DATE TEXT,"
                  "$COLUMN_LESSON_LOCATION TEXT,"
                  "$COLUMN_LESSON_TEACHER TEXT)"
          );
        }
    );
  }

  Future<List<Lesson>> getAllLessons() async {
    final db = await database;
    List lessons = await db.query(
      TABLE_LESSON_NAME,
      columns: [
        COLUMN_LESSON_ID,
        COLUMN_LESSON_SUBJECT_NAME,
        COLUMN_LESSON_DATE,
        COLUMN_LESSON_LOCATION,
        COLUMN_LESSON_TEACHER
      ],
    );
    List<Lesson> lessonsList = List<Lesson>();
    lessons.forEach((currentLesson) {
      Lesson lesson = Lesson.fromMap(currentLesson);
      lessonsList.add(lesson);
    });
    return lessonsList;
  }

  Future<Lesson> insertLesson(Lesson lesson) async {
    final db = await database;
    lesson.lessonId = await db.insert(
        TABLE_LESSON_NAME,
        lesson.toMap());
    return lesson;
  }

}

