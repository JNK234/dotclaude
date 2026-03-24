---
allowed-tools: mcp__raindrop-mcp, Read, Bash
description: Add new features to an existing Raindrop application
argument-hint: [session_id]
---

WARNING: If you cannot find the "raindrop-mcp" server or the "get-prompt" tool for the "raindrop-mcp" server, respond with:
"Please check your raindrop-mcp server status by running /mcp, and reauthenticate"

Before updating, run `raindrop auth login` to authenticate. When the command returns, authentication is complete.

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
     * Ask user: "Which application would you like to add features to?"
     * Use the selected application's `latest_session_id`

4. If no session_id found, ask the user for it

5. Get the timeline_id from the session entry in index.json

6. Call mcp__raindrop-mcp__update-state with the session_id, timeline_id, and these parameters:
   ```json
   {
     "artifacts": {
       "current_state": "merge_features"
     },
     "status": "complete"
   }
   ```
   This jumps the workflow to the merge_features state for adding features.

7. Call mcp__raindrop-mcp__get-prompt with the session_id parameter

8. Follow the instructions returned and continue with the feature addition workflow
