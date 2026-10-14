/// 图书模型：字段与统一数据集一一对应（id、title、category、borrowCount）。
class Book {
  final int id; // 编号
  final String title; // 书名
  final String category; // 类目
  final int borrowCount; // 借阅量

  Book({
    required this.id,
    required this.title,
    required this.category,
    required this.borrowCount,
  });

  /// 命名构造：从 JSON Map 反序列化为 Book。
  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'] as int,
    title: json['title'] as String,
    category: json['category'] as String,
    // borrowCount 缺失或为 null 时默认 0，避免 `null as int` 断言崩溃。
    borrowCount: json['borrowCount'] as int? ?? 0,
  );

  @override
  String toString() => '$title（$category，借阅 $borrowCount 次）';
}
