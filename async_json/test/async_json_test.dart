import 'package:async_json/async_json.dart';
import 'package:test/test.dart';

void main() {
  group('Book.fromJson', () {
    test('从 JSON Map 正确解析四个字段', () {
      final book = Book.fromJson(const {
        'id': 1,
        'title': '红楼梦',
        'category': '文学',
        'borrowCount': 128,
      });

      expect(book.id, 1);
      expect(book.title, '红楼梦');
      expect(book.category, '文学');
      expect(book.borrowCount, 128);
    });

    test('borrowCount 缺失时默认为 0，不抛异常', () {
      final book = Book.fromJson(const {
        'id': 5,
        'title': '时间简史',
        'category': '科技',
      });

      expect(book.borrowCount, 0);
    });

    test('字段缺失时抛出可读的 FormatException', () {
      expect(
        () => Book.fromJson(const {'id': 2}),
        throwsA(isA<FormatException>()),
      );
    });

    test('字段类型不符时抛出可读的 FormatException', () {
      expect(
        () => Book.fromJson(const {
          'id': '2',
          'title': '活着',
          'category': '文学',
          'borrowCount': 96,
        }),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
