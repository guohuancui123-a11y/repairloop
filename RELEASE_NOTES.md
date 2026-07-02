# Release Notes Draft

## v0.1.0 - Local-first Repair Prototype

Lobster AI is now a runnable local-first Python runtime repair engine.

### Highlights

- CLI entry via `python -m lobster_ai_system`.
- `run` captures stdout, stderr, and exit code.
- `repair` performs RUN → OBSERVE → FIX → APPLY → VERIFY loop.
- Base engine works without external AI APIs or API keys.
- Core logic moved under `lobster_ai_system/core/`.
- Optional `lobster_ai_system/ai/` layer exists but is disabled by default.
- `ModuleNotFoundError` generates pip install suggestions/commands.
- `FileNotFoundError` can safely create missing files/directories.
- `SyntaxError: expected ':'` can apply a narrow missing-colon patch with rollback backup.
- Flask/Werkzeug compatibility errors can suggest compatible Werkzeug downgrade.
- SQLite open errors can create missing local data directories.
- SQLite missing `users` table can create a minimal smoke-test schema.
- Rollback metadata is written under `.lobster/rollback/` for file edits.
- Demo scripts in `demo/broken_import.py`, `demo/missing_file.py`, and `demo/broken_syntax.py`.
- Productized README with local-first positioning.
- MIT license added.

### Verified

```text
python -m pytest -q
19 passed
```

```text
python -m lobster_ai_system repair --apply --max-iterations 4 -- python smoke_test.py
[VERIFY] success
```

```text
python -m lobster_ai_system repair --apply --max-iterations 2 -- python demo\missing_file.py
[VERIFY] success
```

```text
python -m lobster_ai_system repair --apply --max-iterations 2 -- python demo\broken_syntax.py
[VERIFY] success
```

### Not Yet Done

- No commit or GitHub push yet.
- No GIF/video asset yet.
- More SyntaxError templates are roadmap only.
- TypeError / IndexError guards are roadmap only.
