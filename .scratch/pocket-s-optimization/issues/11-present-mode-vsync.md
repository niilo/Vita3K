# 11: Make v-sync choose the Vulkan present mode

Status: claimed
Claimed: 2026-09-25 Claude Code session (Opus 5.5)
Type: task
Label: ready-for-agent
Blocked by: 05
Measure after: 06

## Problem

- The `v-sync` setting does nothing on Vulkan (`../map.md`, Notes).
  Vulkan always takes MAILBOX when offered
  (`vulkan/screen_renderer.cpp:208-228`).
- Android offers only FIFO and MAILBOX. There is no IMMEDIATE.
- The swapchain has `minImageCount + 1` images (`:258`). Under FIFO this
  can add up to about 4 frames of latency.
- `feat/ayaneo-pocket-s-performance` (`1838cd88`) already has a
  `select_present_mode()` that reads `pending_vsync`. Start from it if
  ticket 02 did not bring it.

## Steps

1. Choose the mode in one function: v-sync on gives FIFO; v-sync off gives
   MAILBOX, else FIFO.
2. Read `pending_vsync` in `ensure_swapchain()` (`:696-708`). If the mode
   changes, set `need_rebuild`.
3. MAILBOX can give more images than FIFO. `vita_surface` is sized once
   (`create_surface_image`, `:684-685`) and indexed per swapchain image
   (`vulkan/renderer.cpp:1159`). Resize `vita_surface` when the swapchain
   is created again, so the index cannot go past the end.
4. Log the present mode and image count in `create_swapchain()`.
5. Add a temporary config value for the image count: `minImageCount` or
   `minImageCount + 1`.

## Acceptance

- Both targets build.
- On the device, switching v-sync while a game runs changes the logged
  mode, with no crash.
- A/B/A on the 60 FPS and the 30 FPS title: FIFO against MAILBOX, then
  FIFO with `minImageCount` against `minImageCount + 1`. Record the frame
  interval 99th percentile and presents per second (ticket 05). Keep the
  combination with the lowest 99th percentile as the v-sync-on default.

## Answer
