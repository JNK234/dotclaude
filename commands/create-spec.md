# Create Spec Command

Interview the user in detail to create a comprehensive specification document.

## Task

Interview the user using AskUserQuestion about all aspects of their project/feature: technical, implementation, UI/UX, concerns, tradeoffs, etc. Ask non-obvious, in-depth questions until the specification is complete.

## Process

1. **Initial Understanding**
   - Ask about the core problem being solved
   - Understand the target users
   - Identify the main goals

2. **Deep Interview**
   - Use `AskUserQuestion` to ask ONE question at a time
   - Cover these areas:
     - Technical requirements and constraints
     - Implementation preferences
     - UI/UX considerations
     - Edge cases and error handling
     - Performance requirements
     - Security considerations
     - Integration points
     - Tradeoffs and priorities
   - Ask follow-up questions based on answers
   - Continue until all aspects are covered

3. **Clarification**
   - Identify any gaps or ambiguities
   - Ask clarifying questions
   - Confirm understanding of critical decisions

4. **Documentation**
   - Compile all information into a spec document
   - Save to: `.claude/specs/spec-{feature}-{DD-MM}.md`
   - Format should include:
     - Overview and goals
     - Requirements (functional and non-functional)
     - Technical decisions
     - UI/UX specifications
     - Edge cases and error handling
     - Open questions (if any)

## Notes

- Ask non-obvious questions that dig deeper
- Don't assume - ask and confirm
- Cover tradeoffs explicitly
- Be thorough but efficient
