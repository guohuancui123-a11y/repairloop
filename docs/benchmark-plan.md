# RepairLoop Benchmark Plan v0.1

## Goal

The RepairLoop benchmark is intended to measure how reliably a Runtime Repair Loop can detect, repair, and verify common Python execution failures.

This is not a model benchmark. It is an execution-recovery benchmark.

## Failure Categories

Initial benchmark categories:

- `FileNotFoundError`
- `ModuleNotFoundError`
- `ImportError`
- `SyntaxError`
- command startup errors
- CLI argument errors
- dependency compatibility errors
- SQLite setup/runtime errors

## Metrics

| Metric | Question |
| --- | --- |
| Detection Rate | Did RepairLoop correctly identify the failure type? |
| Repair Suggestion Rate | Did RepairLoop generate an actionable repair suggestion? |
| Apply Success Rate | Did the repair apply without tool/runtime errors? |
| Verification Success Rate | Did the original command pass after repair? |
| False Repair Rate | Did RepairLoop apply an incorrect or harmful repair? |
| Repair Time | How long did detection, repair, and verification take? |
| Patch Size | How small was the applied repair? |

## Dataset Shape

Each benchmark case should include:

```text
benchmarks/<category>/<case-name>/
├── before/
│   └── minimal failing project
├── command.txt
├── expected_error.txt
├── expected_repair.md
└── README.md
```

Required fields:

- failing command
- expected failure class
- expected safe repair
- verification command
- notes about why the repair is safe or unsafe

## Example Case

```text
benchmarks/file-not-found/missing-config/
├── before/demo.py
├── command.txt
├── expected_error.txt
├── expected_repair.md
└── README.md
```

`command.txt`:

```bash
python demo.py
```

Expected behavior:

1. command fails with `FileNotFoundError`
2. RepairLoop detects missing local path
3. RepairLoop previews file/path creation
4. with `--apply`, RepairLoop creates the missing file/path
5. RepairLoop reruns the original command
6. verification succeeds

## Reporting Format

Benchmark runs should eventually emit JSON:

```json
{
  "case": "file-not-found/missing-config",
  "detected": true,
  "suggested": true,
  "applied": true,
  "verified": true,
  "false_repair": false,
  "repair_time_ms": 0,
  "patch_size": {
    "files_created": 1,
    "files_modified": 0,
    "lines_changed": 0
  }
}
```

## Phases

### Phase 1: Manual Case Library

Create small, inspectable failure cases for each supported repair rule.

### Phase 2: Automated Benchmark Runner

Add a benchmark runner that executes each case in an isolated temporary directory.

### Phase 3: Public Results

Publish benchmark results in the repository and release notes.

### Phase 4: Research Direction

Use benchmark data to evaluate Runtime Repair Loop behavior across broader software reliability tasks.

Potential long-term directions:

- autonomous software maintenance
- runtime self-healing systems
- CI repair primitives
- software reliability agents

## Principles

- Prefer small reproducible failures.
- Avoid benchmarks that require private services or credentials.
- Measure verification success, not just patch generation.
- Track false repairs explicitly.
- Keep all cases inspectable by developers.
