// flow_demo.dart - 分级器与 for-in 循环

// 分级器：按分数返回等级
String gradeOf(int score) {
  if (score < 0 || score > 100) return '无效';
  if (score >= 90) return 'A';
  if (score >= 80) return 'B';
  if (score >= 70) return 'C';
  if (score >= 60) return 'D';
  return 'F';
}

String flowDemo() {
  final buf = StringBuffer();

  // 分级器：对一组分数批量分级
  buf.writeln('分级器 gradeOf:');
  for (final s in [95, 82, 73, 60, 45]) {
    buf.writeln('  $s -> ${gradeOf(s)}');
  }

  // for-in 遍历字符串列表
  buf.writeln('for-in 遍历姓名:');
  for (final name in ['Alice', 'Bob', 'Cara']) {
    buf.writeln('  - $name');
  }

  return buf.toString();
}
