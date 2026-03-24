---
name: research-papers
description: Use when user asks to research a topic, paper, or idea — finds relevant sources, uses Claude Code or Codex CLI to deep-decode each into Obsidian 10_SOURCES/ notes using Literature Template + Feynman + Technical format. Triggers on "Research: X", "Find papers on X", "Go deep on X", "I want to understand X".
---

# Research Papers: Deep Decode Skill

**Goal:** Produce source notes where reading the note is equivalent to deeply understanding the source — not just knowing its facts, but thinking with its ideas, seeing its failure modes, and generating extensions from it.

**Standard:** Every note must read like a conversation with the author, not a reference sheet.

**IMPORTANT:** This skill uses CLI (Claude Code/Codex) — NO API credits. User's subscription is used.

**RELATED SKILL:** Use `zettelkasten` after notes are written to convert to atomic zettels.

---

## Quick Reference

| Step | Action |
|------|--------|
| 1. Scope | Decompose topic into 3-5 research questions |
| 2. Find | Search for sources via web/arxiv |
| 3. Dedup | Check arxiv IDs in 10_SOURCES/ filenames |
| 4. Choose CLI | Ask user or recommend Claude Code vs Codex |
| 5. Define Exhaustiveness | Set quality bar: foundation, solid, comprehensive, or definitive |
| 6. Run CLI Agent | exec Claude Code or Codex with research prompt |
| 7. Review & Gap-Fill | Validate completeness; run follow-up if needed |
| 8. Archive Duplicates | Remove old versions; keep only current best version |

---

## CLI Selection: Claude Code vs Codex

**Ask the user which to use, or recommend based on task:**

| CLI | Best For | Command |
|-----|----------|---------|
| **Claude Code** | General research, writing, deep reading | `claude --dangerously-bypass-approvals "prompt"` |
| **Codex** | Code-heavy research, repo analysis | `codex --dangerously-bypass-approvals-and-sandbox "prompt"` |

**Recommendation Logic:**
- Code/repo research → Codex
- Paper/blog deep reading → Claude Code
- Unclear → Ask user

---

## Step 0: Define Exhaustiveness Level (Before Running)

Decide what "complete" means for this topic:

| Level | Definition | When to Use | Note Length |
|-------|-----------|-------------|------------|
| **Foundation** | Main ideas + basic mechanics. Not complete, but enough to understand the core. | Quick overview, filtering sources | 8-12K |
| **Solid** | Complete coverage of mechanisms, design choices, failure modes. | Standard research task | 12-18K |
| **Comprehensive** | Everything solid + examples, code snippets, benchmarks, advanced topics. | In-depth learning | 18-30K |
| **Definitive** | Comprehensive + original insights, novel analysis, synthesis. | Writing papers, teaching | 25-40K+ |

---

## Step 1: Scope

Decompose topic into 3-5 research questions. Find sources:

```
web_search → arxiv papers, blogs, repos
```

Target: arxiv papers, Lilian Weng / Colah blogs, GitHub repos, Stanford/MIT lectures.

---

## Step 2: Dedup

Check if ID in any `10_SOURCES/` filename:
```bash
ls ".../Brain/10_SOURCES/" | grep "{arxiv-id}"
```
Skip if found.

---

## Step 3: Run CLI Agent

**USE CLI — NOT API. No API credits consumed.**

### For Claude Code:
```bash
claude --dangerously-bypass-approvals "Research: {topic}. Deep-decode sources into Obsidian 10_SOURCES/.

LITERATURE TEMPLATE (USE THIS HEADER):
---
Created: {{date}} {{time}}
Source: {URL}
Tags: [[{topic}]] [[{source-type}]]
Status: #baby

## References

1. [Title](URL)

# Notes
---

SOURCES:
{list of 3-5 sources with URLs}

STANDARD: Feynman + Technical merged
- Weave simple explanations + technical detail
- Develop analogies with concrete scenarios + counterfactuals
- Integrate critical analysis
- Raise questions naturally
- Cover 8 components: author intent, design space, failures, ideas, etc.

NAMING:
- arxiv: {ID} - {Short Title}.md
- Blog: {Author} - {Title}.md

Write to: /Users/jnk789/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain/10_SOURCES/

Begin."
```

### For Codex:
```bash
codex --dangerously-bypass-approvals-and-sandbox "Research: {topic}. Deep-decode sources into Obsidian 10_SOURCES/.

LITERATURE TEMPLATE (USE THIS HEADER):
---
Created: {{date}} {{time}}
Source: {URL}
Tags: [[{topic}]] [[{source-type}]]
Status: #baby

## References

1. [Title](URL)

# Notes
---

SOURCES:
{list of 3-5 sources with URLs}

STANDARD: Feynman + Technical merged
- Weave simple explanations + technical detail
- Develop analogies with counterfactuals
- Integrate critical analysis
- Cover 8 components

Write to: /Users/jnk789/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain/10_SOURCES/

Begin."
```

---

## Step 4: Monitor & Review

After CLI finishes:
1. Verify notes written to `10_SOURCES/`
2. Check quality against checklist
3. Document gaps if any

### Quality Checklist

- [ ] All 8 components present
- [ ] Analogies fully developed
- [ ] Counterfactuals for every major component
- [ ] Opinions argued with reasoning
- [ ] Practical examples (code, numbers, failure cases)

---

## Step 5: Archive & Cleanup

- Remove duplicate/old versions
- Document gaps in 00_INBOX/

---

## Naming Convention

| Source | Pattern | Example |
|--------|---------|---------|
| arxiv | `{ID} - {Title}.md` | `1707.06347 - PPO Algorithms.md` |
| Blog | `{Author} - {Title}.md` | `Weng - RLHF Reward Hacking.md` |
| GitHub | `{owner}-{repo} - {Topic}.md` | `openai-baselines - PPO.md` |

---

## The Deep Decode Standard

### What "deep decode" means

NOT: "Paper proposes X. Achieves Y on benchmark Z."

BUT: A note where reader can:
- Understand mechanism simply + full technical detail
- Argue author's design choices
- Predict failure modes from first principles
- Generate novel ideas extending the work
- Feel like talking with the author

---

## The 8 Components

1. **Author's Intent** — What problem were they solving?
2. **Decision Archaeology** — What alternatives did they reject?
3. **Assumption Stress-Testing** — What assumptions are load-bearing?
4. **Failure Mode Prediction** — How does it break?
5. **Design Space Mapping** — Where does this fit?
6. **Reasoning Pattern** — Theory-first or empirical?
7. **Critical Reasoning** — Do you agree? Why?
8. **Idea Generation** — What extensions/fixes/applications?

---

## The 3 Prose Rules

### Rule 1: Analogies Developed
Not "clipping like a speed limiter" — but fully developed scenario → mechanism → where it breaks.

### Rule 2: Counterfactuals
Every component needs: "what breaks if you remove/change this?"

### Rule 3: Opinions Argued
Not "PPO is overused" — but position → reasoning → acknowledgment → recommendation.

---

## What NOT To Do

- ❌ Use API/sessions_spawn — always use CLI
- ❌ Skip Literature Template header
- ❌ Produce summaries
- ❌ Skip analogies/counterfactuals/opinions
- ❌ Overwrite existing notes without backup

---

## Final Lock-In

- **CLI:** Claude Code or Codex (user's subscription)
- **Template:** Literature Template
- **Format:** Feynman + Technical merged
- **Quality:** Deep decode standard
- **Output:** Notes ready for zettelkasten

This skill uses CLI only — no API credits consumed.
