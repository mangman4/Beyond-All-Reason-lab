# Validation record

## Historical Windows validation: 2026-10-11

These recorded results describe the previous implementation, not a new cross-platform run.

- Thirty Python/Lua 5.1 tests and the personal Lua format check passed after air support.
- Team game revision: `8775483821cc96788f85ad755ebc5341a654e2aa`, with its nested Lua library initialized.
- Actual-model graphical run `20261011-105749-0d4598`: 30-game-second draw, two decisions applied per team, ground/air factories observed, engine exit zero.
- Actual-model run `20261011-093904-51fcbc`: cloud victory at frame 3294 (109.8 game seconds), five valid decisions per team, no model errors. Local latency 1.281-1.359 seconds; cloud 0.547-1.266 seconds. This does not establish general model superiority.
- Air-production mock run `20261011-100527-d9db88`: 210 game seconds; both teams produced fighter, bomber, gunship, air scout, and antiair units. Thirty-nine commands per team, successful engine exit. This validates command plumbing, not model strategy.
- Actual-model air-enabled run `20261011-100821-ea6eb3`: 30 game seconds; both models chose ground actions. Air availability is not evidence of model air strategy.

Earlier fixes covered multiplied production counts, malformed messages, stale/duplicate requests, result delivery retries, Lua reload state, exclusive loopback ports, and Windows process exit reporting.

Tests cover authentication, call limits, concurrency, HTTP failures, command legality, queue limits, factory routing, air observations/commands, enemy visibility, economy limits, victory/draw, and reload/result handling. The full upstream BAR suite and long-duration profiling were not run.

## Meeting-alignment migration

Launch behavior is now Python. PowerShell only forwards legacy arguments. Recoil binaries/data remain external. Native macOS/Linux engine execution is unverified until tested on a separate host. Current revision test results are appended after execution.

Historical development commits remain in the personal game fork and its archive branch. The lab starts from a clean source snapshot. The personal game fork is restored separately without force-pushing. No personal feature is added to the team game.


## Windows migration checks: 2026-10-21

- All 37 Python/Lua 5.1 tests passed, including preparation with spaces in paths, conflicting-link protection, owned-process cleanup, configuration injection rejection, and isolation of model warm-up timeouts from match timeouts.
- Recursive submodule initialization passed; the pinned team checkout remains clean.
- Mock engine run `20261021-113418-78c9c1` exited with code zero after 30 game seconds. Five snapshots and two applied commands per team passed the log auditor. This was a launch/command-path smoke test, not a completed-match result.
- Initial cold content run `20261021-113022-bc9882` exceeded the former loading deadline and was stopped. The new configurable loading allowance defaults to 300 seconds; the successful mock run took about 212 wall-clock seconds.
- First real-model attempt `20261021-113845-633d01` correctly refused to start a game because local model cold loading exceeded the old 60-second readiness limit. Cloud readiness succeeded. Readiness now has its own 180-second allowance, while in-match request limits are unchanged.
- Desktop shortcut target and the legacy BAR install's content junction were checked after the submodule move.
- Native macOS/Linux game runs are still unverified. The POSIX link branch has a mocked contract test only.

- Final actual-model graphical run `20261021-114103-6bf131`: draw at frame 900 (30 game seconds), five snapshots, two valid decisions and two applied commands per team, zero model errors, engine exit zero. The result-required auditor passed. The local model produced units; the cloud model attacked. Local measured latency was 1.078 seconds; cloud 0.640-1.000 seconds. These are short smoke-test observations, not a benchmark.
- The bridge port 18765 had no listener after the match. Both CMD and legacy PowerShell preparation entry points exited successfully.
