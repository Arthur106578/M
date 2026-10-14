import 'package:dart_oo/gradebook.dart';
import 'package:dart_oo/student.dart';
import 'package:test/test.dart';

void main() {
  final sample = GradeBook([
    Student(name: 'A', score: 95),
    Student(name: 'B', score: 88),
    Student(name: 'C', score: 72),
    Student(name: 'D', score: 60),
    Student(name: 'E', score: 45),
  ]);

  group('GradeBook 统计', () {
    test('正常数据：平均分/最高分/及格数/分档 均正确', () {
      // (95 + 88 + 72 + 60 + 45) / 5 = 72.0
      expect(sample.average, closeTo(72.0, 1e-9));
      expect(sample.maxBy?.name, 'A');
      expect(sample.maxBy?.score, 95);
      expect(sample.countPassed, 4); // A B C D 及格，E 不及格

      final groups = sample.groupByGrade;
      expect(groups['优']!.map((s) => s.name).toList(), ['A']);
      expect(groups['良']!.map((s) => s.name).toList(), ['B']);
      expect(groups['中']!.map((s) => s.name).toList(), ['C']);
      expect(groups['及格']!.map((s) => s.name).toList(), ['D']);
      expect(groups['不及格']!.map((s) => s.name).toList(), ['E']);
    });

    test('空册：average 为 0、maxBy 为 null、countPassed 为 0', () {
      final empty = GradeBook([]);
      expect(empty.average, 0);
      expect(empty.maxBy, isNull);
      expect(empty.countPassed, 0);
      expect(empty.groupByGrade, isEmpty);
    });
  });

  group('Student 分数越界', () {
    test('构造、fromJson 与 setter 遇越界分数抛 ArgumentError', () {
      expect(() => Student(name: 'X', score: 101), throwsArgumentError);
      expect(() => Student(name: 'X', score: -1), throwsArgumentError);
      expect(
        () => Student.fromJson({'name': 'Y', 'score': 150}),
        throwsArgumentError,
      );

      final s = Student(name: 'Z', score: 80);
      expect(() => s.score = 101, throwsArgumentError);
      expect(s.score, 80, reason: '越界赋值被拒绝后原值应保持不变');
    });
  });

  test('Logger 混入：构造时写入日志', () {
    expect(sample.logs, isNotEmpty);
    final fresh = GradeBook([Student(name: 'Q', score: 90)]);
    expect(fresh.logs.single, contains('1 名学生'));
  });
}
