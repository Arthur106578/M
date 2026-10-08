# 进度报告2（第4周 · Dart语言基础一）

> 使用方式：在模板上作答，作答完成后将全文复制到雨课堂答题区（图片无法粘贴时在雨课堂编辑器中手工重新上传），并将同一内容存入自己仓库 `lecture2/progress.md`。

---

## 一、任务理解

**本次作业目标**：完成 dart_basics 基础语法合集工程，覆盖三步骤与 6.2 自主实践四任务。

- 步骤1：用 `dart create dart_basics` 创建纯 Dart 工程，查看 `bin/dart_basics.dart` 入口；
- 步骤2：在 `bin/` 下新建 types_demo / func_demo / flow_demo 三个示例文件，main 统一调用并 `dart run` 验证；
- 步骤3：TraeCode 对拍 5 道预测题（空安全 / 命名参数 / 整除）+ 1 道空安全改写；
- 6.2 自主实践任务 1-3：空安全改写、命名参数设计、控制流小程序。

**验收标准**：`dart run` 全部输出正确；空安全无编译告警；空安全改写通过；能口头解释 `??` 与 `!` 的区别；Git 提交规范（feat:/docs: 前缀）；报告记录完整。

---

## 二、环境与工具

| 项 | 值 |
|---|---|
| 操作系统 | Windows 11 |
| 编辑器 | TraeCode（基于 VS Code 内核，集成 AI 助手） |
| Dart SDK | 3.13.3 (stable) |
| Flutter SDK | 3.47.4（`C:\Users\HZL\dev\flutter`） |
| Java/JDK | 21 (Temurin) |
| 运行目标 | Windows 桌面（`dart run` 于 PowerShell） |
| AI 工具 | TraeCode 内置助手（GLM-5.2 模型） |
| Git | 2.55.0 |
| 仓库 | https://github.com/Arthur106578/M.git |

---

## 三、过程记录（时间线）

| 时间 | 步骤 | 操作 |
|---|---|---|
| 2026-10-08 | 准备 | 克隆 M 仓库到本地 `trae_projects\M` |
| 2026-10-08 | 步骤1 | 执行 `dart create dart_basics`，生成工程骨架（9 个文件 + 48 依赖） |
| 2026-10-08 | 步骤2 | 新建 types_demo / func_demo / flow_demo 三文件；修改 main 统一调用 |
| 2026-10-08 | 验证 | `dart run` 全部输出正确；`dart analyze` → No issues found |
| 2026-10-08 | 步骤3 | AI 对拍 Round 1：5 题 + 1 改写，发现 2 处 Python 习惯分歧 |
| 2026-10-08 | 6.2 任务1-3 | 新建 practice_demo.dart，单文件搞定空安全 / 命名参数 / 控制流 |
| 2026-10-08 | Git | 共 4 次 feat/docs 提交，全部推送至 origin/main |

---

## 四、关键代码

### 代码1：空安全四件套（types_demo.dart，AI 生成 + 本人验证）

```dart
String? maybe;                              // 1. ? 可空声明
buf.writeln('空安全 ?? : maybe=${maybe ?? "默认值"}');  // 2. ?? 空合并
maybe = '已赋值';
buf.writeln('空安全 ! : maybe!=$maybe');                // 3. ! 非空断言
late String lazy;                           // 4. late 延迟初始化
lazy = '延迟初始化完成';
```

**逐行解释**：
- L1 `String?` —— 声明可空类型，初始为 null
- L2 `?? "默认值"` —— maybe 为 null 时取右侧兜底，否则取 maybe 本身
- L4 `maybe!` —— 非空断言；此时已赋值，断言成立，安全解引用
- L5 `late String lazy` —— 延迟初始化，第一次访问前必须赋值

**验证**：`dart run` 输出 `maybe=null` / `maybe=默认值` / `maybe!=已赋值`，与预期一致 ✅

### 代码2：命名参数 + 箭头函数（practice_demo.dart，AI 生成 + 本人验证）

```dart
String report({
  required String title,    // 必填
  required String author,   // 必填
  int score = 0,            // 默认值
}) => '《$title》by $author, 得分=$score';
```

**逐行解释**：
- `{...}` —— 命名参数语法
- `required` —— 标记必填，缺失则编译错
- `int score = 0` —— 默认值，调用时可省略
- `=>` —— 箭头函数，等价于 `{ return ...; }`

**验证**：`dart run` 三种调用输出全部正确 ✅
```
《实验一》by 张三, 得分=0       // 仅必填
《实验二》by 李四, 得分=95      // + 一个可选
《实验三》by 王五, 得分=88      // 顺序无关
```

### 代码3：控制流扩展 gradeOf（practice_demo.dart，AI 生成 + 本人验证）

```dart
String gradeOf(dynamic x) {
  if (x is! int && x is! String) return '非法输入: 类型不支持';  // 类型校验
  final n = x is String ? int.tryParse(x) : x;                  // 字符串解析
  if (n == null) return '非法输入: 非数字';
  if (n < 0 || n > 100) return '非法分数: $n (应在 0-100)';      // 边界校验
  if (n == 100) return 'A+ (满分)';                              // 100 单独标注
  if (n == 0) return 'F (零分)';                                 // 0 单独标注
  if (n >= 90) return 'A';
  ...
}
```

