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

    test('字段缺失时抛出类型转换异常', () {
      expect(() => Book.fromJson(const {'id': 2}), throwsA(isA<TypeError>()));
    });
  });
}
