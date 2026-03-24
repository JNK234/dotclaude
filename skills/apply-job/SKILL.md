---
name: apply-job
description: End-to-end job application workflow. Use when the user says "apply for this job", "help me apply to [company]", "fill this application [URL]", "apply-job [URL]", "draft application for [URL]", "assess fit for [URL]", "should I apply to [company]", or shares a job posting URL and wants help applying. Triggers on any job application request.
---

# Job Application Workflow

End-to-end pipeline: fetch job posting → research company → assess fit → ask targeted questions → draft answers → log to Obsidian.

**Applications Log:** `/Users/jnk789/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain/10_SOURCES/Job Applications Log.md`
**Master Profile:** `/Users/jnk789/Library/Mobile Documents/iCloud~md~obsidian/Documents/Brain/80_JOURNALS/Master_Complete_Profile_Narasimha_Karthik.md`
**Resume:** `/Users/jnk789/Desktop/JNK/Applications/jnk_cv-3.pdf`
**Vault CLI:** `obsidian-cli` (NOT `obsidian`) — append `2>/dev/null` to suppress warnings

**RELATED SKILLS:**
- For vault CRUD operations → `obsidian-vault`
- For deep domain research → `research-papers`

---

## The Pipeline

Execute steps IN ORDER. Do not skip. Do not proceed past Step 6 without user approval.

### Step 1: Load Profile Context

Read the Job Applications Log first — it has the full profile, answer bank, and all past applications. **ALWAYS use `obsidian-cli` for reading vault files** — do NOT use the Read tool directly on vault paths. Example: `obsidian-cli read "10_SOURCES/Job Applications Log" 2>/dev/null`

If deeper detail needed (STAR stories, company-specific Q&A), also read the Master Profile via obsidian-cli: `obsidian-cli read "80_JOURNALS/Master_Complete_Profile_Narasimha_Karthik" 2>/dev/null`

For any other vault operations (search, create, append, list), use the `/obsidian-vault` skill.

### Step 2: Fetch the Job Posting

Use WebFetch on the provided URL. Extract and organize:
- Company name, role title
- Location (remote/hybrid/on-site)
- Salary range
- Requirements split into **must-have** vs **nice-to-have**
- Responsibilities
- All application form fields (every question on the form)
- Team/product context

If WebFetch fails, ask the user to paste the JD text.

### Step 3: Research the Company

**ALWAYS use a subagent (Agent tool) for company research** — do NOT run web searches in the main context. Dispatch a general-purpose subagent with a prompt to research the company and return a structured summary. This keeps the main context clean and avoids rate-limit issues.

The subagent should find:
- Funding, valuation, investors
- Team size, notable leadership
- Core product/technology
- Recent news (last 6 months)
- Company values/culture signals
- Any connections to user's experience domains

The subagent returns a brief company research summary (8-12 bullet points).

### Step 4: Assess Fit

Score EACH requirement against the user's profile:

| Strength | Criteria |
| --- | --- |
| STRONG | Direct, recent, quantifiable experience |
| MODERATE | Related experience, transferable skills |
| WEAK | No direct experience, would need to learn |

**Scoring:**
- Must-have STRONG = 3pts, MODERATE = 2pts, WEAK = 1pt
- Nice-to-have STRONG = 2pts, MODERATE = 1pt, WEAK = 0pts
- Calculate: (actual points / max points) × 100 = fit percentage

**Thresholds:**
- 70%+ → Proceed confidently
- 50-69% → Flag as borderline, present honest assessment, let user decide
- <50% → Flag honestly as weak fit, explain the gaps, but let user decide whether to proceed

Present the fit table and overall score. **Stop here and wait for user's decision** before drafting anything.

### Step 5: Ask Targeted Questions

Use the **AskUserQuestion tool** — NEVER dump questions inline as text.

Ask 2-3 targeted questions about:
1. **Genuine motivation** — What specifically draws them to this company/role/problem?
2. **Relevant experience** — Any unlisted projects or experiences that strengthen fit?
3. **Gaps acknowledgment** — How do they want to frame any weak areas?

These questions should be SPECIFIC to the role, not generic. Reference the JD requirements.

### Step 6: Cross-Reference Answer Bank

Before writing new answers, check the Reusable Answer Bank in the Job Applications Log. If a similar question has been answered before, adapt it rather than writing from scratch.

### Step 6.5: Tailor Resume (if application requires resume upload)

If the application has a resume upload field, run `/tailor-resume` inline using the JD context already loaded. This generates a tailored PDF and produces an **ATS keyword match rate** — use this to refine the fit assessment from Step 4. If the ATS match rate is significantly different from the profile fit score, note the discrepancy.

- If ATS match < 60%: warn the user before proceeding with the application
- The tailored resume's match rate is logged alongside the fit score in Step 8

### Step 7: Draft Answers

