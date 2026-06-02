# HTML 数据契约（Data Contract）

> 生成器（SKILL.md 工作流）和模板（`assets/tutor-template.html`）通过这个契约解耦。
> 生成器只负责**填这个 JSON**；模板负责**渲染 + 交互**。两边都不许破坏这里的约定。

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
    "predictModel": "两个故事共享的『机制』，用大白话说清——但【先不点出 term 的正式名字】（名字留到 Reveal 阶段）。学习者在 Predict 阶段写完自己的猜测后才解锁，用来对照自己有没有抓到结构。",
    "term": "比较优势",
    "plainExplanation": "大白话解释，并把【两个故事】里的元素都逐一映射回真实机制（故事一的 X = …、故事二的 Y = …）。"
  },
  "feynman": {
    "modelSimpleExplanation": "讲给 12 岁小孩听、零术语的范例（锁住）。",
    "gapChecklist": [
      { "id": "g1", "prompt": "能不能解释：为什么一个国家什么都做得差，却仍能从贸易获益？" },
      { "id": "g2", "prompt": "不用『成本』这个词，说清楚这里的『机会成本』在干什么。" }
    ],
    "modelAnalogy": "一个强比方，并说出它在哪里会失效（锁住）。",
    "flashcards": [
      { "q": "决定贸易方向的是绝对优势还是比较优势？", "a": "比较优势——看相对机会成本，不是谁绝对更强。" }
    ],
    "teachBackPrompt": "一位外科医生同时也是全院打字最快的人。用你刚学的，解释病历该谁来打。"
  },
  "gradingPrompts": {
    "simpleExplanation": "……（见 assets/grading-prompts.md，整段拷进来）",
    "analogy": "……",
    "teachBack": "……"
  },
  "meta": { "generatedBy": "socratic-mirror", "version": "1.1.0" }
}
```

### 字段说明
- `parables`：**长度为 2 的数组**，每项 `{ domain, story }`。两个故事**共享同一台底层机器，但表面领域必须完全不同**（这正是『猜共性』阶段能成立的前提——见 `parable-method.md` 的"双寓言"一节）。每个 `story` 多段、段落间用 `\n\n`；**两个故事都要把核心术语藏到各自最后 ~15%**。`domain` 是该故事的表面取材（如「厨房」「码头」），显示成小标签，**不要**等于 `term`。
- `predictModel`：『猜共性』阶段的锁住答案——把两个故事**共享的机制**讲清楚，**但先不点出 `term` 的正式名字**（名字留到 Reveal）。学习者写完自己的猜测才解锁，用来自查有没有抓到结构而非表面。
- `term`：规范名称，可带释义或英文（如 `慢启动 (slow start)`）。它在 Reveal 阶段才正式出现；和 `parables` 里的写法**不要求逐字一致**——模板各自渲染。
- `gapChecklist`：4–7 条，每条对象**只含 `id` + `prompt`**；`id` 唯一（`g1`、`g2`…）。solid/shaky/can't-yet 的自评是**学习者在页面上点选**的（存进 localStorage），**不要**写进 JSON。
- `flashcards`：5–8 张。
- `gradingPrompts`：把 `assets/grading-prompts.md` 里三段文本**整段**填进来（模板自包含，运行时不读 .md）。
- `lang`：`zh` 或 `en`，模板据此切 UI 文案。

## 二、字段 → 渲染到哪个阶段

| # | 阶段 | 用到的字段 |
|---|---|---|
| 0 | Stories 双寓言 | `encode.parables[]`（两个故事，各带 `domain` 小标签） |
| 1 | Predict 猜共性 | 输入框 → 锁住 `encode.predictModel`（**无复制按钮**，纯自查；门槛同 `canReveal`） |
| 2 | Reveal 揭晓 | `encode.term`、`encode.plainExplanation`（把**两个**故事都映射回机制） |
| 3 | Explain 费曼讲解 | 输入框 → 锁住 `feynman.modelSimpleExplanation`；复制按钮用 `gradingPrompts.simpleExplanation` |
| 4 | Gap-hunt 漏洞猎杀 | `feynman.gapChecklist`（每条 solid/shaky/can't-yet + 重讲框） |
| 5 | Analogy 打比方 | 输入框 → 锁住 `feynman.modelAnalogy`；复制按钮用 `gradingPrompts.analogy` |
| 6 | Recall 主动回忆 | `feynman.flashcards`（翻卡）+ `feynman.teachBackPrompt` 输入框；复制用 `gradingPrompts.teachBack` |

## 三、模板不变量（生成器不许破坏）

1. **唯一注入点**：`const TUTOR = /*__TUTOR_DATA__*/ null;`，全文件只此一处。
2. **完全自包含**：无 `<script src=...>`、无 `fetch(`、无 API key、无外部依赖（webfont 的 `<link>` 是渐进增强，可断网降级到系统字体）。
3. **reveal-gate**：任何 `model*` 标准答案（含 `model-predict`），在 `canReveal(学习者输入)` 为真之前都保持隐藏。
4. **localStorage key = `sm:<slug>`**，按 slug 命名空间，避免多概念页互相覆盖。
5. **`parables` 必须 2 个、表面领域互异**；**`predictModel` 不得点出 `term`**（点名属于 Reveal 阶段，提前点破会废掉『猜共性』）。
6. **state 版本 `v:2`**：模板只认 `v===2` 的 localStorage（旧 `v:1` 存档自动作废重来，因阶段索引已变）。
