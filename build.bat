@echo off
rmdir /S /Q bin
if "%1"=="--standalone" (dotnet publish -o bin -r win-x64 -c Release --nologo /p:PublishSingleFile=true /p:PublishTrimmed=true) else (dotnet publish -o bin -c Release --nologo)