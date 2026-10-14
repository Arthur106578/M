# 进度报告5（课堂作业五 · async_json 案例复现）

> 使用方式：作答完成后将全文复制到雨课堂答题区，并将同一内容存入自己仓库 `lecture5/progress.md`。

---

## 一、任务理解

**本次作业目标**：完整复现课堂案例 `async_json`——异步读取课程统一数据集的本地副本，解析为模型并汇总输出；并完成 6.2 自主实践四项基本要求。

- 步骤一 准备数据与依赖：`dart create async_json`；`dart pub add path`；把 `books.json` 放入 `data/`（字段：id、title、category、borrowCount）；
- 步骤二 解析与统计：实现 `Book.fromJson`；main 异步读 `data/books.json`，解析为 `List<Book>`，输出总数、各类目数量（Map）、借阅量 Top3；
- 步骤三 异常路径：文件缺失走友好提示不崩溃；缺失字段默认 0；三类异常（文件缺失 / 字段缺失 / 类型错误）均可读提示；
- 6.2 自主实践：①async/await 改写（回调版→顺序 await）；②异常兜底；③JSON→类 + `toJson` 反向验证；④pubspec 规范。

**验收标准**：正常路径统计输出正确；文件缺失路径输出友好提示不崩溃；能解释 `await` 在案例中的作用；每步一次规范提交。

---

## 二、环境与工具

| 项 | 值 |
|---|---|
| 操作系统 | Windows 11 (25H2) |
| 编辑器 | TraeCode（集成 AI 助手） |
| Dart SDK | 3.13.3 (stable) |
| 语言/目标 | 纯 Dart 控制台工程（`dart run` / `dart test`） |
| Git | 2.55.0 |
| 仓库 | https://github.com/Arthur106578/M.git |
| 工程目录 | `async_json/`（与 `dart_basics/`、`dart_oo/` 同级） |
| 依赖 | `path ^1.9.0`（运行时）；`lints ^6.0.0`、`test ^1.25.6`（开发） |

---

## 三、过程记录（时间线）

| 时间 | 步骤 | 操作 | 提交 |
|---|---|---|---|
| 2026-10-14 | 步骤一 | `dart create async_json`；加 `path` 依赖；放入 `data/books.json` | `fdd1af6` |
| 2026-10-14 | 步骤二 | `Book.fromJson` 建模；main 异步读文件 + 总数/类目/Top3 | `adc1313` |
| 2026-10-14 | 步骤三 | 文件缺失友好提示 + 缺失字段默认 0；改前/改后对比 | `1c14d69` |
| 2026-10-14 | 6.2-2 | 字段校验改抛可读 `FormatException`，类型错误提示 | `5f65ad9` |
| 2026-10-14 | 6.2-3 | 加 `Book.toJson` + roundtrip 反向验证与用例 | `a94388a` |
| 2026-10-14 | 6.2-4 | 核查依赖 `^` 约束 / 无冗余 / lock 已提交（无代码改动） | 同上一提交 |
| 2026-10-14 | 报告记录 | 本文件 `lecture5/progress.md` | commit（待提交） |

---

## 四、关键代码

### 代码1：异步读取 + 汇总输出（bin/async_json.dart）

```dart
Future<void> main(List<String> arguments) async {
  final file = File(p.join(Directory.current.path, 'data', 'books.json'));

  // 异常兜底①：文件缺失，给出友好提示而非崩溃堆栈
  if (!await file.exists()) {
    print('数据文件缺失，请检查data/books.json');
    return;
  }

  final raw = await file.readAsString();       // 异步读取

  try {
    _report(_parse(raw));
  } on FormatException catch (e) {
    // 异常兜底②③：JSON 语法错误 / 字段缺失 / 类型不符
    print('数据格式错误：${e.message}');
  }
}
```

**要点**：`await` 依次等待 `exists()`、`readAsString()`；读取期挂起而不阻塞事件循环；`try/on FormatException` 把三类数据问题收敛为一句可读提示。

### 代码2：Book 完整字段模型化 + 可读校验（lib/book.dart）

```dart
factory Book.fromJson(Map<String, dynamic> json) {
  final id = json['id'];
  final title = json['title'];
  final category = json['category'];
  final borrowCount = json['borrowCount'] ?? 0;   // 缺失默认 0

  if (id is! int) {
    throw FormatException('字段 id 应为整数，实际为 ${id.runtimeType}');
  }
  // title / category / borrowCount 同理校验……

  return Book(id: id, title: title, category: category, borrowCount: borrowCount);
}

Map<String, dynamic> toJson() => {
  'id': id, 'title': title, 'category': category, 'borrowCount': borrowCount,
};
```

**要点**：把 `as int` 断言换成显式类型检查 + 带上下文的 `FormatException`；`borrowCount` 缺失默认 0；`toJson` 支持 roundtrip 反向验证。

### 代码3：统计（链式，无手写 for 做统计）

```dart
final byCategory = books.fold<Map<String, int>>(<String, int>{}, (acc, book) {
  acc[book.category] = (acc[book.category] ?? 0) + 1;
  return acc;
});                                                        // 类目数量

final top3 = (List<Book>.from(books)
      ..sort((a, b) => b.borrowCount.compareTo(a.borrowCount))).take(3); // Top3
```

---

## 五、检查点结果

