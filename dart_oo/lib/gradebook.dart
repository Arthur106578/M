import 'logger.dart';
import 'student.dart';

/// 成绩册：内部持有学生列表，构造时接收列表；混入 Logger 记录日志。
class GradeBook with Logger {
  final List<Student> _students;

  /// 及格线
  static const int passScore = 60;

  GradeBook(List<Student> students) : _students = List.of(students) {
    log('GradeBook 初始化：${_students.length} 名学生');
  }

  GradeBook.fromJson(List<dynamic> json)
      : _students = json
            .map((e) => Student.fromJson(e as Map<String, dynamic>))
            .toList() {
    log('GradeBook.fromJson 载入：${_students.length} 名学生');
  }

  /// 只读视图，防止外部直接改写内部列表。
  List<Student> get students => List.unmodifiable(_students);

  int get length => _students.length;

  /// 平均分（空册返回 0）。
  double get average => _students.isEmpty
      ? 0
      : _students.map((s) => s.score).reduce((a, b) => a + b) /
          _students.length;

  /// 最高分学生（空册返回 null；同分取先出现者）。
  Student? get maxBy => _students.isEmpty
      ? null
      : _students.reduce((a, b) => b.score > a.score ? b : a);

  /// 及格人数。
  int get countPassed =>
      _students.where((s) => s.score >= passScore).length;

  /// 按优/良/中/及格/不及格分档。
  Map<String, List<Student>> get groupByGrade =>
      _students.fold(<String, List<Student>>{}, (acc, s) {
        (acc[_band(s.score)] ??= <Student>[]).add(s);
        return acc;
      });

  /// 一组链式统计：各档平均分（按档位名升序）。
  /// 一条链路集齐 entries → where → map → map → fold → toList → sort，共 7 个集合方法。
  Map<String, double> get averageByGrade => Map.fromEntries(
        groupByGrade
            .entries
            .where((e) => e.value.isNotEmpty)
            .map((e) => MapEntry(
                  e.key,
                  e.value.map((s) => s.score).fold<double>(0, (sum, v) => sum + v) /
                      e.value.length,
                ))
            .toList()
          ..sort((a, b) => a.key.compareTo(b.key)),
      );

  /// 分数 -> 档位。
  static String _band(int score) {
    if (score >= 90) return '优';
    if (score >= 80) return '良';
    if (score >= 70) return '中';
    if (score >= passScore) return '及格';
    return '不及格';
  }

  @override
  String toString() => 'GradeBook(${_students.length} students)';
}
