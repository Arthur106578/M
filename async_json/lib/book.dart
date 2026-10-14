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
  ///
  /// 字段缺失或类型不符时抛出可读的 [FormatException]，而不是 `null as int`
  /// 这类类型断言崩溃，便于上层统一给出友好提示。
  factory Book.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final category = json['category'];
    final borrowCount = json['borrowCount'] ?? 0; // 缺失时默认 0

    if (id is! int) {
      throw FormatException('字段 id 应为整数，实际为 ${id.runtimeType}');
    }
    if (title is! String) {
      throw FormatException('字段 title 应为字符串，实际为 ${title.runtimeType}');
    }
    if (category is! String) {
      throw FormatException('字段 category 应为字符串，实际为 ${category.runtimeType}');
    }
    if (borrowCount is! int) {
      throw FormatException('字段 borrowCount 应为整数，实际为 ${borrowCount.runtimeType}');
    }

    return Book(
      id: id,
      title: title,
      category: category,
      borrowCount: borrowCount,
    );
  }

  /// 序列化回 JSON Map，供 roundtrip 反向验证：fromJson(toJson()) 应保持一致。
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'category': category,
    'borrowCount': borrowCount,
  };

  @override
  String toString() => '$title（$category，借阅 $borrowCount 次）';
}
