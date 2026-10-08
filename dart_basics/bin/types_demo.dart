// types_demo.dart - 变量、插值、空安全四件套

String typesDemo() {
  final buf = StringBuffer();

  // === 1. 变量：var / final / const ===
  var name = 'Alice';
  final age = 20;
  const pi = 3.14159;
  buf.writeln('变量: name=$name (var), age=$age (final), pi=$pi (const)');

  // === 2. 字符串插值：$ 与 ${} ===
  buf.writeln('插值: ${name.toUpperCase()}明年${age + 1}岁, 圆周率≈$pi');

  // === 3. 空安全四件套：? / ?? / ! / late ===
  String? maybe; // ? 可空类型
  buf.writeln('空安全 ? : maybe=$maybe');
  buf.writeln('空安全 ?? : maybe=${maybe ?? "默认值"}');
  maybe = '已赋值';
  buf.writeln('空安全 ! : maybe!=$maybe'); // ! 非空断言

  late String lazy; // late 延迟初始化
  lazy = '延迟初始化完成';
  buf.writeln('空安全 late: $lazy');

  return buf.toString();
}
