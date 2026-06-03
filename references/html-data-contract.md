# HTML 数据契约（Data Contract）

> 生成器（SKILL.md 工作流）和模板（`assets/tutor-template.html`）通过这个契约解耦。
> 生成器只负责**填这个 JSON**；模板负责**渲染 + 交互**。两边都不许破坏这里的约定。
>
> **v1.3 起**：除「读」的两关（Stories、Reveal）和翻卡（flashcards）外，**所有交互都是选择题**。页面没有任何自由文本输入框；每个互动阶段 = 一组即时反馈的 MCQ。

## 一、要填的 JSON 结构

把下面这个对象填满，替换模板里唯一的注入点 `/*__TUTOR_DATA__*/ null`。
因为合法 JSON 就是合法 JS 字面量，引号/换行不会出问题——直接输出 JSON。

```json
{
  "concept": "比较优势",
  "slug": "comparative-advantage",
  "domain": "经济学",
  "difficulty": "grad",
  "lang": "zh",
  "encode": {
    "parables": [
      { "domain": "厨房", "story": "故事一：表面取材厨房……多段，段落间用 \\n\\n……最后一拍前都不点破 term。" },
      { "domain": "码头", "story": "故事二：表面取材码头（与故事一完全不同的领域），却演同一台机器……同样到最后才点破。" }
    ],
    "predictChecks": [
      {
        "id": "p1",
        "stem": "两个故事真正共享的那台『机器』是什么？（先别想正式名字，认结构）",
        "options": [
          "样样更强的人，把某件事让给更弱的人，因为他做那件事放弃的太多",
          "厉害的人就该把所有事都自己做",
          "谁便宜谁来做",
          "熟能生巧，多练就快"
        ],
        "correct": 0,
        "whyCorrect": "对——核心是『放弃了什么』决定分工，不是谁绝对更强。",
        "whyWrong": [null,
          "两个故事恰恰相反：强者让出了活。",
          "故事里没有价格/便宜这一层。",
          "熟练度不是这两个故事的共同骨架。"]
      }
    ],
    "term": "比较优势",
    "plainExplanation": "大白话解释，并把【两个故事】里的元素都逐一映射回真实机制（故事一的 X = …、故事二的 Y = …）。"
  },
  "feynman": {
    "comprehensionChecks": [ { "id": "c1", "stem": "…承重关系问题…", "options": ["…"], "correct": 0, "whyCorrect": "…", "whyWrong": [null, "…"] } ],
    "gapChecks":          [ { "id": "g1", "stem": "…最容易翻车/搞反的点…", "options": ["…"], "correct": 0, "whyCorrect": "…", "whyWrong": [null, "…"] } ],
    "analogyChecks":      [ { "id": "a1", "stem": "哪个比方抓住了本质？", "options": ["…"], "correct": 0, "whyCorrect": "…", "whyWrong": [null, "…"] } ],
    "transferChecks":     [ { "id": "t1", "stem": "把概念用到一个全新场景……该怎么做？", "options": ["…"], "correct": 0, "whyCorrect": "…", "whyWrong": [null, "…"] } ],
    "flashcards": [
      { "q": "决定贸易方向的是绝对优势还是比较优势？", "a": "比较优势——看相对机会成本，不是谁绝对更强。" }
    ]
  },
  "meta": { "generatedBy": "socratic-mirror", "version": "1.3.0" }
}
```

### 统一的 MCQ 题目形状

`predictChecks` / `comprehensionChecks` / `gapChecks` / `analogyChecks` / `transferChecks` 五组**共用同一形状**，每项：

- `id`：**全局唯一**字符串，用前缀区分组别：`p1 p2`（predict）、`c1 c2`（comprehension）、`g1 g2`（gaps）、`a1`（analogy）、`t1`（transfer）。模板用一个扁平的 `state.mcqAnswers`（按 id 存）覆盖全部题目——前缀唯一才不会串台；重排/重生成题目也不会把旧答案错配到新题。
- `stem`：题干，考**承重关系 / 应用**，**不要考定义、术语认得**。
- `options`：3–5 个（推荐 4），**模板不打乱**（顺序即 `correct` 下标所指、打印稿也要稳定）。
- `correct`：正确项下标。
- `whyCorrect`：一句**针对该概念**的话，说明为什么对（不是"答对了！"）。
- `whyWrong`：与 `options` 等长的数组，正确项那格填 `null`，每个干扰项填一句**点名该误区**的话——这是错选时的教学载荷。**可省**（某格缺失/为空时模板回退到通用提示串），但能写就写。

