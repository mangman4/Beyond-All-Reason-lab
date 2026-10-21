@echo off
set "BAR_PYTHON=%USERPROFILE%\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
if exist "%BAR_PYTHON%" (
  "%BAR_PYTHON%" "%~dp0launcher\start_duel.py" %*
) else (
  python "%~dp0launcher\start_duel.py" %*
)
set "BAR_EXIT=%ERRORLEVEL%"
pause
exit /b %BAR_EXIT%
