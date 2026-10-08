import 'package:dart_basics/dart_basics.dart' as dart_basics;
import 'types_demo.dart';
import 'func_demo.dart';
import 'flow_demo.dart';
import 'practice_demo.dart';

void main(List<String> arguments) {
  print('=== 默认模板 ===');
  print('Hello world: ${dart_basics.calculate()}!');

  print('\n=== 变量 / 插值 / 空安全四件套 ===');
  print(typesDemo());

  print('\n=== 命名参数 / 箭头函数 ===');
  print(funcDemo());

  print('\n=== 分级器 / for-in 循环 ===');
  print(flowDemo());

  print('\n=== 自主实践 6.2 任务1-3 ===');
  print(practiceDemo());
}
