# RepairLoop Technical Overview v0.1

## Abstract

AI coding tools mostly focus on code generation and project editing. RepairLoop focuses on a narrower reliability problem: what should happen after software execution fails?

RepairLoop introduces a **Runtime Repair Loop**:

```text
Run → Capture → Repair → Verify
```

A Runtime Repair Loop is a closed-loop mechanism that detects runtime failures, analyzes causes, applies minimal repairs, and verifies execution recovery.

RepairLoop is currently focused on Python runtime failures, but the core idea is broader: repair should be grounded in real execution output and verified by rerunning the original command.

## Architecture

```text
User Command
    ↓
Execution Layer
    ↓
Error Capture
    ↓
Diagnosis Engine
    ↓
Repair Planner
    ↓
Safe Apply
    ↓
Verification
```

### Execution Layer

Runs the user-provided command and captures:

- exit code
- stdout
- stderr
- startup failures

### Error Capture

Extracts runtime signals from real command output instead of relying on a vague prompt.

Examples:

- `FileNotFoundError`
- `ModuleNotFoundError`
- command startup errors
- CLI argument errors
- selected dependency/runtime failures

### Diagnosis Engine

Classifies the failure into a known repair category when possible.

Unknown failures are reported conservatively instead of being force-fixed.

### Repair Planner

Produces a minimal repair suggestion.

Preferred actions include:

- creating a missing file or directory
- suggesting a missing dependency install
- applying narrow syntax fixes
- creating a required local data directory
- preparing structured JSON reports for automation

RepairLoop avoids broad rewrites and does not attempt to redesign the project.

### Safe Apply

Repairs are previewed by default.

A repair is only applied when the user explicitly passes:

```bash
--apply
```

This keeps automatic repair opt-in and inspectable.

### Verification

After applying a repair, RepairLoop reruns the original command.

A repair is considered successful only if the original command succeeds.

## Design Principles

### 1. Local-first

RepairLoop's base engine runs locally.

It does not require:

- cloud execution
- API keys
- source code upload
- remote model access

This makes it suitable for local development, internal repositories, CI workflows, and agent runtimes that need a small repair primitive.

### 2. Minimal Repair

RepairLoop prefers narrow, explainable repairs.

It prioritizes:

- creating missing files or paths
- repairing configuration/runtime setup issues
- using explicit rules for known failure modes
- preserving user control

It avoids:

- whole-project rewrites
- broad refactors
- speculative edits
- pretending to fix unknown errors

### 3. Verification Driven

RepairLoop is not successful because it generated a patch.

It is successful only when the original command runs again.

```text
Repair success = original command verification success
```

## Current Scope

RepairLoop currently targets Python command failures.

Supported repair directions include:

- missing files and paths
- missing Python modules
- command startup failures
- selected CLI errors
- simple syntax errors
- selected SQLite / Flask runtime cases
- JSON reports for automation

## Non-goals

RepairLoop is not:

- a general AI coding agent
- a chatbot
- a whole-project refactoring system
- a replacement for developer review
- a tool that claims to fix every error

## Why Runtime Repair Loop?

A coding agent often starts from intent.

RepairLoop starts from failure.

That difference matters because many runtime failures already contain the information needed for a safe, minimal repair.

RepairLoop turns that into a repeatable loop:

```text
Failure → Diagnosis → Minimal repair → Execution verification
```

The goal is reliable recovery, not impressive code generation.
