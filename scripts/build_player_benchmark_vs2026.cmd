@echo off
setlocal

cd /d "%~dp0.."
call "C:\Program Files\Microsoft Visual Studio\18\Insiders\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit /b %errorlevel%

set CONFIG=%~1
if "%CONFIG%"=="" set CONFIG=Release

cmake --build build\vs2026-x64-d --config %CONFIG% --target mongo_player_benchmark --parallel 4
