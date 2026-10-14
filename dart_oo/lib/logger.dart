/// 日志能力：可混入任意类，记录带时间戳的消息。
///
/// 为什么用混入（mixin）替代一层继承：
/// 1. 日志是横切关注点，与"成绩册"不是 is-a 关系——GradeBook 并非"一种 Logger"。
/// 2. Dart 是单继承，`extends` 只有一个名额；若写成 `extends LoggerBase`，
///    就把唯一的父类位浪费在能力复用上，之后无法再继承真正的领域基类。
/// 3. mixin 可跨多个不相关类复用，还能叠加（`with Logger, Serializable`），
///    继承做不到这一点。
/// 4. 因此 GradeBook 采用 `with Logger`：统计逻辑留在自己类内，
///    日志能力横向注入，类型层级更扁平，`GradeBook is Logger` 仍然成立。
mixin Logger {
  final List<String> _logs = <String>[];

  /// 已记录的日志（只读视图）。
  List<String> get logs => List.unmodifiable(_logs);

  /// 记录一条日志并回显。
  void log(String message) {
    _logs.add('[${DateTime.now().toIso8601String()}] $message');
  }

  /// 清空日志。
  void clearLogs() => _logs.clear();
}
