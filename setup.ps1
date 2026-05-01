# ============================================================
# Retail dbt Lab - One-time Setup Script
# Run this once in VS Code terminal to get everything ready
# ============================================================

Write-Host "`n>>> Step 1: Creating Python virtual environment..." -ForegroundColor Cyan
python -m venv venv

Write-Host "`n>>> Step 2: Activating virtual environment..." -ForegroundColor Cyan
.\venv\Scripts\Activate.ps1

Write-Host "`n>>> Step 3: Installing dbt-snowflake..." -ForegroundColor Cyan
pip install -r requirements.txt

Write-Host "`n>>> Step 4: Installing dbt packages (dbt_utils)..." -ForegroundColor Cyan
dbt deps --profiles-dir .

Write-Host "`n>>> Step 5: Testing Snowflake connection..." -ForegroundColor Cyan
dbt debug --profiles-dir .

Write-Host "`n Setup complete!" -ForegroundColor Green
Write-Host "You can now run dbt commands from the VS Code terminal." -ForegroundColor Green
Write-Host "Use Ctrl+Shift+P -> 'Tasks: Run Task' to use the built-in task runner.`n" -ForegroundColor Yellow
