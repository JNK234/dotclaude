---
name: tailor-resume
description: Tailor the LaTeX resume for a specific job description. Use when the user says "tailor resume for [company]", "customize resume", "tailor-resume [URL]", "make resume for [role]", or wants a job-specific version of their resume. Can be triggered standalone or from within /apply-job.
---

# Tailor Resume Workflow

Swap projects, reorder bullets, inject keywords, and compile a tailored PDF — all from the LaTeX base resume.

**Base Resume:** `/Users/jnk789/Desktop/JNK/Applications/resume-base.tex`
**Output Dir:** `/Users/jnk789/Desktop/JNK/Applications/tailored/`
**Compiler:** `tectonic` (installed at `/opt/homebrew/bin/tectonic`)
**Profile Context:** Job Applications Log + Master Profile (same as /apply-job)

**RELATED SKILLS:**
- For full application workflow → `apply-job`
- For vault operations → `obsidian-vault`

---

## The Pipeline

Execute steps IN ORDER. Do not skip. Do not generate LaTeX without user approval at Step 3.

### Step 1: Load Base Resume + JD

1. Read `resume-base.tex` from `/Users/jnk789/Desktop/JNK/Applications/`
2. Get the JD: either from a URL (WebFetch), pasted text, or reuse context from an active `/apply-job` session
3. Read the Job Applications Log for profile context (reusable answer bank, past applications)

### Step 2: Analyze & Map Requirements

Extract JD keyword clusters: required skills, tools, frameworks, responsibilities, outcomes.

Map each JD requirement to resume sections using the entry pool below:

**EXPERIENCE POOL (pick 4 active, comment the rest):**

| Entry | Default | Lines | Key Topics |
|-------|---------|-------|------------|
| Medhastra AI | Active | 196-203 | Multi-agent, LangGraph, medical AI, streaming, FastAPI |
| CCL Lab | Active | 205-213 | Research, genetic algorithms, LLM evolution, Scala, NetLogo |
| Overtone | Commented | 215-222 | Text-to-SQL, BigQuery, rec-sys, async, Pub/Sub, GCP |
| Relativity | Active | 224-233 | LLM-as-Judge, red-teaming, Databricks, structured decoding, Azure |
| Boeing | Active | 235-243 | Pre-training, RLHF, RAG, production ML, safety-critical |
| Invento Robotics | Commented | 245-251 | iOS, WebRTC, edge ML, ROS2, fall detection |

**PROJECT POOL (pick 3 active, comment the rest):**

| Entry | Default | Lines | Key Topics |
|-------|---------|-------|------------|
| Quibo AI | Active | 287-291 | Multi-agent, HyDE, semantic caching, MCP, LangGraph |
| Lung Tumor Detection | Active | 293-298 | PyTorch, MONAI, H100, 3D segmentation, TensorRT |
| Financial Interpretability | Active | 300-305 | Transformers, Qwen 7B, attention rollout, interpretability |
| Self-Evolving Agents | Commented | 268 | Agent framework, prompt iteration, W&B |
| FaceSwap Diffusion | Commented | 273 | DDPM, diffusion models |
| AdVocate | Commented | 275 | GPT-4o, Stable Diffusion, hackathon |

Determine:
- Which experience entries are most relevant? (swap in/out from pool)
- Which project entries best demonstrate fit? (swap in/out from pool)
- Which bullets within entries to reorder or rephrase?
- Which skills to promote/add/reorder in the Skills section?

### Step 3: Present Tailoring Plan — STOP FOR APPROVAL

Show the user a structured plan like:

```
EXPERIENCE (pick 4):
  [keep/swap] Entry — reason

PROJECTS (pick 3):
  [keep/swap] Entry — reason

BULLETS TO REWRITE:
  - [Entry] bullet N: what to change and why

SKILLS SECTION:
  - Changes to keyword ordering/additions
```

**STOP HERE.** Wait for user approval before generating any LaTeX.

### Step 4: Generate Tailored .tex

1. Copy `resume-base.tex` content to `tailored/{company}-{role}.tex` (lowercase, hyphens, no spaces)
2. Apply ALL approved changes:
   - Uncomment swapped-in entries, comment out swapped-out entries
   - Reorder entries within sections (most relevant first)
   - Rewrite specific bullets (same truth, JD-aligned framing — NEVER fabricate)
   - Update Skills section keywords
3. Auto-apply tectonic compatibility fixes:
   - Comment out `\input{glyphtounicode}` (line 24)
   - Comment out `\pdfgentounicode=1` (line 99)
   - Add `\item[]` before `\resumeItemListStart` in publications section (line 257)

### Step 4.5: Zen Multi-Model Verification

After generating the .tex file, use Zen's `consensus` tool (or `chat` if consensus is unavailable) to get external validation before compiling. Send the following to Zen:

1. **The JD** — role title, company, key requirements
2. **The tailored resume content** — share the .tex file path via `absolute_file_paths`
3. **The prompt:**

