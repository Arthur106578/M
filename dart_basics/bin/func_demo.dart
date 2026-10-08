// func_demo.dart - 命名参数与箭头函数

// 命名参数（required 必填 + 默认值）
String enroll({required String name, int age = 18, String major = 'CS'}) {
  return '登记: $name, $age岁, 专业=$major';
}

// 箭头函数 => 表达式
int square(int n) => n * n;
String greet(String who) => '你好, $who!';

String funcDemo() {
  final buf = StringBuffer();
  buf.writeln('命名参数(全填): ${enroll(name: "Bob", age: 21, major: "软件工程")}');
  buf.writeln('命名参数(默认): ${enroll(name: "Cara")}');
  buf.writeln('箭头函数: square(7)=${square(7)}, greet="${greet("Dart")}"');
  return buf.toString();
}
