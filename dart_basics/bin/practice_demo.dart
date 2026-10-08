// practice_demo.dart - 自主实践 6.2 任务1-3（简化版）

// === 任务1：空安全改写 ===
// 危险原版（伪代码）：
//   String name;                // 未初始化
//   print(name.length);         // 编译错 / 运行时崩
// 改写：①类型加?  ②?.安全调用  ③?? 兜底
String? name;                              // ① 可空声明
int safeLen(String? s) => s?.length ?? 0;  // ② ③ 链式兜底

// === 任务2：命名参数设计（实验报告生成器）===
String report({
  required String title,    // 必填
  required String author,  // 必填
  int score = 0,           // 默认值
}) => '《$title》by $author, 得分=$score';

// === 任务3：控制流小程序（gradeOf 扩展，处理 100/0/非法输入）===
String gradeOf(dynamic x) {
  // 类型与解析校验
  if (x is! int && x is! String) return '非法输入: 类型不支持';
  final n = x is String ? int.tryParse(x) : x;
  if (n == null) return '非法输入: 非数字';
  // 边界校验
  if (n < 0 || n > 100) return '非法分数: $n (应在 0-100)';
  // 分级（100/0 单独标注）
  if (n == 100) return 'A+ (满分)';
  if (n == 0) return 'F (零分)';
  if (n >= 90) return 'A';
  if (n >= 80) return 'B';
  if (n >= 70) return 'C';
  if (n >= 60) return 'D';
  return 'F';
}

String practiceDemo() {
  final b = StringBuffer();
  b.writeln('--- 任务1: 空安全改写 ---');
  b.writeln('name 未赋值: name=$name, safeLen=${safeLen(name)}');
  name = 'Alice';
  b.writeln('name 赋值后: name=$name, safeLen=${safeLen(name)}');

  b.writeln('\n--- 任务2: 命名参数（3 种调用）---');
  b.writeln(report(title: '实验一', author: '张三'));                       // 仅必填
  b.writeln(report(title: '实验二', author: '李四', score: 95));           // + 一个可选
  b.writeln(report(author: '王五', title: '实验三', score: 88));           // 顺序无关

  b.writeln('\n--- 任务3: 控制流扩展 gradeOf ---');
  for (final s in [100, 95, 80, 60, 0, 45, -5, 101, 'abc', '75']) {
    b.writeln('  $s -> ${gradeOf(s)}');
  }
  return b.toString();
}
