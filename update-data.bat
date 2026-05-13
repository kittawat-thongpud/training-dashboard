@echo off
:: Update training data from API servers
:: Run from visualization folder: update-data.bat

echo [93m🔄 Updating training data from API servers...[0m

:: Get parent directory (project root)
for %%I in (..) do set PROJECT_ROOT=%%~fI

:: Step 1: Collect data from APIs
echo    Step 1/3: Collecting from API servers...
cd /d "%PROJECT_ROOT%\scripts"
python collect_api_jobs.py
if %ERRORLEVEL% neq 0 (
    echo [91m❌ Failed to collect data from APIs[0m
    pause
    exit /b 1
)

:: Step 2: Copy to visualization folder
echo    Step 2/3: Copying data to visualization folder...
cd /d "%PROJECT_ROOT%"

:: Remove old data
if exist "visualization\api_jobs" (
    rmdir /s /q "visualization\api_jobs"
)

:: Copy new data
xcopy /E /I /Y "result\api_jobs" "visualization\api_jobs" >nul

:: Count files
set count=0
for %%f in (visualization\api_jobs\jobs\*.json) do set /a count+=1
echo    [92m✅ Copied %count% job files[0m

:: Step 3: Show summary
echo    Step 3/3: Update complete!
echo.
echo [96m📊 Data Summary:[0m
echo    - by_dataset.json: copied
echo    - datasets.json: copied  
echo    - jobs/*.json: %count% files
echo.

:: Git reminder
echo [93m💡 Next steps:[0m
echo    git add visualization/api_jobs/
echo    git commit -m "Update training data"
echo    git push origin main
echo.
echo [92m🎉 Done![0m
echo.

pause
