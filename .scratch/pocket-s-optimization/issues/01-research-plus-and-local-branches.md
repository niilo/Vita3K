# 01: List the Android changes in Vita3K-Plus and in the local branches

Status: open
Type: research
Label: ready-for-agent
Blocked by: none

## Question

Which commits on `plus/all-enhancements` and on the three local `feat/*`
branches improve speed or stability on Android with an Adreno GPU, and
what does each one need?

## Context

- This repo has the Plus README but not the Plus code (`../map.md`, Notes).
- Remote `plus` is read-only for this work. Never push to it.
- Local branches with the user's earlier work: `feat/ayaneo-pocket-s-performance`,
  `feat/vulkan13-adreno`, `feat/vulkan-device-profiles`.

## Steps

1. `git fetch plus` and `git fetch origin`.
2. For each local branch: `git log --oneline master..<branch>` and
   `git show --stat <commit>`. Read each diff.
3. `git log --oneline --no-merges master..plus/all-enhancements`. Read each
   commit that touches Android, Adreno, Turnip, Qualcomm, page table,
   thread scheduling, deadlocks, memory, swapchain, or the pipeline and
   texture caches. Include at least: `f51a58ac`, `14521654`, `ffa287b4`,
   `5d25698c`, `e7f22c72`, `89496b8a`, `bf961274`, `4ee70305`.
4. For each commit, record: what it changes, the files, whether it mixes
   several fixes, and which earlier commits it needs.
5. Test whether it applies to `master`: create branch `tmp/plus-check` from
   `master`, run `git cherry-pick --no-commit <sha>`, record the result, run
   `git cherry-pick --abort`. Delete `tmp/plus-check` at the end.

## Output

Under `## Answer`:

1. A table with columns: source (branch or Plus), commit, subject, area,
   files, needs, applies cleanly (yes or no), expected effect on the
   Pocket S.
2. At most 10 lines of recommendation with two options for ticket 02:
   take single commits (list them), or base the fork on
   `plus/all-enhancements`. Say which local `feat/*` commits to keep in
   either option.

Do not change `master` in this ticket.

## Answer