```
You are reviewing a tailored resume for [Role] at [Company]. The JD requires: [list top 8-10 requirements].

Evaluate this resume against the JD:
1. Are the strongest experiences positioned to match the top requirements?
2. Are there any bullet points that feel weak, vague, or irrelevant to this specific role?
3. Are there keywords from the JD that should appear but don't?
4. Does the candidate sound like a senior engineer or a student? Flag any student-energy signals.
5. Any bullets that fabricate or overstate experience? Flag immediately.
6. Score the resume-JD alignment 1-10.
7. Suggest up to 3 specific bullet rewrites (preserve truth, improve framing).
```

**Model selection:** Use an OpenRouter model (e.g., `openai/gpt-5.2`, `x-ai/grok-4`) — do NOT use the same model family as the main agent. The point is a different perspective.

**After Zen responds:**
- Apply any valid suggestions (truthful improvements only)
- Ignore suggestions that fabricate experience
- If score is <7, iterate once more with fixes before compiling
- If score is 7+, proceed to compile

### Step 5: Compile to PDF

```bash
cd /Users/jnk789/Desktop/JNK/Applications && tectonic tailored/{company}-{role}.tex
```

- If compile fails: read the error, fix the LaTeX, retry (common: unescaped `&`, missing braces, bad comments)
- On success: `open tailored/{company}-{role}.pdf`

### Step 6: ATS Keyword Match Audit

After compiling, do a final pass comparing the tailored resume against the JD:

1. **Extract all JD keywords** — tools, frameworks, languages, methodologies, domain terms, soft skills
2. **Scan the tailored resume** for each keyword (exact match or close synonym)
3. **Present a match table:**

```
KEYWORD MATCH AUDIT:
  Found (X/Y keywords):
    [keyword] — found in [section]
    ...
  Missing (Z keywords):
    [keyword] — not addressable (no real experience)
    [keyword] — could add to Skills section
    ...

  ATS MATCH RATE: X/Y = NN%
```

4. **Recommendation:**
   - 80%+ match → Strong resume-JD alignment, apply confidently
   - 60-79% → Decent match, worth applying with a strong cover letter
   - <60% → Weak alignment, flag gaps honestly and let user decide

**If missing keywords can be truthfully added** (user has the skill but it wasn't in the resume), suggest adding them and re-compile. Wait for user approval.

### Step 7: Report

Present:
- File paths: `.tex` and `.pdf`
- Summary of key changes made (experience swaps, bullet rewrites, skill additions)
- ATS match rate from Step 6
- Confirm: `resume-base.tex` is unmodified

---

## LaTeX Custom Commands Reference

- `\resumeSubheading{Company}{Location}{Role}{Dates}` — experience header
- `\resumeProjectHeading{Title | Tech}{Date}` — project header
- `\resumeItem{text}` — bullet point
- `\resumeItemListStart` / `\resumeItemListEnd` — bullet container
- `\resumeSubHeadingListStart` / `\resumeSubHeadingListEnd` — section container

## Tectonic Compatibility Fixes (always apply to tailored copies)

1. Comment out `\input{glyphtounicode}` → `% \input{glyphtounicode}`
2. Comment out `\pdfgentounicode=1` → `% \pdfgentounicode=1`
3. In publications section, add `\item[]` before `\resumeItemListStart`:
   ```latex
   \resumeSubHeadingListStart
       \item[]
       \resumeItemListStart
   ```

## Spacing

Do NOT change spacing parameters from `resume-base.tex` defaults. Instead, control page fit by adjusting bullet wording length (line-fill rule above) and by swapping entries in/out.

## Core Priority: ATS Keyword Injection

The #1 goal is maximizing ATS keyword match rate. Everything else (visual polish, line filling) is secondary as long as it looks professional.

When rewriting bullets:
1. **Inject JD keywords** — exact terms from the posting (tools, frameworks, methodologies)
2. **Preserve truth** — same facts, reframed with JD vocabulary
3. **Fill lines cleanly** — no orphaned trailing words (1-3 words alone on last line), but prioritize keywords over cosmetics

**Visual check loop:** compile → `qlmanage -t -s 3200` preview → Read image → verify 1-page fit and no ugly orphan lines → fix if needed.

## Anti-Patterns (DO NOT)

1. **DO NOT** fabricate experience, metrics, or project details
2. **DO NOT** change dates, company names, role titles, or degree information
3. **DO NOT** remove fixed sections (Education, Publications & Awards stay as-is)
4. **DO NOT** modify `resume-base.tex` — ALWAYS work on copies in `tailored/`
5. **DO NOT** compile without showing the tailoring plan first (Step 3 gate)
6. **DO NOT** add experience or projects not in the entry pool without user confirmation
7. **DO NOT** exceed the slot limits (4 experience, 3 projects) — the page must fit on 1 page

---

## Quick Reference

| Step | Action | Tool |
|------|--------|------|
| 1 | Load resume + JD | Read + WebFetch |
| 2 | Analyze & map | Internal analysis |
| 3 | Present plan | Show table, WAIT for approval |
| 4 | Generate .tex | Write (to tailored/) |
| 5 | Compile PDF | Bash (tectonic) + open |
| 6 | ATS keyword audit | Compare resume vs JD keywords, show match % |
| 7 | Report | Show paths + summary + match rate |
