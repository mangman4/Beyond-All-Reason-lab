# BAR AI candidates and environment-change evaluation

Prepared 2026-10-21 for the next project review. This is an engineering proposal, not a trained-model result or a team decision to abandon LLMs.

## Recommendation

Keep the current LLM strategy baseline and common action executor. First measure behavior across controlled scenarios. Prototype a small learned policy only after deterministic reset/step, legal-action masking, reward logging, and repeated evaluation are available. Do not spend time training a full-game agent before that interface exists.

| Candidate | Fit for the current BAR wrapper | Missing work | Main risk |
| --- | --- | --- | --- |
| LLM strategy with existing game execution | Immediately usable baseline; reasoning at a slower cadence | Repeated runs, side swaps, scenario selection | Variable latency, invalid outputs, passive production loops |
| Scripted strategy baseline | Cheap, reproducible reference for each scenario | Separate explicit baseline policy and evaluation configuration | Overfitting hand-written rules to one map |
| Small PPO policy | Candidate for bounded production/attack/defend decisions | Gymnasium environment, fixed-step control, reset, rewards, masking, training | Sample cost and environment overfitting |
| LLM strategy plus learned tactical policy | Candidate if tactical latency matters after measurement | Unit-group tactical interface and arbitration between policies | More integration complexity; current interface is too coarse for learned micro |

Gymnasium defines explicit observation/action spaces and reset/step semantics. Its custom-environment guide is a suitable interface reference, not an existing BAR adapter. [Official guide](https://gymnasium.farama.org/introduction/create_custom_env/)

Stable-Baselines3 PPO supports several numeric action spaces and dictionary observations; its standard PPO does not directly accept dictionary actions. Encode the existing structured commands into a fixed action representation, with a separate legality layer. Standard PPO and recurrent PPO are distinct implementations. [Official PPO documentation](https://stable-baselines3.readthedocs.io/en/master/modules/ppo.html)

Pluto is a StarCraft: Brood War self-play policy, distributed as binaries and weights and connected through BWAPI. It is an architectural reference, not a BAR model or reusable BAR training pipeline. Its current README reports roughly 20-60 ms policy steps on specified hardware; these are not LLM API latency measurements. [Official Pluto repository](https://github.com/tscmoo/pluto)

## Environment changes: proposed protocol

1. Freeze the game revision, extension revision, model ID, prompt, resource rules, and observation schema for each experiment.
2. Separate training maps/seeds from held-out evaluation maps/seeds. Compare in-domain results with unseen maps; do not train on the held-out set after inspecting its outcomes without declaring a new evaluation split.
3. Use normalized coordinates, map dimensions, unit capability features (ground/air, attack targets, range), and a versioned unit catalogue. Maintain fog-of-war restrictions for every policy.
4. Compare ground-only, ground-plus-air, and an air-threat scenario. Every policy receives the same available-unit list and legal actions. An unavailable factory or unit must mask the corresponding action.
5. Evaluate a frozen policy first. Then, as a separate experiment, measure adaptation by fine-tuning or adding training scenarios. Report retraining time and performance changes instead of treating adaptation as zero-shot generalization.
6. Start with 10 paired seeds per scenario, swapping sides (20 games). This is a pilot size, not a guarantee of statistical precision. Report win/draw/loss, uncertainty, invalid actions, idle time, commander survival, p50/p95 decision latency, model calls, and cost where available.

Proposed curriculum: fixed-map ground combat, mixed ground/air combat, then randomized maps/start positions. Resource and unit randomization must stay within a declared distribution. New unit types may require both observation/action schema changes and retraining; adding an aircraft factory alone does not prove policy generalization.

## Implementation status

Available: real LLM calls, a bounded command schema, visibility-filtered observations, ground/air factories, action/result logs, and isolated launches.

Not implemented: a Gymnasium BAR environment, synchronous reset/step, PPO training, learned tactical control, automated scenario matrices, map selection, side-swapped model assignment, or a validated trained policy. The current launcher uses one map and a fixed seed. The protocol above is the next experiment plan, not a description of completed support.

Historical Windows measurements were seconds per LLM response (see [validation](VALIDATION.md)), so use local measurements rather than a generic 20 ms LLM assumption. No promised training duration or win rate is justified yet.
