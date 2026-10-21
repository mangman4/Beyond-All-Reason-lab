# Running the BAR duel

## Requirements

Use Python 3.12+, a platform-compatible Recoil build, the initialized BAR submodule, the Comet Catcher Remake map, and a running Ollama service. The launcher and bridge use only the Python standard library. Tests need `requirements-test.txt`.

```sh
git submodule update --init --recursive
python launcher/start_duel.py --data-dir /path/to/BAR/data --engine-dir /path/to/recoil
```

The data directory contains `maps/`. The engine directory contains `base/`, `fonts/`, and `spring` or `spring-headless` (`.exe` on Windows). Native macOS/Linux engine availability and execution must be validated separately.

The existing Windows defaults are `../BAR-Launcher/data` and its `engine/recoil_2026.07.04` folder. Double-click `Start-LLM-Duel.cmd` or the existing desktop shortcut. The command file uses installed bundled Python when available, otherwise Python on PATH. The legacy PowerShell entry point only forwards to Python.

Machine-specific overrides belong in ignored `launcher/local.json`:

```json
{"data_dir": "/absolute/path/to/BAR/data", "engine_dir": "/absolute/path/to/recoil"}
```

Command-line paths override this file. Runtime files must be outside the source checkout. Initial model and content loading may take several minutes.

## Models and rules

`agent/config.json` selects local `qwen3.5:4b` and cloud `gpt-oss:120b-cloud`, local context 4096, a minimum decision interval of 20 seconds, 40 calls per team, and a 15-minute match. Each model gets one additional pre-match readiness probe. Cloud access uses the local Ollama service's existing authentication. No cloud keys are stored in Lua or Git.

The original host has a Ryzen 5 7500F, 31.6 GiB RAM, and RTX 4070 SUPER 12 GB. The local model used about 3.13 GB GPU memory in the October 11 measurement. Availability, quotas, and latency can vary. Model errors are recorded without silently substituting another model.

Both Armada teams begin with a commander, vehicle factory, aircraft factory, six light tanks, 1500 metal, and 10000 energy. Equal additional income is 15 metal and 150 energy per second.

Actions: produce, attack, defend, economy. Ground choices: `light`, `heavy`, `scout`, `antiair`. Air choices: `fighter`, `bomber`, `gunship`, `airscout`. Production uses the proper factory, normal resource costs, and a maximum queue of nine per factory. Economy costs 300 metal for +3 metal/+30 energy per second, capped at five investments.

Observations include factories, queues, unit counts including construction, ready counts, and visible enemies only. Starting enemy locations are public to both teams. Movement, targeting, and pathfinding remain game mechanics. Commander destruction wins; the time limit draws. Factory rebuilding, free construction, T2/T3 technology, transport, and naval play are not implemented.

This is a bounded strategy demonstration. Repeat games, swap sides, control seeds, and measure latency/cost before drawing model-performance conclusions.

## Diagnostics

```sh
python agent/bridge.py --probe
python launcher/start_duel.py --prepare-only
python launcher/start_duel.py --headless --mock --test-seconds 30
python launcher/start_duel.py --hidden --test-seconds 90
python launcher/verify_run.py /path/to/run --require-finished
```

Use `--config FILE` for test configuration, `--runtime-root DIRECTORY` for separate logs, and different ports for concurrent runs. The auditor needs `--allow-mock` for mock runs; those are not model results. `--test-seconds` exits after simulated duration with an additional loading deadline (`--load-timeout`, default 300 wall-clock seconds). Normal interactive matches wait for the user to close the game.

Runtime roots: `%LOCALAPPDATA%/BAR-LLM-Duel` on Windows, `~/Library/Application Support/BAR-LLM-Duel` on macOS, and `$XDG_STATE_HOME/bar-llm-duel` (default `~/.local/state/bar-llm-duel`) on Linux. Files include events, engine/bridge logs, replays, and temporary session/start files. Do not publish these without review.

The bridge listens on loopback only. Observations pass through Python and Ollama to the cloud model. Authentication stays in Ollama. The launcher registers team content and the personal extension separately under `content-lab-v2` without modifying the submodule.
