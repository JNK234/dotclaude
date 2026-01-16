# CCL Weekly Report Generator

Generates a detailed weekly progress report by analyzing git history and repository changes from the past 7 days, formatted as technical task tracking.

## Task
Analyze all work completed in the current repository over the past week and generate a detailed, first-person technical report suitable for personal task tracking.

## Process

1. **Gather Git Activity Data**
   - Use `Bash` to run git log for the past 7 days
   - Use `Bash` to get commit statistics and file changes
   - Use `Bash` to identify major features/branches worked on

2. **Analyze Changes**
   - Use `Bash` to run git diff stats for the week
   - Identify key accomplishments and completed tasks
   - Note any significant code additions/deletions

3. **Format Detailed Technical Report**
   - Use `mcp__zen__chat` with model `gemini-2.5-flash` to format findings into:
     - Single-line bullet points (two lines only for huge tasks)
     - First-person perspective (use "I" not "we")
     - Technical details in plain language anyone can understand
     - Focus on what was actually accomplished
   
4. **Review and Save**
   - Display the formatted report for user review
   - After approval, use `Write` to save as:
     - Filename: `week-of-[YYYY-MM-DD].md` (Monday's date)
     - Location: `/Users/jnk789/Developer/CCL/Weekly-Reports/`

## Git Commands to Execute

```bash
# Get commit history for past 7 days
git log --since="7 days ago" --author="$(git config user.name)" --oneline

# Get detailed commit messages
git log --since="7 days ago" --author="$(git config user.name)" --format="### %s%n%b"

# Get file change statistics
git diff --stat $(git log --since="7 days ago" --format="%H" | tail -1)..HEAD

# Get summary of changes
git log --since="7 days ago" --author="$(git config user.name)" --stat --summary

# List modified files
git diff --name-only $(git log --since="7 days ago" --format="%H" | tail -1)..HEAD
```

## Report Structure

The final report should be structured as:
1. **Week Focus** - Single bullet point of main work area
2. **Tasks Completed** - Detailed bullet points of what I accomplished (single line each, two lines max for huge tasks)
3. **Technical Metrics** - Bullet points with quantified outcomes (files, commits, lines)
4. **Next Week** - 1-2 bullet points for upcoming tasks

## Arguments
- `$ARGUMENTS` can specify an alternate save location or custom date range

## Expected Output
- Detailed technical task report (not business-focused)
- Single-line bullet points in plain language
- First-person perspective throughout
- Saved to `/Users/jnk789/Developer/CCL/Weekly-Reports/week-of-[date].md`
- Focus on technical accomplishments and what was actually built/fixed/improved

## Usage
```
/ccl:weekly-report
```