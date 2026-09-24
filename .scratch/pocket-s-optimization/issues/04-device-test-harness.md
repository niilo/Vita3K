# 04: Add an adb test harness

Status: open
Type: task
Label: ready-for-agent
Blocked by: none

## Goal

One script for the test loop on the device, so every run uses the same
commands, and a setting can change between A and B without a rebuild.

## Context

- Files on the device: `/sdcard/Android/data/<package>/files/` holds
  `vita3k.log`, `config.yml` and `config/config_<titleid>.xml`
  (`../map.md`, Notes). `adb pull` and `adb push` work there without
  `run-as`.
- `Emulator.java:171-185` starts a game from the intent extra `title_id`.
- The measured package is `org.vita3k.emulator` (release).

## Steps

Create `tools/android/device.sh`. Put usage text at the top, in the style
of `container/vita3k.sh`. Use `ANDROID_SERIAL` when set. Refuse to act when
more than one device is connected and no serial is given.

| Command | What it does |
|---|---|
| `info` | Print `ro.product.manufacturer`, `ro.product.model`, `ro.soc.model`, `ro.board.platform`, Android version, `uname -r`, each core's max frequency, display modes (`dumpsys display`), and thermal status (`dumpsys thermalservice`). |
| `install <apk>` | `adb install -r -t <apk>`. |
| `launch <package> <title id>` | Force-stop, then `am start -n <package>/org.vita3k.emulator.Emulator --es title_id <id>`. |
| `stop <package>` | Force-stop. |
| `release <package>` | Force-stop and delete `tmp/device.lock` if this session wrote it. |
| `log <package> <out dir>` | Pull `vita3k.log`. |
| `pull-perf <package> <out dir>` | Pull the files from ticket 05. |
| `config-get <package> <key>` | Pull `config.yml` and print the line for `<key>`. |
| `config-set <package> <key> <value>` | Stop the app, pull `config.yml`, change the one line, push it back, print the line. Fail if the key is not in the file. |
| `config-guard <package> <title id>` | Fail if `config/config_<title id>.xml` exists. |
| `keys <keycode>...` | Send `adb shell input keyevent` presses, 300 ms apart. |
| `thermal <out file>` | Once per second until stopped: thermal status, CPU temperatures, each core's current frequency, `/sys/class/kgsl/kgsl-3d0/gpuclk` and `gpu_busy_percentage`. Write CSV. Skip values that cannot be read, and say so once. |
| `screenshot <file>` | `screencap -p` on the device, `adb pull`, delete the device copy. |

## Acceptance

- `bash -n tools/android/device.sh` passes.
- On the device: `info`, `install`, `launch`, `log`, `config-set`,
  `config-guard`, `thermal` and `stop` work. Paste the `info` output under
  `## Answer`.
- Record whether `keys` presses reach a running game. They may not, because
  SDL can ignore events without an input device. If they do not, write that
  here, and ticket 06 must plan runs with the user.
- `CLAUDE.md` names the script in one line.

## Answer
