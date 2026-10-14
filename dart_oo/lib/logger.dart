/// 日志能力：可混入任意类，记录带时间戳的消息。
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
