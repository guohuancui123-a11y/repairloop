from pathlib import Path

config = Path("demo/generated/config.txt")
print(config.read_text(encoding="utf-8"))
