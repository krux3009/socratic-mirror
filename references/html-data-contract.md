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
    "parable": "第一段……\n\n第二段……\n\n最后一拍才点破 term 的那一段……",
    "term": "比较优势",
    "plainExplanation": "大白话解释，并逐一把『故事里的 X = 真实机制里的 Y』对上。"
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
  "meta": { "generatedBy": "socratic-mirror", "version": "1.0.0" }
}
```

### 字段说明
- `parable`：多段，段落之间用 `\n\n`。**核心术语第一次出现必须落在文本的最后 ~15%**（领域最后点破）。按**核心术语**计（如「慢启动」，不含释义/英文）；段落里用全角括号还是半角都行。
- `term`：规范名称，可带释义或英文（如 `慢启动 (slow start)`）。它和 `parable` 里的写法**不要求逐字一致**——模板各自渲染。
- `gapChecklist`：4–7 条，每条对象**只含 `id` + `prompt`**；`id` 唯一（`g1`、`g2`…）。solid/shaky/can't-yet 的自评是**学习者在页面上点选**的（存进 localStorage），**不要**写进 JSON。
- `flashcards`：5–8 张。
- `gradingPrompts`：把 `assets/grading-prompts.md` 里三段文本**整段**填进来（模板自包含，运行时不读 .md）。
- `lang`：`zh` 或 `en`，模板据此切 UI 文案。

## 二、字段 → 渲染到哪个阶段

| 阶段 | 用到的字段 |
|---|---|
| 1 · Parable 寓言 | `encode.parable` |
| 2 · Reveal 揭晓 | `encode.term`、`encode.plainExplanation` |
| 3 · Explain 费曼讲解 | 输入框 → 锁住 `feynman.modelSimpleExplanation`；复制按钮用 `gradingPrompts.simpleExplanation` |
| 4 · Gap-hunt 漏洞猎杀 | `feynman.gapChecklist`（每条 solid/shaky/can't-yet + 重讲框） |
| 5 · Analogy 打比方 | 输入框 → 锁住 `feynman.modelAnalogy`；复制按钮用 `gradingPrompts.analogy` |
| 6 · Recall 主动回忆 | `feynman.flashcards`（翻卡）+ `feynman.teachBackPrompt` 输入框；复制用 `gradingPrompts.teachBack` |

## 三、模板不变量（生成器不许破坏）

1. **唯一注入点**：`const TUTOR = /*__TUTOR_DATA__*/ null;`，全文件只此一处。
2. **完全自包含**：无 `<script src=...>`、无 `fetch(`、无 API key、无外部依赖（webfont 的 `<link>` 是渐进增强，可断网降级到系统字体）。
3. **reveal-gate**：任何 `model*` 标准答案，在 `canReveal(学习者输入)` 为真之前都保持隐藏。
4. **localStorage key = `sm:<slug>`**，按 slug 命名空间，避免多概念页互相覆盖。
