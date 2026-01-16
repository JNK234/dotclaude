# Implement Command

Execute implementation plans using Test-Driven Development with automated testing, commits, and progress tracking.

## Task

Transform a plan file into working code using TDD methodology, with automatic test generation, implementation, validation, and progress tracking.

## Process

### Phase 1: Setup & Initialization

1. **Parse Plan File**
   - Read plan file from $ARGUMENTS
   - Extract task list and tech stack decisions
   - Identify dependencies and task order
   - Create implementation roadmap

2. **Repository Setup**
   - Check if git repository exists
   - Initialize git if needed
   - Create initial commit if starting fresh

3. **Task Management Setup**
   - Use `TodoWrite` to create task list from plan
   - Mark all tasks as "pending"
   - Set first task as "in_progress"

### Phase 2: TDD Implementation Loop (Per Task)

4. **Task Analysis**
   - Read current task from plan
   - Understand requirements deeply
   - Identify edge cases
   - Define success criteria

5. **Test Generation (RED Phase)**
   - Generate comprehensive test cases:
     - Happy path tests
     - Edge case tests
     - Error handling tests
   - Create test files
   - Run tests and confirm they FAIL

6. **Implementation (GREEN Phase)**
   - Implement minimum code to pass tests
   - Follow tech stack decisions from plan
   - Match existing code patterns
   - Run tests repeatedly until ALL pass

7. **Refactoring (REFACTOR Phase)**
   - Once tests pass, identify code smells
   - Apply improvements while ensuring tests still pass
   - No over-engineering

8. **Validation & Quality Checks**
   - Run linting
   - Run type checking
   - Check test coverage
   - Fix any issues found

9. **Commit & Documentation**
   - Stage test files
   - Commit tests: `git commit -m "test: add tests for [feature]"`
   - Stage implementation
   - Commit implementation: `git commit -m "feat: implement [feature]"`

10. **Progress Update**
    - Mark current task as completed
    - Set next task as in_progress

### Phase 3: Completion

11. **Final Validation**
    - Run full test suite
    - Run integration tests
    - Check code coverage
    - Verify all plan objectives met

12. **Project Documentation**
    - Update README with setup/usage instructions

## Arguments

- $ARGUMENTS: Path to plan file (e.g., ".claude/plans/plan-auth-08-10.md")

## Expected Output

1. Test files for each task (failing first)
2. Implementation passing all tests
3. Clean git history with TDD commits
4. Updated plan file with progress
5. Full test coverage report

## Notes

- Strict TDD: Tests MUST fail before implementation
- Each task gets two commits: tests, then implementation
- Quality checks mandatory before task completion
