# Socratic Mirror

Turn any concept into a self-contained **interactive HTML study page**: **two parables** from unrelated domains teach one idea indirectly, you **pick the mechanism they secretly share** before the term is ever named, then a staged set of **instant-feedback multiple-choice questions** walks you from comprehension → common gaps → analogy discrimination → transfer, capped with **flashcards** for active recall. Every question locks on your first click and tells you right/wrong + *why* on the spot.

> Like Socrates, it doesn't hand you the answer — it reflects your own understanding back at you.

*A Claude Code / [openclawmp](https://openclawmp.stepfun.com) skill. The skill ships Chinese-first for the openclawmp marketplace, but the generated study pages are **language-adaptive** — a Chinese concept yields a Chinese page, an English concept an English one. 中文说明见 [README.zh-CN.md](README.zh-CN.md).*

## Why

"AI explains, you nod" is the most common **illusion of competence** — recognizing ≠ understanding. Re-reading quietly reinforces that illusion; **forced choice with immediate correction** breaks it. Socratic Mirror makes every interactive stage a multiple-choice question whose distractors are built from the *real* misconceptions for that concept — so a wrong pick is caught and explained the instant you make it, and you can't advance a stage until you've answered every question in it. Grounded in well-supported learning principles: **analogical transfer** (two isomorphic stories make you abstract structure, not surface), the **testing effect with corrective feedback** (graded retrieval beats rereading), and **active recall** (the flashcards).

> Note: this version has **no free-text input** — it's recognition-with-feedback by design. It deliberately does *not* claim the self-explanation effect (which requires the learner to produce a long explanation).

## How it works — seven stages

**Two stories** (same machine, unrelated surfaces) → **Predict** (pick the shared mechanism *before* it's named — two stories beat one because you're forced to strip the surface and grab the structure) → **Reveal** (the term, finally named; both stories mapped back) → **Check** (comprehension MCQs) → **Gaps** (MCQs probing where people most often get it backwards) → **Analogy** (pick the analogy that's truly isomorphic; the feedback shows where the wrong ones break and where the right one has edges) → **Active recall** (flashcards) **+ Transfer** (apply the concept to a brand-new scenario).

Every MCQ gives instant per-question feedback, locks on first answer (commit, then see the rationale), and gates the stage on **all answered — not all correct** (the *why* already teaches a wrong pick). Progress auto-saves in the browser.

> Why two parables? One story binds the concept to its surface details ("comparative advantage is *the chef story*"). Two structurally-identical stories plus a "what do they share?" question force the learner to abstract the transferable structure — the classic analogical-transfer lever.

## Features

- **Two-parable contrast + Predict** — identify the shared mechanism across two unrelated stories before the term is named, so you abstract structure instead of memorizing surface.
- **All-MCQ, instant feedback** — every interactive stage is multiple-choice; each wrong pick names the misconception on the spot. Distractors are concept-specific, not throwaway.
- **Stage gates** — you must answer every question in a stage to move on.
- **Self-contained** — one HTML file, works offline, no API key, no dependencies.
- **Keyboard & screen-reader friendly** — `←`/`→` walk the stages, the stepper is a real ARIA tablist, options are an ARIA radiogroup, cards flip with `Enter`/`Space`.
- **Print to PDF** — `⌘`/`Ctrl`+`P` expands every stage (your answers + the correct one + the rationale) into a clean, archivable worked sheet.
- **Language-adaptive** — the study page follows the concept's language.
- **Resumable** — per-concept progress in `localStorage`.

## Install

```bash
openclawmp install skill/socratic-mirror --target-dir ./skills
```

Or use it as a Claude Code skill — drop the folder into your skills directory.

## Usage

Trigger with `/learn <concept>` (also `/feynman`, `/parable`, or natural language like *"teach me X" / "help me really understand X"*). It asks at most 1–2 questions only if the concept is too broad, then writes `./<concept>.html` — open it in a browser and work through the seven stages.

## Repository layout

| Path | What |
|---|---|
| `SKILL.md` | The skill's instructions + 7-step workflow (written in Chinese — it targets the openclawmp audience) |
| `references/` | The pedagogy + authoring rules the skill loads at runtime (Feynman method as a question-picking lens, parable method, anti-AI-slop, the HTML data contract) |
| `assets/tutor-template.html` | The single-file interactive study page (vanilla JS, warm-graphite theme) |
| `.metadata.json` | openclawmp asset manifest |

## Design note: recognition-first, instant correction

The two parables do the **encoding** (get the idea in via structure, not surface); the staged MCQs do the **diagnosis** (catch where you'd actually trip and fix it on the spot). The Feynman four-step is still here — but as the *lens for choosing what to test* (explain-simply → comprehension, find-gaps → gaps, analogize → analogy, plus transfer), not as a free-text exercise. The discipline that replaces the old write-first lock: you answer every question, you commit before you see the rationale, and wrong answers are taught, not just marked.

## License

MIT © Li Xuan ([krux3009](https://github.com/krux3009))