Write all form fields and essay responses. Rules:
- **No AI slop** — genuine, specific, grounded in real experience
- Lead with the most relevant experience for THIS specific role
- Use concrete metrics and project names
- Connect personal motivation to company mission authentically
- Keep essay answers to 2-3 focused paragraphs unless the field demands more
- Match the tone to the company culture (startup vs enterprise vs research lab)

Present drafts to user for review. Wait for approval or revision requests.

### Step 7.5: Zen Multi-Model Critique

After drafting answers (and before logging), use Zen's `chat` tool to get an external critique from a different model family. This catches AI slop, student-energy signals, and weak framing that the main agent might miss.

**Prompt to send to Zen:**

```
You are a senior engineering manager at [Company] reviewing a peer senior engineer's application for [Role]. The role requires: [top 8-10 JD requirements].

Below are the candidate's drafted application answers. Review them as you would a senior colleague's work — hold them to staff-level standards:

1. Does each answer lead with IMPACT and OWNERSHIP, not task descriptions?
2. Are claims backed by specific systems, scale numbers, and measurable outcomes?
3. Does the candidate demonstrate architectural thinking and cross-team influence?
4. Is the writing tight and direct, or padded with filler ("I'm passionate about...", "excited to...")?
5. Does the candidate sound like someone who DROVE decisions, or someone who followed instructions?
6. Are there JD keywords or domain concepts missing that should be woven in naturally?
7. Score each answer 1-10 on senior-level credibility and suggest specific line-level rewrites.

[Paste the drafted answers here]
```

**Model selection:** Use an OpenRouter model (e.g., `openai/gpt-5.2`, `x-ai/grok-4`, `gemini-3-pro-preview`) — do NOT use the same model family as the main agent. The point is a different perspective.

**After Zen responds:**
- Apply valid critique (truthful improvements only)
- Ignore suggestions that fabricate experience
- If any answer scores <7, iterate once with fixes
- Present final revised drafts to user

### Step 8: Log to Obsidian

After user approves, update the Job Applications Log. Use direct file editing (Edit tool on the vault file) since obsidian-cli can struggle with long content.

**Record format:**

```markdown
### N. [Company] — [Role Title]
- **Date:** YYYY-MM-DD
- **URL:** [application URL]
- **Location:** [location]
- **Salary:** [range if known]
- **Status:** Drafting | Applied | Interview | Rejected | Offer
- **Source:** [LinkedIn/Direct/Referral/etc]

**Role Focus:**
- [3-4 bullet points on what the role does]

**Fit Assessment: ~XX% — [Strong/Borderline/Weak]**
**ATS Resume Match: ~XX%** (if tailored resume was generated)

| Requirement | Match | Strength |
| --- | --- | --- |

**Form Fields:**
[numbered list of all fields with final answers]

**Final — [Essay Field Name]:**
[full text of any essay/long-form answers]

---
```

### Step 9: Update Answer Bank (If Applicable)

If a new reusable answer was written (e.g., "Why AI Safety?", "Most Passionate ML Area"), add it to the Reusable Answer Bank section of the log with:
- Question/topic name
- Source application
- Best-for context (what types of roles it suits)
- Summary

### Step 10: Update Status

Change application status from "Drafting" to "Applied" once the user confirms they've submitted.

---

## Key Details (Always True)

- **Name:** Narasimha Karthik Jwalapuram
- **Email:** narasimhajwalapuram2026@u.northwestern.edu
- **Location:** Chicago, IL — open to relocation
- **Work Authorization:** OPT (F-1 visa, will need H-1B sponsorship)
- **LinkedIn:** https://www.linkedin.com/in/narasimhakarthik
- **GitHub:** https://github.com/JNK234

---

## Anti-Patterns (DO NOT)

1. **DO NOT** write generic motivations — every answer must reference specific experience
2. **DO NOT** dump questions as inline text — always use AskUserQuestion tool
3. **DO NOT** proceed past fit assessment without user approval
4. **DO NOT** use `obsidian` command — always `obsidian-cli`
5. **DO NOT** skip reading the Answer Bank before writing new answers
6. **DO NOT** use flowery language, filler phrases, or corporate buzzwords
7. **DO NOT** apply per-application feedback as universal rules — each application's tone and specificity is context-dependent

---

## Quick Reference

| Step | Action | Tool |
| --- | --- | --- |
| 1 | Load profile | `obsidian-cli` (Job Applications Log + Master Profile) |
| 2 | Fetch JD | WebFetch |
| 3 | Research company | Agent (subagent with web search) |
| 4 | Assess fit | Present table, wait for approval |
| 5 | Ask motivations | AskUserQuestion |
| 6 | Check answer bank | Read (Job Applications Log) |
| 6.5 | Tailor resume | `/tailor-resume` (if resume upload needed) |
| 7 | Draft answers | Present to user |
| 7.5 | Zen multi-model critique | Zen chat (OpenRouter model, different family) |
| 8 | Log to Obsidian | Edit (vault file directly) |
| 9 | Update answer bank | Edit (if new reusable answer) |
| 10 | Mark applied | Edit (status field) |