| 检查项 | 状态 | 证据 |
|---|---|---|
| 正常路径统计输出正确 | ✅ | `总数：12 本`；`{文学: 4, 科技: 3, 历史: 3, 艺术: 2}`；Top3 红楼梦128 / 小王子115 / 人类简史103 |
| 文件缺失路径友好提示不崩溃 | ✅ | 改名后运行输出 `数据文件缺失，请检查data/books.json`，`EXIT=0`，无堆栈 |
| 缺失字段·改前 | ✅（反例） | `Unhandled exception: type 'Null' is not a subtype of type 'int' in type cast`，`EXIT=255` |
| 缺失字段·改后 | ✅ | 同一数据正常运行，缺失 `borrowCount` 计 0 |
| 类型错误可读提示 | ✅ | `数据格式错误：字段 id 应为整数，实际为 String`，`EXIT=0` |
| `dart analyze` 无告警 | ✅ | `No issues found!` |
| `dart test` 通过 | ✅ | `All tests passed!（+5）` |
| Git 提交规范 | ✅ | 全部 `feat:` / `docs:` 前缀 |

---

## 六、6.2 自主实践自查

| 序 | 要求 | 状态 | 说明 |
|---|---|---|---|
| 1 | async/await 改写（回调版→顺序 await） | ⬜ 待补 | 需作业页附的「嵌套回调版」原始代码；当前案例本身已是顺序 `await` 写法 |
| 2 | 异常兜底：文件缺失 / 字段缺失 / 类型错误均有可读提示 | ✅ | `fdd1af6` 起用 `exists()`；`5f65ad9` 起 `FormatException` 覆盖字段缺失与类型错误 |
| 3 | JSON→类：完整字段模型化 + `toJson` roundtrip 一致 | ✅ | `a94388a`；运行时输出 `roundtrip 校验：一致`，并有用例覆盖 |
| 4 | pubspec 规范：`^` 约束 / 无冗余 / lock 已提交 | ✅ | `path ^1.9.0`、`lints ^6.0.0`、`test ^1.25.6` 均有用途；`pubspec.lock` 在 `fdd1af6` 入库 |

---

## 七、问题与调试

**问题 1：缺失字段导致类型断言崩溃**

- 现象：删除某对象 `borrowCount` 后运行，抛 `type 'Null' is not a subtype of type 'int'`，退出码 255。
- 定位：`json['borrowCount'] as int` 对 `null` 做非空断言。
- 解决：`as int? ?? 0`，并在 6.2-2 中进一步改为显式类型检查 + `FormatException`，提示具体字段与实际类型。

**问题 2：`forEach` 触发 lint**

- 现象：`dart analyze` 报 `avoid_function_literals_in_foreach_calls`。
- 解决：打印改为 `for (final book in top3)` 循环；统计仍走链式。

**问题 3：文档注释尖括号被判为 HTML**

- 现象：`List<Book>` 出现在 `///` 注释中触发 `unintended_html_in_doc_comment`。
- 解决：用反引号包裹（`` `List<Book>` ``）。

**翻车点预防**：临时改名的 `books.json.bak`、临时改坏的字段，验证后均还原；`git diff -- data/books.json` 为空，仓库数据文件未被污染。

---

## 八、AI 使用记录（TraeCode）

| 序 | 用途 | 指令摘要 | AI 输出 | 本人验证 |
|---|---|---|---|---|
| 1 | 准备数据与依赖 | "步骤一：建工程 + 加 path + 放 books.json" | 工程骨架 + data/books.json | `dart analyze` 干净 |
| 2 | 解析与统计 | "步骤二：Book.fromJson + 异步读 + 总数/类目/Top3" | lib/book.dart + bin 改写 | `dart run` 输出核对 |
| 3 | 异常路径 | "步骤三：改名/删字段验证，加兜底" | exists 检查 + 默认 0 | 改前崩、改后不崩 |
| 4 | 6.2 补强 | "类型错误提示 + toJson roundtrip + pubspec 核查" | FormatException + toJson + 用例 | `analyze`/`test` 全绿 |

---

## 九、自评

| 作业要求 | 完成情况 |
|---|---|
| 6.1 案例复现（15） | ✅ 三步齐备 `fdd1af6` / `adc1313` / `1c14d69` |
| 6.1 检查点（5） | ✅ 正常/缺失/类型三条路径实测通过 |
| 6.1 Git 规范（5） | ✅ 每步一次提交，`feat:`/`docs:` 前缀 |
| 6.1 报告记录（5） | ✅ 本文件 |
| 6.2-1 async/await 改写 | ⬜ 待补素材 |
| 6.2-2 异常兜底 | ✅ 三类异常均可读提示 |
| 6.2-3 模型化 + roundtrip | ✅ `toJson` + 反向验证一致 |
| 6.2-4 pubspec 规范 | ✅ 约束/冗余/lock 均合规 |

---

## 十、一句话收获与下一步计划

**收获**：第一次把「异步 IO + 数据解析 + 异常分层」串成一条路径——`await` 让读写顺序清晰，类型检查把运行期崩溃前移为可读提示，`toJson` 反向验证又给「模型 ↔ JSON」加了把锁。

**下一步**：拿到作业页附的嵌套回调版代码后完成 6.2-1 改写对照（回调地狱 vs 顺序 `await`）。

**关键点：await 在本案例中的作用**

- `main` 为 `async`，`file.readAsString()` 返回 `Future<String>`；`await` 挂起当前函数、把 IO 交给事件循环，读完才拿到 `String`，代码顺序仍是「先读、后解析」。
- 连续 `await file.exists()` → `await file.readAsString()` 保证依赖顺序；去掉 `await` 会得到 `Future` 本身，无法 `jsonDecode`。
- 它只暂停、不阻塞线程，因此读盘期间程序仍可响应——这正是异步的收益。
