@echo off
if "%CLANG_FORMAT_BIN%"=="" set "CLANG_FORMAT_BIN=clang-format"
set "FORMAT_ARGS=-i"
if "%~1"=="--check" set "FORMAT_ARGS=--dry-run --Werror"
if not "%~1"=="" if not "%~1"=="--check" (
    echo Usage: format.bat [--check]
    exit /b 2
)
cd vita3k
for /f %%f in ('dir *.cpp *.h /b/s') do "%CLANG_FORMAT_BIN%" %FORMAT_ARGS% "%%f"
cd ..\tools
for /f %%f in ('dir *.cpp *.h /b/s') do "%CLANG_FORMAT_BIN%" %FORMAT_ARGS% "%%f"
cd ..
