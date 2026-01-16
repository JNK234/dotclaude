# Commit and Push Command

Review changes, create a proper commit, and push to the current branch.

## Task

Review all staged/unstaged changes, write a descriptive commit message following conventions, commit, and push.

## Process

1. **Review Changes**
   - Run `git status` to see all changes
   - Run `git diff` to review modifications
   - Understand what was changed and why

2. **Stage Changes**
   - Stage relevant files with `git add`
   - Verify staging with `git status`

3. **Create Commit**
   - Write a commit message following conventional commits format
   - Structure: `type(scope): description`
   - Types: feat, fix, docs, style, refactor, test, chore
   - Keep description concise but meaningful

4. **Push**
   - Push to the current branch
   - Handle any push errors appropriately

## Rules

- **NEVER include** "Co-authored with Claude" or "written by Anthropic"
- **DO NOT include** Claude's name anywhere in commit messages
- **DO NOT add** any AI attribution or references
- Write clean, direct commit messages
- Follow conventional commit format

## Example Commit Messages

```
feat(auth): add JWT token refresh mechanism
fix(api): handle null response from external service
refactor(utils): simplify date formatting logic
docs(readme): update installation instructions
```
