import 'dart:convert';
import 'dart:io';

import 'package:async_json/book.dart';
import 'package:path/path.dart' as p;

/// 异步读取本地数据副本 `data/books.json`，解析为 `List<Book>` 并汇总输出：
/// 总数、各类目数量（Map 统计）、借阅量 Top3。
Future<void> main(List<String> arguments) async {
  final file = File(p.join(Directory.current.path, 'data', 'books.json'));

  // 异常兜底①：文件缺失，给出友好提示而非 FileSystemException 崩溃堆栈。
  if (!await file.exists()) {
    print('数据文件缺失，请检查data/books.json');
    return;
  }

  final raw = await file.readAsString(); // 异步读取

  try {
    _report(_parse(raw));
  } on FormatException catch (e) {
    // 异常兜底②③：JSON 语法错误、字段缺失、字段类型不符，统一可读提示。
    print('数据格式错误：${e.message}');
  }
}

/// 把 JSON 文本解析为 `List<Book>`；语法 / 结构 / 字段问题统一抛 [FormatException]。
List<Book> _parse(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is! List) {
    throw const FormatException('JSON 顶层应为数组');
  }
  return decoded.map((e) {
    if (e is! Map<String, dynamic>) {
      throw FormatException('数组元素应为 JSON 对象，实际为 ${e.runtimeType}');
    }
    return Book.fromJson(e);
  }).toList();
}

/// 汇总输出：总数、各类目数量、借阅量 Top3。
void _report(List<Book> books) {
  print('总数：${books.length} 本');

  // 各类目数量：fold 聚合成 Map<String, int>
  final byCategory = books.fold<Map<String, int>>(<String, int>{}, (acc, book) {
    acc[book.category] = (acc[book.category] ?? 0) + 1;
    return acc;
  });
  print('各类目数量：$byCategory');

  // 借阅量 Top3：按 borrowCount 降序后取前三
  final top3 =
      (List<Book>.from(books)
            ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount)))
          .take(3);
  print('借阅量 Top3：');
  for (final book in top3) {
    print('  ${book.title} —— ${book.borrowCount} 次');
  }
}
