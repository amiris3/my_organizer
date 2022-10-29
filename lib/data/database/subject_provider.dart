import '../models/subject.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SubjectProvider {
  static const String TABLE_SUBJECT_NAME = "subject";
  static const String COLUMN_SUBJECT_ID = "id";
  static const String COLUMN_SUBJECT_KH_NB = "khNb";
  static const String COLUMN_SUBJECT_NAME = "name";

  SubjectProvider._();
  static final SubjectProvider dbSubjects = SubjectProvider._();
  Database _subjectsDatabase;

  Future<Database> get database async {
    if (_subjectsDatabase != null) return _subjectsDatabase;
    _subjectsDatabase = await createSubjectDatabase();
    return _subjectsDatabase;
  }

  Future<Database> createSubjectDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(join(dbPath, 'subjectsDb.db'), version: 1,
        onCreate: (Database database, int version) async {
      await database.execute("CREATE TABLE $TABLE_SUBJECT_NAME ("
          "$COLUMN_SUBJECT_ID INTEGER PRIMARY KEY,"
          "$COLUMN_SUBJECT_KH_NB INTEGER,"
          "$COLUMN_SUBJECT_NAME TEXT)");
    });
  }

  Future<List<Subject>> getAllSubjects() async {
    final db = await database;
    List subjects = await db.query(
      TABLE_SUBJECT_NAME,
      columns: [COLUMN_SUBJECT_ID, COLUMN_SUBJECT_KH_NB, COLUMN_SUBJECT_NAME],
    );
    List<Subject> subjectsList = List<Subject>();
    subjects.forEach((currentSubject) {
      Subject subject = Subject.fromMap(currentSubject);
      subjectsList.add(subject);
    });

    return subjectsList;
  }

  Future<Subject> insertSubject(Subject subject) async {
    final db = await database;
    subject.id = await db.insert(TABLE_SUBJECT_NAME, subject.toMap());
    return subject;
  }

  Future<void> updateSubject(Subject subject) async {
    final db = await database;
    await db.update(TABLE_SUBJECT_NAME, subject.toMap(),
        where: '$COLUMN_SUBJECT_ID = ?', whereArgs: [subject.id]);
  }

  Future<void> deleteSubject(Subject subject) async {
    final db = await database;
    await db.delete(TABLE_SUBJECT_NAME,
        where: '$COLUMN_SUBJECT_ID = ?', whereArgs: [subject.id]);
  }
}
