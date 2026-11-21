---
name: sol-review
description: Loop a code review through GPT 6.1 Sol. Sol reviews the changes, you verify each finding, fix the real ones, and send it back. Stops when Sol approves or after 3 rounds. Use when the user asks for a Sol review, a second-opinion review loop, or "have sol review this".
---

# Sol review

Sol (`gpt-6.1-sol` on Codex) reviews. You verify and fix. Sol never edits code.

## Constants

- `MAX_ROUNDS`: 3
- Provider: `codex`
- Model: `gpt-6.1-sol`
- Options: `{ reasoningEffort: "high" }`
- Approval line: `VERDICT: APPROVED`
- Rejection line: `VERDICT: CHANGES_REQUESTED`

## 1. Pick the scope

Use the scope the user named. If they named none:

- Uncommitted changes exist → review `git diff HEAD` plus untracked files.
- Clean tree on a feature branch → review `git diff <default-branch>...HEAD`.
- Clean tree on the default branch → ask the user for a ref.

Write down the base ref. Every round reviews from the same base, so Sol sees your fixes on top of the original change.

## 2. Send the review

Call `orchestrator_capabilities` once per thread before the first delegate. If `gpt-6.1-sol` is not listed, tell the user and stop. Do not swap models.

Call `delegate_task`:

- `target`: `{ providerInstanceId: "codex", model: "gpt-6.1-sol", options: { reasoningEffort: "high" } }`
- `role`: `review`
- `isolation`: `shared`, so Sol sees uncommitted work
- `title`: `Sol review round <n>`

Each round is a new `delegate_task`. Never reuse a thread with `t3_thread_send`. Follow the returned `next` to get the result; don't poll.

Task body:

```
Review the code changes in this checkout. Do not edit, stage, or commit anything.

Scope: <base ref and the exact git command to see the diff>
Goal of the change: <one or two lines from the user or the commits>
Round: <n> of 3

<rounds 2+ only>
Previous findings and what happened to each:
- [fixed] <finding>: <what changed, file:line>
- [rejected] <finding>: <why, with evidence>
Check the fixes. If you still think a rejected finding is real, say why with new evidence. Otherwise drop it.
</rounds 2+ only>

Look for bugs, missed edge cases, broken error handling, races, security issues, and code that does not do what the goal says. Skip style nits unless they hide a bug.

For each finding, give:
- Severity: bug | shortcoming | nit
- Location: file:line
- Problem: what goes wrong
- Trigger: concrete input or state that causes it
- Fix: the change you suggest

End with exactly one line:
VERDICT: APPROVED      (no bugs or shortcomings left)
VERDICT: CHANGES_REQUESTED
```

## 3. Verify every finding

Sol can be wrong. Before changing code, check each finding yourself:

- Read the code at the location and its callers.
- Reproduce it when you can: a failing test, a script, or a trace through the code with the stated trigger.
- Mark it **confirmed** or **rejected**. A rejection needs evidence: a line that guards the case, a test that passes, a caller that can't reach it.

Skip nits unless the fix is trivial and inside the change's scope.

## 4. Fix confirmed findings

- Keep each fix to what the finding needs. No drive-by changes.
- Add a test for a confirmed bug when the project has tests.
- Run the project's tests, type check, and lint. Fix what you broke.
- Do not commit unless the user said to.

## 5. Loop

Go back to step 2 with the next round number when:

- Sol returned `VERDICT: CHANGES_REQUESTED`, and
- the round number is below `MAX_ROUNDS`.

Send rejected findings back with your evidence, so Sol can concede or argue.

Stop when Sol returns `VERDICT: APPROVED`, or after round 3.

## 6. Report

Keep it short, bullets only:

- Rounds run and final verdict
- Fixed: one line per finding, with file:line
- Rejected: one line per finding, with the reason
- Still open after round 3: anything Sol still flags that you didn't resolve
