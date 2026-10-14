import 'student.dart';

/// 成绩册：内部持有学生列表，构造时接收列表。
class GradeBook {
  final List<Student> _students;

  GradeBook(List<Student> students) : _students = List.of(students);

  GradeBook.fromJson(List<dynamic> json)
      : _students = json
            .map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList();

  /// 只读视图，防止外部直接改写内部列表。
  List<Student> get students => List.unmodifiable(_students);

  int get length => _students.length;

  @override
  String toString() => 'GradeBook(${_students.length} students)';
}
