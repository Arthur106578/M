# AI 对拍练习 Round 1

> 范围：空安全 · 命名参数 · 整除（~/  ~/  %）
> 流程：AI 出题 → 学生手写预测 → AI 给参考答案与讲解 → 逐题对拍 → 分歧记入进度报告

---

## Q1（空安全 · `??` 空合并运算符）

```dart
String? name;
print(name ?? '默认');
name = 'Alice';
print(name ?? '默认');
```

**学生预测**
```
默认
Alice
```

**参考答案 + 讲解**
```
默认
Alice
```
- `??` 是空合并运算符：左侧为 `null` 时返回右侧，否则返回左侧。
- 第一行 `name` 未赋值，为 `null` → 输出 `'默认'`。
- 第二次赋值后 `name` 非 `null` → 直接返回 `name` 本身。

**对拍结果** ✅ 一致

---

## Q2（空安全 · `!` 非空断言）

```dart
String? maybe = 'Hello';
print(maybe!.length);
maybe = null;
try {
  print(maybe!.length);
} catch (e) {
  print('抛错: $e');
}
```

**学生预测**
```
5
抛错: Null check operator used on a null value
```

**参考答案 + 讲解**
```
5
抛错: Null check operator used on a null value
```
- `!` 是非空断言："我保证这里不是 `null`"，编译器放行，运行时若为 `null` 则抛 `TypeError`。
- 第一次 `maybe = 'Hello'` → `length` 为 5。
- 第二次 `maybe = null` 后强解引用 → 抛错被 `try/catch` 捕获。

**对拍结果** ✅ 一致

---

## Q3（命名参数 · `required` vs 默认值）

```dart
String greet({required String name, String prefix = 'Hi'}) => '$prefix, $name!';
print(greet(name: 'Bob'));
print(greet(name: 'Cara', prefix: 'Hey'));
// print(greet());  // 这行会怎样？
```

**学生预测**
```
Hi, Bob!
Hey, Cara!
// 第三行：编译错误 - 缺少必填参数 name
```

**参考答案 + 讲解**
```
Hi, Bob!
Hey, Cara!
// 第三行：Compile error - The named parameter 'name' is required.
```
- `required` 表示调用时必须传值，缺失则编译期报错。
- `=` 提供默认值，调用时可省略 → 用默认值填充。
- 因此 `greet(name: 'Bob')` 用默认 `prefix='Hi'`；`greet(name: 'Cara', prefix: 'Hey')` 全自定义；`greet()` 因缺 `name` 编译失败。

**对拍结果** ✅ 一致

---

## Q4（命名参数 · 顺序无关）

```dart
void configure({int port = 8080, bool debug = false}) {
  print('port=$port, debug=$debug');
}
configure(debug: true);
configure(port: 3000, debug: true);
configure(debug: true, port: 3000);
```

**学生预测**
```
port=8080, debug=true
port=3000, debug=true
port=3000, debug=true
```

**参考答案 + 讲解**
```
port=8080, debug=true
port=3000, debug=true
port=3000, debug=true
```
- 命名参数通过参数名匹配，与传入顺序无关。
- 第 3 行 `debug: true` 用默认 `port=8080`。
- 第 4、5 行仅顺序不同，结果完全一致。

**对拍结果** ✅ 一致

---

## Q5（整除 · `~/` 与 `/` 与 `%`）

```dart
print(7 / 2);
print(7 ~/ 2);
print(-7 ~/ 2);
print(7 % 2);
print(-7 % 2);
```

**学生预测**（受 Python 习惯影响）
```
3.5
3
-4      ← 误以为向下取整（floor）
1
1       ← 误以为与 Python 一致恒为正
```

**参考答案 + 讲解**
```
3.5
3
-3
1
-1
```
- `/` 在 Dart 中**总是返回 `double`**，即使整除也带 `.0`（`7/2 → 3.5`）。
- `~/` 是**截断除法**（truncating division），等价于 `(a/b).truncate()` ——**向零取整**而非向下取整。
  - `7 ~/ 2` → `3.5` 截断 → `3`
  - `-7 ~/ 2` → `-3.5` 截断向零 → `-3`（不是 `-4`！）
