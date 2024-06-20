@echo off
setlocal

echo Compiling...

rmdir /S /Q build 2>nul
mkdir dist 2>nul
mkdir build

set "AHK=C:\Program Files\AutoHotkey"
set "BASE=AutoHotkeyU64.exe"

copy "%AHK%\Compiler\Ahk2Exe.exe" .
copy "%AHK%\%BASE%" .

Ahk2Exe.exe /base %BASE% /in "neo-mousekeys.ahk" /out "build\neo-mousekeys.exe"

if %errorlevel% equ 0 (
    echo Compilation successful.
) else (
    echo Compilation failed.
)

echo Copying additional files...
echo:
echo Copying options.ini...
xcopy /Q options.ini build

del "Ahk2Exe.exe"
del "%BASE%"

echo Zipping...
echo:
set "INPUT=build"
set /p VERSION=<version
set "OUTPUT=neo-mousekeys-v%VERSION%.zip"
@REM powershell -command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%INPUT%', '%OUTPUT%')"
@REM powershell -Command "$compress = @{ Path = '%INPUT%'; CompressionLevel = 'NoCompression'; DestinationPath = '%OUTPUT%' }; Compress-Archive @compress"
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx0 %OUTPUT% ".\%INPUT%\*"

echo:
echo Hashes (%OUTPUT%):
for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% MD5)[1]"') do set "MD5=%%a"
echo MD5: %MD5%
for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% SHA1)[1]"') do set "SHA1=%%a"
echo SHA1: %SHA1%
for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% SHA256)[1]"') do set "SHA256=%%a"
echo SHA256: %SHA256%
echo VirusTotal : https://www.virustotal.com/gui/file/%SHA256%

echo:
move %OUTPUT% dist

echo Done.
echo:

pause