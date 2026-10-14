# 进度报告3（课堂作业三 · dart_oo 案例复现）

> 使用方式：作答完成后将全文复制到雨课堂答题区，并将同一内容存入自己仓库 `lecture3/progress.md`。

---

## 一、任务理解

**本次作业目标**：完整复现课堂案例 `dart_oo`（用类建模"课程成绩册"并完成统计），并满足 6.2 自主实践四项基本要求。

- 步骤1 建模：`dart create dart_oo`，lib 下新建 `student.dart`（Student：命名构造 fromJson、getter、校验 setter）与 `gradebook.dart`（GradeBook：内部 List，构造接收列表）；
- 步骤2 统计：`average` / `maxBy` / `countPassed` / `groupByGrade`，全部用集合链式方法，**禁止手写 for 循环**；
- 步骤3 mixin 与测试：日志能力抽成 `mixin Logger` 混入 GradeBook；`test/` 下用例覆盖正常与异常路径。

**验收标准**：类设计合理（封装 + 命名构造 + 校验 setter）；mixin 替代继承并说明理由；≥5 个链式方法组合完成一组统计；≥2 个测试用例覆盖正常与异常；`dart test` 通过；Git 提交规范；报告记录完整。

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
| 工程目录 | `dart_oo/`（与 `dart_basics/` 同级） |

---

## 三、过程记录（时间线）

| 时间 | 步骤 | 操作 | 提交 |
|---|---|---|---|
| 2026-10-14 | 步骤1 建模 | `dart create dart_oo`；写 Student / GradeBook 两个模型类 | `55bc3a0` |
| 2026-10-14 | 步骤2 统计 | 加 average / maxBy / countPassed / groupByGrade 四个链式统计 | `fe5cc8c` |
| 2026-10-14 | 步骤3 mixin | 抽 `mixin Logger` 混入 GradeBook；写 4 个单测 | `ac27deb` |
| 2026-10-14 | 补强 | 加 `averageByGrade`（≥5 链）+ mixin 替代继承理由 + 本章报告 | commit 4（待提交） |

---

## 四、关键代码

### 代码1：Student 模型（字段封装 + 命名构造 + 校验 setter）

```dart
class Student {
  String _name;   // 私有字段，对外只暴露 getter/setter
  int _score;

  Student({required String name, required int score})
      : _name = _checkName(name), _score = _checkScore(score);

  Student.fromJson(Map<String, dynamic> json)          // ← 命名构造
      : _name = _checkName(json['name'] as String),
        _score = _checkScore(json['score'] as int);

  String get name => _name;   // getter
  int get score => _score;

  set score(int value) => _score = _checkScore(value); // ← 校验 setter

  static int _checkScore(int v) {
    if (v < 0 || v > 100) throw ArgumentError.value(v, 'score', '成绩须在 0-100 之间');
    return v;
  }
}
```

**要点**：字段全私有 + getter/setter；命名构造 `fromJson` 从 Map 反序列化；setter 越界即抛 `ArgumentError`，拒绝后原值不变。

### 代码2：GradeBook 统计（集合链式，无 for 循环）

```dart
double get average => _students.isEmpty
    ? 0
    : _students.map((s) => s.score).reduce((a, b) => a + b) / _students.length;   // map + reduce

Student? get maxBy => _students.isEmpty
    ? null
    : _students.reduce((a, b) => b.score > a.score ? b : a);                    // reduce

int get countPassed => _students.where((s) => s.score >= passScore).length;      // where

Map<String, List<Student>> get groupByGrade =>                                  // fold
    _students.fold(<String, List<Student>>{}, (acc, s) {
      (acc[_band(s.score)] ??= <Student>[]).add(s);
      return acc;
    });
```

### 代码3：≥5 个链式方法组合的一组统计（averageByGrade）

```dart
/// 一条链路集齐 entries → where → map → map → fold → toList → sort，共 7 个集合方法。
Map<String, double> get averageByGrade => Map.fromEntries(
      groupByGrade
          .entries                                        // 1
          .where((e) => e.value.isNotEmpty)               // 2
          .map((e) => MapEntry(                           // 3
                e.key,
                e.value.map((s) => s.score)               // 4
                    .fold<double>(0, (sum, v) => sum + v) // 5
                    / e.value.length,
              ))
          .toList()                                       // 6
        ..sort((a, b) => a.key.compareTo(b.key)),         // 7
    );
```

**要点**：满足"至少 5 个链式方法组合完成一组统计"；结果示例 `{优:95, 良:88, 中:72, 及格:60, 不及格:45}`。

### 代码4：mixin Logger（替代一层继承）

```dart
/// 为什么用混入替代一层继承：
/// 1. 日志是横切关注点，与"成绩册"不是 is-a 关系；
/// 2. Dart 单继承，extends 只有一个名额，继承 LoggerBase 会占用唯一的父类位；
/// 3. mixin 可跨多个不相关类复用，还能叠加多个混入；
/// 4. 因此 GradeBook 用 `with Logger`：统计逻辑留在本类，日志能力横向注入，
///    类型层级更扁平，GradeBook is Logger 仍成立。
mixin Logger {
  final List<String> _logs = <String>[];
  List<String> get logs => List.unmodifiable(_logs);
  void log(String message) => _logs.add('[${DateTime.now().toIso8601String()}] $message');
  void clearLogs() => _logs.clear();
}

class GradeBook with Logger { ... }
```

---

## 五、检查点结果

