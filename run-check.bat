@echo off
cd /d "%~dp0"
echo ==================================================
echo   iOS Signing Bootstrap - run status
echo ==================================================
gh run view 28582172948 --repo UisComp/Diyar-App-New
echo.
echo ==================================================
echo   Recent runs (all workflows)
echo ==================================================
gh run list --repo UisComp/Diyar-App-New --limit 6
echo.
pause
