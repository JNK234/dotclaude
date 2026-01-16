# Plan Command

Transform ideas and brainstormed concepts into detailed, actionable implementation plans with codebase awareness.

## Task

Create a clear, actionable implementation plan from user ideas or brainstormed documents, analyzing the existing codebase to ensure efficient integration without reinventing existing functionality.

## Process

### Phase 1: Input Processing

1. **Parse Arguments**
   - Extract input from $ARGUMENTS (can be a brainstorm file path or direct idea description)
   - If file path provided, use `Read` to load brainstormed content
   - Identify key features, goals, and requirements

2. **Understand Intent**
   - Break down the idea into core components
   - Identify technical requirements
   - Map features to implementation tasks
   - Extract success criteria and desired outcomes

### Phase 2: Codebase Analysis

3. **Examine Existing Code**
   - Use `Glob` to get directory overview
   - Search for existing implementations of similar features
   - Find related functionality that can be reused
   - Identify current architecture patterns
   - Analyze package.json/requirements.txt for current tech stack

4. **Identify Current Tech Stack**
   - Analyze discovered files to determine:
     - **Languages**: JavaScript/TypeScript/Python/etc.
     - **Frameworks**: React/Vue/Express/Django/etc.
     - **Build tools**: Webpack/Vite/npm/yarn/pip/etc.
     - **Testing**: Jest/Mocha/Pytest/etc.

### Phase 3: Interactive Clarification

5. **Ask Clarifying Questions**
   - Present findings from codebase analysis
   - Ask about:
     - **Scope confirmation**: "Based on existing [feature], should we extend it or create new?"
     - **Priority ordering**: "Which features are must-have vs nice-to-have?"
     - **Tech stack decisions**
     - **Development style**: "Use TDD approach or standard implementation?"
   - Wait for user response between each question
   - Document all decisions for the plan

### Phase 4: Plan Generation

6. **Strategic Planning**
   - Create sequential implementation steps
   - Consider dependencies between tasks
   - Estimate complexity and effort
   - Identify potential blockers

7. **Technical Validation**
   - Validate architectural decisions
   - Check for potential issues
   - Ensure scalability considerations

### Phase 5: Documentation

8. **Create Detailed Plan**
   - Generate comprehensive plan document
   - Save to: `.claude/plans/plan-{feature}-{DD-MM}.md`
   - Include: Overview, Tech Stack, Tasks, Dependencies, Testing Strategy

9. **Review with User**
   - Present the plan summary
   - Ask for final approval before saving
   - Make requested adjustments

## Arguments

- $ARGUMENTS: Either:
  - Path to brainstormed file
  - Direct idea description

## Expected Output

1. Comprehensive codebase analysis
2. Interactive Q&A session for requirement clarification
3. Detailed, atomic task breakdown
4. Saved plan document
5. Clear implementation roadmap with specific file changes
