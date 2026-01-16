allowed-tools: mcp\_\_raindrop-mcp, Write, Bash
description: Create a new Raindrop application from scratch

WARNING: If you cannot find the "raindrop-mcp" server or the "get-prompt" tool for the "raindrop-mcp" server, respond with:
"Please check your raindrop-mcp server status by running /mcp, and reauthenticate"

Before starting the workflow, run `raindrop auth login` to authenticate. When the command returns, authentication is complete.

After authentication, call the mcp**raindrop-mcp**get-prompt function without any parameters to start a new development session. This will automatically create a new session and return initial workflow instructions.

The workflow will create a session cache directory at ~/.raindrop/<session_id>/ to store all artifacts and session metadata locally.

Follow the instructions returned and continue with the development workflow, using mcp**raindrop-mcp**update-state to report task completion.
