# Socratic Mirror

Turn any concept into a self-contained **interactive HTML study page**: **two parables** from unrelated domains teach one idea indirectly, you **guess the mechanism they secretly share** before the term is ever named, then the **Feynman technique** makes you explain it back, hunt your own gaps, forge an analogy, and self-test — with every model answer **locked until you write your own first**.

> Like Socrates, it doesn't hand you the answer — it reflects your own understanding back at you.

*A Claude Code / [openclawmp](https://openclawmp.stepfun.com) skill. The skill ships Chinese-first for the openclawmp marketplace, but the generated study pages are **language-adaptive** — a Chinese concept yields a Chinese page, an English concept an English one. 中文说明见 [README.zh-CN.md](README.zh-CN.md).*

## Why

"AI explains, you nod" is the most common **illusion of competence** — recognizing ≠ understanding. Socratic Mirror writes *produce-before-you-see-the-answer* into the code: answers stay gated until you've written your own, so you actually generate an explanation and your gaps surface. Grounded in three well-supported learning principles: **retrieval practice** (recall beats rereading), **self-explanation** (meta-analysis effect size g = 0.55), and **analogy as the compression of real understanding**.

## How it works — seven stages

**Two stories** (same machine, unrelated surfaces) → **Predict** (guess the shared mechanism *before* it's named — this is why two stories beat one: you're forced to strip the surface and grab the structure) → **Reveal** (the term, finally named; both stories mapped back) → **Explain** (in your own words, to a 12-year-old) → **Gap-hunt** (self-mark each tricky spot; anything shaky you must go back and re-explain) → **Analogy** (forge one, find where it breaks) → **Active recall + teach-back challenge**.

> Why two parables? One story binds the concept to its surface details ("comparative advantage is *the chef story*"). Two structurally-identical stories plus a "what do they share?" step force the learner to abstract the transferable structure — the classic analogical-transfer lever.

Every model answer stays locked until your own attempt clears a "real attempt" gate. Progress auto-saves in the browser. A **"copy grading prompt"** button hands your attempt + a grading instruction to any AI chat for instant feedback — diagnosis only; it won't rewrite the answer for you.

## Features

- **Two-parable contrast + Predict** — guess the shared mechanism across two unrelated stories before the term is named, so you abstract structure instead of memorizing surface.
- **Answers gated** — produce before reveal, enforced in code (not the honor system).
- **Self-contained** — one HTML file, works offline, no API key, no dependencies.
- **Keyboard & screen-reader friendly** — `←`/`→` walk the stages, the stepper is a real ARIA tablist, focus follows the active panel, cards flip with `Enter`/`Space`.
- **Print to PDF** — `⌘`/`Ctrl`+`P` expands every stage and model answer into a clean, archivable worked sheet.
- **Language-adaptive** — the study page follows the concept's language.
- **Resumable** — per-concept progress in `localStorage`.

## Install

```bash
openclawmp install skill/socratic-mirror --target-dir ./skills
```

Or use it as a Claude Code skill — drop the folder into your skills directory.

## Usage

Trigger with `/learn <concept>` (also `/feynman`, `/parable`, or natural language like *"teach me X" / "help me really understand X"*). It asks at most 1–2 questions only if the concept is too broad, then writes `./<concept>.html` — open it in a browser and work through the seven stages. Answers stay locked until you write your own.

## Repository layout

| Path | What |
|---|---|
| `SKILL.md` | The skill's instructions + 7-step workflow (written in Chinese — it targets the openclawmp audience) |
| `references/` | The pedagogy + authoring rules the skill loads at runtime (Feynman method, parable method, anti-AI-slop, the HTML data contract) |
| `assets/tutor-template.html` | The single-file interactive study page (vanilla JS, warm-graphite theme) |
| `assets/grading-prompts.md` | The paste-to-AI grading prompts embedded into each page |
| `.metadata.json` | openclawmp asset manifest |

## Design note: produce before reveal

The parable does the **encoding** (gets the idea into your head); Feynman does the **retrieval** (gets it back out). Between them sits a lock — you don't see the model answer until you've written your own. That lock is the whole point: it stops you at "looks familiar" and pushes you to "I can actually explain it."

## License

MIT © Li Xuan ([krux3009](https://github.com/krux3009))
