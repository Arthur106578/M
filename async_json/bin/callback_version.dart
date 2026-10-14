import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';
import 'package:path/path.dart' as p;

/// 【改写前 · 嵌套回调版】
///
/// 与 `bin/async_json.dart` 完成同一件事（读文件 → 解析 → 统计），
/// 但用 `Future.then / catchError` 层层嵌套：
///  - 逻辑被拆进多层闭包，越读越深（“回调地狱”）；
///  - 错误处理分散在每一层的 catchError 里，容易漏。
/// 该版本仅用于与顺序 `await` 版做前后对比。
void main(List<String> arguments) {
  final file = File(p.join(Directory.current.path, 'data', 'books.json'));

  file.exists().then((exists) {
    if (!exists) {
      print('数据文件缺失，请检查data/books.json');
      return;
    }

    file
        .readAsString()
        .then((raw) {
          final books = (jsonDecode(raw) as List<dynamic>)
              .map((e) => Book.fromJson(e as Map<String, dynamic>))
              .toList();

          final byCategory = books.fold<Map<String, int>>(
            <String, int>{},
            (acc, book) {
              acc[book.category] = (acc[book.category] ?? 0) + 1;
              return acc;
            },
          );

          final top3 =
              (List<Book>.from(books)
                    ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount)))
                  .take(3);

          print('总数：${books.length} 本');
          print('各类目数量：$byCategory');
          print('借阅量 Top3：');
          for (final book in top3) {
            print('  ${book.title} —— ${book.borrowCount} 次');
          }
        })
        .catchError((Object e) => print('数据格式错误：$e'));
  }).catchError((Object e) => print('读取失败：$e'));
}
