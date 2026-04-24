# Agentic Project Readiness Checklist 🚀

This checklist ensures your project is correctly configured for the **Agentic Coding Stack** (5 layers, 7 tools; see the [stack overview](https://blog.devgenius.io/the-agentic-coding-stack-7-tools-5-layers-and-the-missing-link-nobody-has-built-yet-de264b260db3)). Complete these steps *before* starting any major implementation—or when a failure mode in the stack becomes painful—not as a daily ritual.

### When to run this

- **Onboarding:** new machine, new clone, or new teammate.
- **Before a large feature** or a phase that will lean hard on agentic work.
- **When something breaks down:** e.g. spec drift, context loss, merge conflicts from parallel work—use this to see which *layer* is under-addressed and add the lightest tool for that layer.
- **Periodically** (e.g. start of a milestone or monthly) if the stack is stable but you want a full pass.

**Not** every morning. For a short, repeatable start-of-session loop (branch, handoff, quick health), use [session-start.md](session-start.md).

### Automated check

Run [`stack-check`](stack-check) from the **repo you are working in** (after opening your CLI). In **Claude Code**, install the **dev-checklist** plugin so `stack-check` is on the Bash tool `PATH` — see [docs/claude-code.md](docs/claude-code.md). It reports per-layer **OK / WARN / FAIL / MANUAL**, a **VERDICT** line, and **Remediate** links plus example commands for failed checks. It does not run installers for you. Optional [`.stack-check.yaml.example`](.stack-check.yaml.example) lets you set **phase**-specific `require_layer*` flags.

- [`stack-check`](stack-check) — current verifier (verdict and exit codes).
- [`verify-readiness.sh`](verify-readiness.sh) — legacy wrapper; calls `stack-check`.

For limits (e.g. Layer 3 = docs proxy, not Ctxo proof), see the header comment in `stack-check`.

---

## 🏛 Layer 1: Delivery Methodology
*Goal: Prevent premature implementation and specification gaps.*

- [ ] **Methodology Choice**: Decide between **BMAD-METHOD** (deep process) or **spec-kit** (lighter).
- [ ] **Spec-Kit / BMAD Initialized**:
    - [ ] `specs/` directory exists.
    - [ ] Artifact chain established: `constitution` -> `specify` -> `plan` -> `tasks`.
- [ ] **Success Criteria**: Clear acceptance tests defined in the spec.

## ⚖️ Layer 2: Agent Discipline
*Goal: Behavioral guardrails for the AI (superpowers).*

- [ ] **Behavioral Instructions**: `.cursorrules`, `instructions.md`, or `superpowers` skill library active.
- [ ] **TDD Workflow**: Agent is instructed to write tests *before* implementation.
- [ ] **Verification Gates**: Agent must verify work (run tests/lint) before claiming completion.
- [ ] **Atomic Commits**: Configure environment to commit per logical change.

## 🧠 Layer 3: Technical Context
*Goal: Deep semantic understanding of the codebase (Ctxo).*

- [ ] **Semantic Indexing**: Codebase indexed via **Ctxo** or equivalent MCP server.
- [ ] **Context Queries Ready**: Agent can answer:
    - [ ] "What is the blast radius of this change?"
    - [ ] "What are the logic slices/dependencies?"
    - [ ] "Why was this implemented this way? (Git history context)"

## ⚡ Layer 4: Token Optimization
*Goal: Filter noise to protect reasoning quality (RTK & context-mode).*

- [ ] **Shell Proxy Active**: **RTK** installed to intercept and compress verbose CLI output.
- [ ] **Execution Sandbox**: **context-mode** active for long research/exploration sessions.
- [ ] **Noise Reduction**: Build logs and large diffs are excluded/compressed.

## 🖥 Layer 5: Product Surface
*Goal: Integrated environment for autonomous work (gsd-2).*

- [ ] **Autonomous Shell**: **gsd-2** or equivalent operating surface is configured.
- [ ] **Worktree Isolation**: Tasks are isolated to prevent multi-session conflicts.
- [ ] **State Recovery**: Ability to recover context across session resets.

---

> [!IMPORTANT]
> **The Missing Link**: Ensure **Spec-to-Code Traceability**. Every code change should be traceable back to a specific requirement in your `specs/` folder.
