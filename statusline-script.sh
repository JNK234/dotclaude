#!/bin/bash

# ABOUTME: Status line showing context, model, branch, tokens, cost, duration.
# ABOUTME: Generic across projects. Uses Python for JSON parsing.

python3 -c "
import sys, json, subprocess

try:
    data = json.load(sys.stdin)
except:
    print('? | no data')
    sys.exit(0)

# Context window
ctx = data.get('context_window', {})
ctx_pct = int(ctx.get('used_percentage') or 0)
ctx_size = ctx.get('context_window_size') or 0

if ctx_size >= 1_000_000:
    ctx_label = f'{ctx_size // 1_000_000}M'
elif ctx_size >= 1000:
    ctx_label = f'{ctx_size // 1000}k'
else:
    ctx_label = str(ctx_size)

# Visual bar (10 chars)
filled = ctx_pct // 10
bar = '█' * filled + '░' * (10 - filled)

# Warning icon
if ctx_pct >= 80:
    icon = '🔴'
elif ctx_pct >= 50:
    icon = '🟡'
else:
    icon = '🟢'

# Model
model = data.get('model', {}).get('display_name') or data.get('model', {}).get('id') or '?'

# Git branch
project_dir = data.get('workspace', {}).get('project_dir') or data.get('cwd') or '.'
try:
    branch = subprocess.check_output(
        ['git', '--no-optional-locks', 'branch', '--show-current'],
        stderr=subprocess.DEVNULL, timeout=2, cwd=project_dir
    ).decode().strip() or 'detached'
except:
    branch = '?'

# Token flow
def fmt_tok(n):
    if n >= 1_000_000:
        return f'{n/1_000_000:.1f}M'
    elif n >= 1000:
        return f'{n/1000:.1f}k'
    return str(n)

in_tok = ctx.get('total_input_tokens') or 0
out_tok = ctx.get('total_output_tokens') or 0

# Cost (compact)
cost = data.get('cost', {})
usd = cost.get('total_cost_usd') or 0
if usd >= 100:
    cost_fmt = f'\${usd:.0f}'
elif usd >= 10:
    cost_fmt = f'\${usd:.1f}'
else:
    cost_fmt = f'\${usd:.2f}'

# Session duration
ms = cost.get('total_duration_ms') or 0
secs = ms // 1000
h, m = secs // 3600, (secs % 3600) // 60
duration = f'{h}h{m}m' if h > 0 else f'{m}m'

# Lines changed
added = cost.get('total_lines_added') or 0
removed = cost.get('total_lines_removed') or 0

parts = [
    f'{icon} {bar} {ctx_pct}% of {ctx_label}',
    branch,
    model,
    f'↑{fmt_tok(in_tok)} ↓{fmt_tok(out_tok)}',
    f'+{added} -{removed}',
    cost_fmt,
    duration,
]

print(' | '.join(parts))
"
