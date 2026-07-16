@echo off
cd /d "%~dp0"
echo Fetching failed-step logs...
gh run view 28574247792 --repo UisComp/Diyar-App-New --log-failed > "%TEMP%\diyar_failed.log" 2>&1
echo.
echo ===== relevant lines =====
powershell -NoProfile -Command "Get-Content '%TEMP%\diyar_failed.log' | Select-String -Pattern 'platform|exit code 16|Bundler|GemNotFound|frozen|could not|Your bundle|x86_64-linux|Errno|Fastfile|error' | Select-Object -Last 40 | ForEach-Object { $_.Line }"
echo ==========================
pause