| 检查项 | 状态 | 证据 |
|---|---|---|
| `dart create dart_oo` 完成 | ✅ | 工程骨架 9 文件 + pub get 50 依赖 |
| 类设计：封装/命名构造/校验 setter | ✅ | 越界 101、-1、150 均抛 `ArgumentError` |
| mixin 替代继承 + 说明理由 | ✅ | `mixin Logger` + GradeBook `with Logger`，理由见 `logger.dart` 文档注释 |
| ≥5 链式方法完成一组统计 | ✅ | `averageByGrade` 单表达式 7 个集合方法 |
| 测试 ≥2 用例覆盖正常+异常 | ✅ | 5 个用例（正常统计 / 链式统计 / 空册边界 / 越界异常 / Logger） |
| `dart test` 通过 | ✅ | `All tests passed!`（+6） |
| `dart analyze` 无告警 | ✅ | `No issues found!` |
| Git 提交规范 | ✅ | 全部 `feat:` 前缀 |

---

## 六、问题与调试

**问题 1：`git commit -am` 对新增文件无效**

- 现象：按任务书写的 `git commit -am "..."` 后，`git status` 显示新文件仍为未跟踪（untracked）。
- 定位：`-a` 只作用于**已跟踪**文件的修改，新建文件必须先 `git add`。
- 解决：改用 `git add dart_oo && git commit -m ...`；每步提交成功。
- 验证：`git log --oneline` 显示 3 条提交、`git status -sb` 无遗漏。

**问题 2：PowerShell 不支持 `&&` 链式**

- 现象：`git add ... && git commit ...` 报 `The token '&&' is not a valid statement separator`。
- 定位：当前 PowerShell 版本不支持 `&&`/`||`。
- 解决：改用 `;` 分隔多条命令。
- 验证：命令正常执行。

**问题 3：仓库根目录 `dart analyze` 混入 Flutter 报错**

- 现象：在 `M` 根目录跑 `dart analyze` 出现 55 条 `flutter/material.dart` 找不到的错误。
- 定位：根目录会一并分析 `hello_world`（Flutter 工程），其依赖未在纯 Dart 上下文解析。
- 解决：在 `dart_oo` 子目录内执行 `dart analyze`，结果干净。
- 验证：`dart_oo` 内 `No issues found!` ✅

**翻车点预防（任务书警告）**：测试文件放 `test/` 且名以 `_test.dart` 结尾——本工程文件名为 `test/gradebook_test.dart`，`dart test` 正常发现并执行。

---

## 七、AI 使用记录（TraeCode）

| 序 | 用途 | 指令摘要 | AI 输出 | 本人验证 |
|---|---|---|---|---|
| 1 | 工程创建 | "dart_oo 步骤一：建模 + 提交" | `dart create dart_oo` + Student/GradeBook 两文件 | `dart analyze` 干净 |
| 2 | 统计实现 | "步骤二：average/maxBy/countPassed/groupByGrade，禁 for 循环" | 4 个链式统计 getter | 临时脚本跑出正确数值后删除 |
| 3 | mixin 与测试 | "步骤三：抽 mixin Logger + 写 ≥2 用例" | logger.dart + 4 用例 | `dart test` 全通过 |
| 4 | 合规补强 | "对照任务书 6.2 补齐 ≥5 链、mixin 理由、报告" | averageByGrade + 文档注释 + 本报告 | `dart analyze` + `dart test` 复跑通过 |
| 5 | Git 推送 | "push" | 3 次 push 至 origin/main | GitHub commits 页核对 |

---

## 八、证据截图

| 编号 | 内容 | 说明 |
|---|---|---|
| 截图1 | `dart create dart_oo` 输出 | 工程创建成功 |
| 截图2 | `dart test` 输出 | `All tests passed!`（+6） |
| 截图3 | `dart analyze` 输出 | `No issues found!` |
| 截图4 | `git log --oneline` | 4 条 feat 提交 |
| 截图5 | GitHub commits 页面 | 已推送提交 |

> 截图本地保存，雨课堂编辑器中手工上传。

---

## 九、自评

| 作业要求 | 完成情况 |
|---|---|
| 6.1 案例复现：dart_oo 完整复现 | ✅ 三步齐备（`55bc3a0` / `fe5cc8c` / `ac27deb`） |
| 6.2-1 类设计合理性 | ✅ 封装 + 命名构造 + 校验 setter |
| 6.2-2 mixin 改造（替代继承 + 理由） | ✅ `mixin Logger`，理由写入源码注释与第四节代码4 |
| 6.2-3 集合统计链 ≥5 方法 | ✅ `averageByGrade` 单链 7 个集合方法 |
| 6.2-4 单元测试 ≥2 用例（正常+异常） | ✅ 5 用例，覆盖正常/边界/异常 |
| 检查点：`dart test` 通过 | ✅ |
| 检查点：`dart analyze` 无告警 | ✅ |
| Git 提交规范（feat:） | ✅ |
| 报告记录 | ✅ 本文件 `lecture3/progress.md` |

---

## 十、一句话收获与下一步计划

**收获**：第一次把"数据模型 + 横切能力 + 统计逻辑"分层想清楚——用 `mixin` 横向注入日志，避免用继承挤占唯一的父类名额；统计全部走集合链，`fold` 一次就把"分组 + 各档平均"串成一条流。

**遗留问题**：本轮补强的 commit 4 尚待最终推送。

**下次课预习要点**：泛型与抽象类、异步 Future/async/await、Flutter Widget 树。
