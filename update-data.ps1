#!/usr/bin/env pwsh
# Update training data from API servers
# Run from visualization folder: .\update-data.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "🔄 Updating training data from API servers..." -ForegroundColor Cyan

# Step 1: Collect data from APIs
Write-Host "   Step 1/3: Collecting from API servers..." -ForegroundColor Gray
cd "$ProjectRoot\scripts"
python collect_api_jobs.py
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to collect data from APIs" -ForegroundColor Red
    exit 1
}

# Step 2: Copy to visualization folder
Write-Host "   Step 2/3: Copying data to visualization folder..." -ForegroundColor Gray
cd $ProjectRoot

# Remove old data
if (Test-Path "visualization\api_jobs") {
    Remove-Item -Recurse -Force "visualization\api_jobs"
}

# Copy new data
Copy-Item -Recurse -Force "result\api_jobs" "visualization\api_jobs"

# Count files
$jobCount = (Get-ChildItem "visualization\api_jobs\jobs\*.json" -ErrorAction SilentlyContinue).Count
Write-Host "   ✅ Copied $jobCount job files" -ForegroundColor Green

# Step 3: Show summary
Write-Host "   Step 3/3: Update complete!" -ForegroundColor Gray
Write-Host ""
Write-Host "📊 Data Summary:" -ForegroundColor Cyan
Write-Host "   - by_dataset.json: $(Test-Path "visualization\api_jobs\by_dataset.json")" -ForegroundColor Gray
Write-Host "   - datasets.json: $(Test-Path "visualization\api_jobs\datasets.json")" -ForegroundColor Gray
Write-Host "   - jobs/*.json: $jobCount files" -ForegroundColor Gray
Write-Host ""

# Optional: Git operations
$doGit = Read-Host "Push to GitHub? (y/n) [default: n]"
if ($doGit -eq 'y' -or $doGit -eq 'Y') {
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Cyan
    git add visualization/api_jobs/
    git commit -m "Update training data: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    Write-Host "✅ Pushed! Vercel will auto-deploy." -ForegroundColor Green
} else {
    Write-Host "💡 Remember to push manually:" -ForegroundColor Yellow
    Write-Host "   git add visualization/api_jobs/" -ForegroundColor Gray
    Write-Host "   git commit -m 'Update training data'" -ForegroundColor Gray
    Write-Host "   git push origin main" -ForegroundColor Gray
}

Write-Host ""
Write-Host "🎉 Done!" -ForegroundColor Green
cd $PSScriptRoot