- `%` 取模在 Dart 中**结果符号跟随被除数**（与 C/Java 一致，与 Python 不同）：
  - `7 % 2 = 1`
  - `-7 % 2 = -1`（不是 `+1`）

**对拍结果** ⚠️ 两处分歧：
- `-7 ~/ 2` 学生答 `-4`，参考答 `-3` —— `~/` 是向零取整而非 floor
- `-7 % 2` 学生答 `+1`，参考答 `-1` —— Dart `%` 符号跟随被除数

---

## 改写练习（空安全）

**题目**：将下列非空安全代码改写为空安全等价，要求 `maybe` 为 `null` 时不崩溃并输出 `0`：

```dart
String maybe;              // 非 null-safe 风格
print(maybe.length);       // 编译错误
```

**学生改写**
```dart
String? maybe;                       // 1. 类型加 ?
print(maybe?.length ?? 0);           // 2. ?. 安全调用 + ?? 兜底
```

**参考答案 + 讲解**
```dart
String? maybe;
print(maybe?.length ?? 0);           // 输出 0
```
- `String?` 声明可空类型。
- `?.` 安全调用：左侧为 `null` 时整个表达式为 `null`，不抛错。
- `?? 0` 兜底：`null` 时取 `0`。
- 等价的"非空断言"写法 `maybe!.length` 在 `null` 时会抛错，不符合"不崩溃"要求，不可用。

**对拍结果** ✅ 一致，改写练习通过

---

## 检查点自测

| 检查项 | 状态 | 证据 |
|---|---|---|
| `dart run` 全部输出正确且无编译告警 | ✅ | 见下方运行结果 |
| `dart analyze` 无 lint 告警 | ✅ | `No issues found` |
| 空安全改写练习通过 | ✅ | `maybe?.length ?? 0` 输出 `0` |
| 能口头解释 `??` 与 `!` 的区别 | ✅ | 见下 |

### `??` 与 `!` 的区别（口头解释）

| 运算符 | 名称 | 行为 | 失败模式 |
|---|---|---|---|
| `??` | 空合并 | 左 `null` 则取右；左非 `null` 取左 | 永不抛错，是"软兜底" |
| `!`  | 非空断言 | 强制视为非空，编译器放行 | 运行时若为 `null` 抛 `TypeError` |

> 一句话：`??` 是"如果是空就用备胎"；`!` 是"我赌它不是空，错了就崩"。

### 运行验证

```
$ dart run
=== 默认模板 ===
Hello world: 42!
=== 变量 / 插值 / 空安全四件套 ===
变量: name=Alice (var), age=20 (final), pi=3.14159 (const)
插值: ALICE明年21岁, 圆周率≈3.14159
空安全 ? : maybe=null
空安全 ?? : maybe=默认值
空安全 ! : maybe!=已赋值
空安全 late: 延迟初始化完成
=== 命名参数 / 箭头函数 ===
...
=== 分级器 / for-in 循环 ===
...
```

```
$ dart analyze
No issues found!
```

---

## 对拍分歧汇总

| 题号 | 主题 | 学生预测 | 参考答案 | 分歧 | 根因 |
|---|---|---|---|---|---|
| Q1 | `??` | `默认/Alice` | 同 | ✅ 无 | — |
| Q2 | `!` | `5/抛错` | 同 | ✅ 无 | — |
| Q3 | `required`+默认 | 同 | 同 | ✅ 无 | — |
| Q4 | 顺序无关 | 同 | 同 | ✅ 无 | — |
| Q5a | `-7 ~/ 2` | `-4` | `-3` | ⚠️ 有 | 误用 Python floor 语义，Dart `~/` 向零截断 |
| Q5b | `-7 % 2` | `+1` | `-1` | ⚠️ 有 | Dart `%` 符号跟随被除数，非 Python 风格 |

**Round 1 错题数**：1 题（Q5 整除），含 2 处子分歧
**反思**：Python 习惯是最大陷阱，Dart 的 `~/` 与 `%` 与 C/Java 一致而非 Python。
