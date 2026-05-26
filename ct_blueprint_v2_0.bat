@echo off
chcp 65001 >nul

title [Aki-chan AI Context Scaffolder v2.0]

echo =======================================================
echo  Aki-chan AI Context & Persona Provisioning v2.0
echo =======================================================
echo.

:: 1. Track Project Root
set "PROJECT_ROOT=%~dp0"
set "PROJECT_ROOT=%PROJECT_ROOT:~0,-1%"

echo [*] Target Directory: %PROJECT_ROOT%
echo [*] Downloading AI Blueprint Pack from GitHub...
echo.

:: 2. Download ZIP from GitHub Repository (Secure TLS 1.2 Forced)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; ^
     try { ^
         Invoke-WebRequest -Uri 'https://github.com/manouk12/blueprint/archive/refs/heads/main.zip' -OutFile '$env:TEMP\blueprint_main.zip' -ErrorAction Stop; ^
         Write-Host 'Success: Master package downloaded.' -ForegroundColor Green; ^
     } catch { ^
         Write-Error 'Error: Failed to download from GitHub. Please check internet connection.'; ^
         exit 1; ^
     }"
if %errorlevel% neq 0 (
    echo.
    echo [Error] Failed to download blueprint zip file.
    pause
    exit /b %errorlevel%
)

:: 3. Extract Master Zip to Temp Directory
echo [*] Extracting package...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { ^
         if (Test-Path '$env:TEMP\blueprint_temp') { Remove-Item -Path '$env:TEMP\blueprint_temp' -Recurse -Force | Out-Null }; ^
         Expand-Archive -Path '$env:TEMP\blueprint_main.zip' -DestinationPath '$env:TEMP\blueprint_temp' -Force -ErrorAction Stop; ^
         Write-Host 'Success: Extraction completed.' -ForegroundColor Green; ^
     } catch { ^
         Write-Error 'Error: Extraction failed.'; ^
         exit 1; ^
     }"
if %errorlevel% neq 0 (
    echo.
    echo [Error] Failed to extract blueprint package.
    pause
    exit /b %errorlevel%
)

:: 4. Copy templates & scripts to project root
echo [*] Injecting assets to your project...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "try { ^
         Copy-Item -Path '$env:TEMP\blueprint_temp\blueprint-main\templates' -Destination '%PROJECT_ROOT%' -Recurse -Force -ErrorAction Stop; ^
         Copy-Item -Path '$env:TEMP\blueprint_temp\blueprint-main\scripts' -Destination '%PROJECT_ROOT%' -Recurse -Force -ErrorAction Stop; ^
         Write-Host 'Success: Templates and scripts injected successfully.' -ForegroundColor Green; ^
     } catch { ^
         Write-Error 'Error: Failed to copy assets to project root.'; ^
         exit 1; ^
     }"
if %errorlevel% neq 0 (
    echo.
    echo [Error] Failed to copy template assets.
    pause
    exit /b %errorlevel%
)

:: 5. Execute Onboarding Bootstrapper
echo [*] Triggering AI Context Bootstrapper...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%PROJECT_ROOT%\scripts\bootstrap-blueprint.ps1" -ProjectRoot "%PROJECT_ROOT%"
if %errorlevel% neq 0 (
    echo.
    echo [Error] AI Bootstrapper execution failed.
    pause
    exit /b %errorlevel%
)

:: 6. Silent Cleanup Temp Assets
echo [*] Cleaning up temporary files...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Remove-Item -Path '$env:TEMP\blueprint_main.zip' -Force -ErrorAction SilentlyContinue; ^
     Remove-Item -Path '$env:TEMP\blueprint_temp' -Recurse -Force -ErrorAction SilentlyContinue"

echo.
echo =======================================================
echo  Success: AI Context and Persona Setup Completed!
echo  Double-click again whenever you need to refresh rules.
echo =======================================================
echo.

ping 127.0.0.1 -n 3 >nul
exit
