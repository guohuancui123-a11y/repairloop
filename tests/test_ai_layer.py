from lobster_ai_system.ai import is_enabled


def test_ai_layer_disabled_without_key(monkeypatch):
    monkeypatch.delenv("LOBSTER_AI_API_KEY", raising=False)
    assert is_enabled() is False


def test_ai_layer_enabled_with_key(monkeypatch):
    monkeypatch.setenv("LOBSTER_AI_API_KEY", "test")
    assert is_enabled() is True
