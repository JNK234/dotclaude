# Brainstorm Command

Comprehensive brainstorming session with deep thinking and web research.

IMPORTANT: You have to BRAINSTORM and RESEARCH - NO CODING or IMPLEMENTING.

## Task

Conduct an interactive brainstorming session on the topic provided in $ARGUMENTS, using deep thinking and web research to generate comprehensive, actionable ideas.

## Process

### Phase 1: Understanding Requirements

1. **Parse the topic**
   - Extract the brainstorming topic from $ARGUMENTS
   - Identify key concepts and areas to explore

2. **Interactive Q&A Session**
   - Ask clarifying questions ONE BY ONE to understand:
     - Specific goals and objectives
     - Target audience or use case
     - Constraints or limitations
     - Desired outcomes
     - Any existing context or background
   - Wait for user responses between each question
   - Continue until you have a complete picture

### Phase 2: Deep Research & Thinking

3. **Web Research**
   - Use `WebSearch` for initial broad searches on the topic
   - Gather latest trends, best practices, and expert opinions
   - Extract relevant case studies and examples

4. **Sequential Thinking**
   - Break down the topic into logical components
   - Explore each component systematically
   - Generate hypotheses and validate them
   - Build upon each thought iteratively

5. **Deep Analysis**
   - Comprehensive investigation of:
     - Innovation opportunities
     - Potential challenges
     - Implementation strategies
     - Risk factors
     - Success metrics

### Phase 3: Synthesis & Documentation

6. **Compile Ideas**
   - Organize brainstormed ideas by:
     - Priority/Impact
     - Feasibility
     - Timeline
     - Resources required
   - Include supporting evidence from research
   - Note consensus points and areas of debate

7. **User Approval**
   - Present organized ideas to user
   - Ask for feedback and approval
   - Make any requested adjustments
   - Confirm final list of brainstormed ideas

8. **Save Documentation**
   - Create comprehensive documentation
   - Save to: `.claude/research/brainstorm-{topic}-{DD-MM}.md`

## Arguments

- $ARGUMENTS: The brainstorming topic or detailed requirements

## Expected Output

1. Interactive Q&A session to clarify requirements
2. Comprehensive web research with latest insights
3. Deep thinking analysis with multiple perspectives
4. Organized, detailed brainstorming document
5. Actionable recommendations ready for task generation
