---
allowed-tools: mcp__raindrop-mcp, Read
description: Reattach to an existing Raindrop development session
argument-hint: [session_id]
---

WARNING: If you cannot find the "raindrop-mcp" server or the "get-prompt" tool for the "raindrop-mcp" server, respond with:
"Please check your raindrop-mcp server status by running /mcp, and reauthenticate"

Before reattaching, run `raindrop auth login` to authenticate. When the command returns, authentication is complete.

After authentication:

1. If session_id is provided as $ARGUMENTS, use it and skip to step 5

2. Otherwise, read `~/.raindrop/index.json` to get applications and sessions:
   - File format:
     ```json
     {
       "applications": {
         "my-app": {
           "latest_session_id": "sess_abc123",
           "sessions": [...]
         }
       },
       "sessions": {
         "sess_abc123": {
           "session_id": "sess_abc123",
           "timeline_id": "timeline_456",
           "created_at": "...",
           "current_state": "...",
           "application_name": "my-app"
         }
       }
     }
     ```

3. Handle application selection:
   - If no applications exist, respond: "No Raindrop applications found. Use /new-raindrop-app to create one."
   - If one application exists, use its `latest_session_id`
   - If multiple applications exist:
     * List all application names with their current state and last updated time
     * Ask user: "Which application would you like to reattach to?"
     * Use the selected application's `latest_session_id`

4. If no session_id found, ask the user for it

5. Call mcp__raindrop-mcp__get-prompt with the session_id parameter

6. Follow the instructions returned and continue with the development workflow