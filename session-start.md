# Session start (daily)

A **short, repeatable** boot for the beginning of a dev session: recover *what* you are doing, then *environment* health. This is not the full [5-layer stack readiness](readiness-checklist.md) checklist (use that for onboarding, new phases, or when a stack failure mode shows up).

Order: **context → environment → go.**

- [ ] **Task / branch**: You know the ticket, branch name, or slice you are on; switch or create the branch if needed.
- [ ] **Handoff (optional)**: If your team uses one, read `continue.md` (or the project handoff path) for where you left off.
- [ ] **Sync**: `git status`; pull or rebase as appropriate so you are not building on stale base.
- [ ] **Dependencies (if needed)**: If lockfiles or toolchain changed, install or sync (e.g. package install, as required by the repo).
- [ ] **Quick health (pick one)**: Run the project’s fast smoke check—e.g. unit tests, lint, or build—*only* what the team uses as a “sanity” signal when starting.
- [ ] **Editor / agent context**: Open the right files, spec, or planning doc for today’s work; note anything the agent should know in-session.

- [ ] **Stack confidence (optional)**: run [`stack-check`](stack-check) in the project root if you need a quick “is the agentic stack in place for this repo/phase?” answer (see [`.stack-check.yaml.example`](.stack-check.yaml.example) to require RTK, GSD, etc., for a phase).

When something feels wrong with the *stack* (methodology, discipline, context tooling, token noise, or autonomous surface), use [readiness-checklist.md](readiness-checklist.md) and [`stack-check`](stack-check) instead of expanding this list.