### 各字段说明

- `parables`：**长度为 2 的数组**，每项 `{ domain, story }`。两个故事**共享同一台底层机器，但表面领域必须完全不同**（这是『猜共性』阶段成立的前提——见 `parable-method.md` 的"双寓言"一节）。每个 `story` 多段、段落间用 `\n\n`；**两个故事都把核心术语藏到各自最后 ~15%**。`domain` 是该故事的表面取材（如「厨房」「码头」），显示成小标签，**不要**等于 `term`。
- `predictChecks`：**Reveal 之前**的选择题，让学习者从选项里**认出两个故事共享的机制**。⚠ **选项与题干绝不能点出 `term` 的正式名字**（点名属于 Reveal；提前点破就废掉这一步）。正确项 = 共享机制的大白话描述；干扰项 = 只抓表面话题 / 抓错机制。
- `term`：规范名称，可带释义或英文（如 `慢启动 (slow start)`）。Reveal 阶段才正式出现；和 `parables` 里写法**不要求逐字一致**。
- `plainExplanation`：点破后的大白话解释，把**两个**故事的元素都映射回真实机制。
- `comprehensionChecks`：Reveal 之后的理解自测，3–5 题，考承重关系。
- `gapChecks`：这个概念**最容易被搞反 / 被术语糊弄过去**的点，做成 3–5 题（题源见 `concept-prep.md` §二的四把尺：反直觉一步 / 符号方向 / 术语糊弄区 / 边界条件）。
- `analogyChecks`：给几个候选比方，让学习者**选出真正同构的那个**；干扰项是"表面像、骨子里错"的比方，`whyWrong` 点明它在哪儿崩、`whyCorrect` 点明对的在哪儿会失效。1–3 题。
- `transferChecks`：**迁移题**——给一个全新场景，让学习者选出正确的**应用**（不是复述定义）。干扰项里要埋"绝对优势陷阱"之类的典型误用。1–3 题。
- `flashcards`：5–8 张，翻卡主动回忆，考**承重关系**不考定义。**这是页面上唯一保留的非选择题互动**（翻面 + got/again 自评，不是自由文本）。
- `lang`：`zh` 或 `en`，模板据此切 UI 文案。

## 二、字段 → 渲染到哪个阶段

| # | 阶段 | 用到的字段 |
|---|---|---|
| 0 | Stories 双寓言 | `encode.parables[]`（读，两个故事各带 `domain` 小标签） |
| 1 | Predict 猜共性 | `encode.predictChecks`（MCQ，**不得点名 term**；门槛＝全部答完） |
| 2 | Reveal 揭晓 | `encode.term`、`encode.plainExplanation`（读，把两个故事映射回机制） |
| 3 | Check 理解自测 | `feynman.comprehensionChecks`（MCQ） |
| 4 | Gaps 查漏洞 | `feynman.gapChecks`（MCQ，探常见误区） |
| 5 | Analogy 辨比方 | `feynman.analogyChecks`（MCQ，选同构比方） |
| 6 | Recall 回忆 | `feynman.flashcards`（翻卡）+ `feynman.transferChecks`（迁移 MCQ，门槛在「完成」按钮上） |

> 五个 MCQ 阶段全部：点选即时反馈（对/错 + 一句『为什么』）、**点一下就锁定**（先承诺、再看理由）、门槛 = **全部答完不是全对**。

## 三、模板不变量（生成器不许破坏）

1. **唯一注入点**：`const TUTOR = /*__TUTOR_DATA__*/ null;`，全文件只此一处。
2. **完全自包含**：无 `<script src=...>`、无 `fetch(`、无 API key、无外部依赖（webfont 的 `<link>` 是渐进增强，可断网降级到系统字体）。
3. **`parables` 必须 2 个、表面领域互异**；**`predictChecks` 的题干/选项不得点出 `term`**（点名属于 Reveal，提前点破废掉『猜共性』）。
4. **localStorage key = `sm:<slug>`**，按 slug 命名空间，避免多概念页互相覆盖。
5. **MCQ 题目 `id` 全局唯一**（跨五组），因为模板用一个扁平 `mcqAnswers` 映射存全部答案。
6. **state 版本 `v:4`**：模板只认 `v===4` 的 localStorage（旧 `v:3`/`v:2`/`v:1` 自动作废重来——全部互动改成选择题，state 形状已变）。
7. **选择题门槛 = 全部答完，不是全对**：即时『为什么』在错选时已把误区讲掉；按全对放行会卡死刚读完正确解释的学习者、并诱导盲目轮选。