**逐行解释**：
- 参数 `dynamic` —— 接受任意类型，便于演示非法输入
- `is! int && is! String` —— 既非 int 也非 String 直接拒绝
- `int.tryParse(x)` —— 字符串转 int，失败返回 null
- `n == 100` / `n == 0` —— 满分与零分单独标注
- `n < 0 || n > 100` —— 边界外返回"非法分数"

**验证**：`dart run` 输出 `100→A+`、`0→F(零分)`、`-5→非法分数`、`'abc'→非数字`、`'75'→C`，全部符合预期 ✅

---

## 五、检查点结果

| 检查项 | 状态 | 证据 |
|---|---|---|
| `dart run` 全部输出正确 | ✅ | 控制台 5 个 demo 全部输出，无报错 |
| 空安全无编译告警 | ✅ | `dart analyze` → `No issues found!` |
| 空安全改写练习通过 | ✅ | `String? name; print(name?.length ?? 0);` 输出 `0` |
| 能口头解释 `??` 与 `!` | ✅ | `??`=软兜底永不抛错；`!`=硬断言运行时抛 TypeError |
| Git 提交规范 | ✅ | 4 个提交均用 feat:/docs: 前缀 |

---

## 六、问题与调试

**问题 1：负数整除的语义误用**

- 现象：写 `print(-7 ~/ 2)` 时凭 Python 经验预测 `-4`（floor），实际 Dart 输出 `-3`。
- 定位：TraeCode 终端 `dart run` 看到实际输出 `-3`；查 Dart 文档发现 `~/` 是 truncating division（**向零截断**），不是 Python 的 floor。
- 解决：在 `docs/quiz-round-1.md` 标注此分歧，practice_demo.dart 注释补一句"`~/` 向零截断非 floor"。
- 验证：`dart run` 输出 -3，与文档一致 ✅

**问题 2：PowerShell profile 加载告警**

- 现象：每次 Shell 命令末尾红色提示"无法加载 powershell-profile-snapshot.ps1，禁止运行脚本"。
- 定位：错误来自 PowerShell 执行策略 Restricted，与我的命令本身无关。
- 解决：忽略该告警，确认实际命令输出正确即可，不影响 dart/git 操作。

---

## 七、AI 使用记录（TraeCode）

| 序 | 用途 | 指令摘要 | AI 输出 | 本人验证方式 |
|---|---|---|---|---|
| 1 | 工程创建 | "dart create dart_basics + commit" | 9 个工程文件 + pub get 48 依赖 | `dart run` 输出 "Hello world: 42!" |
| 2 | 示例代码 | "新建 types_demo/func_demo/flow_demo，main 统一调用" | 3 个 .dart + 修改入口 | `dart run` 三组 demo 全部输出 |
| 3 | 对拍出题 | "出 5 题：空安全/命名参数/整除" | 5 题 + 1 改写题 + 参考答案 | 逐题手写预测后对比，发现 2 处分歧 |
| 4 | 自主实践 | "6.2 任务1-3，简单一点" | 单文件 practice_demo.dart 搞定三任务 | `dart analyze` 无告警 + `dart run` 边界用例正确 |
| 5 | Git 推送 | "推送" | 4 次 push 至 origin/main | GitHub commits 页面在线核对 |

---

## 八、证据截图

| 编号 | 内容 | 说明 |
|---|---|---|
| 截图1 | `dart run` 全部输出 | 5 个 demo 全部正确输出 |
| 截图2 | `dart analyze` 输出 | "No issues found!" |
| 截图3 | PowerShell `git log --oneline` | 4 个 feat/docs 提交 |
| 截图4 | GitHub 仓库 commits 页面 | 已推送的 4 个提交 |

> 截图本地保存，雨课堂编辑器中手工上传。

---

## 九、自评

| 作业要求 | 完成情况 |
|---|---|
| 步骤1：dart create dart_basics | ✅ 完成（提交 99e28c3） |
| 步骤2：4 组示例 + main 调用 | ✅ 完成（提交 bf23e81） |
| 步骤3：TraeCode 对拍 5 题 + 改写 | ✅ 完成（提交 40d7983） |
| 6.2 任务1：空安全改写 | ✅ 完成（提交 d3fd09b） |
| 6.2 任务2：命名参数设计 | ✅ 完成（同上） |
| 6.2 任务3：控制流扩展 | ✅ 完成（同上） |
| 6.2 任务4：TraeCode 对拍 | ✅ 完成（同 40d7983） |
| 检查点：dart run 输出正确 | ✅ |
| 检查点：空安全无编译告警 | ✅ |
| Git 提交规范（feat:/docs:） | ✅ 4 个提交全部规范 |
| 报告记录（progress.md） | ✅ 本文件 |

---

## 十、一句话收获与下一步计划

**收获**：Dart 的空安全四件套（`?` / `??` / `!` / `late`）+ 命名参数 + 整除语义，最大的坑是 Python 习惯导致 `~/` 与 `%` 在负数场景下记错——对拍把语义差异显性化比读文档更牢。

**遗留问题**：
- PowerShell profile 加载告警未根治（不影响功能）；
- Flutter 后续章节的可视化截图能力待补。

**下次课预习要点**：
- Dart 集合（List / Set / Map）与泛型；
- 异步（Future / async / await）；
- Flutter Widget 树与 StatelessWidget / StatefulWidget 区别。
