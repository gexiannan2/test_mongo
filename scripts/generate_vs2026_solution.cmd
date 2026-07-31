@echo off
setlocal

cd /d "%~dp0.."

call "C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b %errorlevel%

cmake --preset windows-vs2026-x64
if errorlevel 1 exit /b %errorlevel%

echo.
echo Generated build\vs2026-x64-d\MongoStandalone.slnx
