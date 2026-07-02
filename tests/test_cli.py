from lobster_ai_system.cli import RunResult, first_blocking_error


def test_first_blocking_error_uses_exception_line():
    result = RunResult(
        command=["python"],
        returncode=1,
        stdout="",
        stderr='Traceback\nModuleNotFoundError: No module named \'x\'\n',
    )
    assert first_blocking_error(result) == "ModuleNotFoundError: No module named 'x'"


def test_first_blocking_error_none_when_ok():
    result = RunResult(command=["python"], returncode=0, stdout="ok", stderr="")
    assert first_blocking_error(result) is None
