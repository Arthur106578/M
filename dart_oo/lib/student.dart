/// 学生模型：姓名 + 成绩，带校验。
class Student {
  String _name;
  int _score;

  Student({required String name, required int score})
      : _name = _checkName(name),
        _score = _checkScore(score);

  /// 命名构造：从 JSON（Map）创建。
  Student.fromJson(Map<String, dynamic> json)
      : _name = _checkName(json['name'] as String),
        _score = _checkScore(json['score'] as int);

  String get name => _name;
  int get score => _score;

  set name(String value) => _name = _checkName(value);

  /// 校验 setter：成绩必须落在 0-100。
  set score(int value) => _score = _checkScore(value);

  Map<String, dynamic> toJson() => {'name': _name, 'score': _score};

  static String _checkName(String v) {
    if (v.trim().isEmpty) {
      throw ArgumentError.value(v, 'name', '姓名不能为空');
    }
    return v;
  }

  static int _checkScore(int v) {
    if (v < 0 || v > 100) {
      throw ArgumentError.value(v, 'score', '成绩须在 0-100 之间');
    }
    return v;
  }

  @override
  String toString() => 'Student($name, $score)';
}
