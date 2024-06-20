@echo off
setlocal

echo Compiling...

rmdir /S /Q build 2>nul
timeout /t 2 /nobreak 1>nul

mkdir dist 2>nul
mkdir build

set "AHK=C:\Program Files\AutoHotkey"
set "BASE=AutoHotkeyU64.exe"

copy "%AHK%\Compiler\Ahk2Exe.exe" .
copy "%AHK%\%BASE%" .

set "PROJECT=neo-mousekeys"

Ahk2Exe.exe /base %BASE% /in "%PROJECT%.ahk" /out "build\%PROJECT%.exe"

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
set "OUTPUT=%PROJECT%-v%VERSION%.zip"
@REM powershell -command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::CreateFromDirectory('%INPUT%', '%OUTPUT%')"
@REM powershell -Command "$compress = @{ Path = '%INPUT%'; CompressionLevel = 'NoCompression'; DestinationPath = '%OUTPUT%' }; Compress-Archive @compress"
"C:\Program Files\7-Zip\7z.exe" a -tzip -mx0 %OUTPUT% ".\%INPUT%\*"

for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% MD5)[1]"') do set "MD5=%%a"
for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% SHA1)[1]"') do set "SHA1=%%a"
for /f %%a in ('powershell -command "(certutil -hashfile %OUTPUT% SHA256)[1]"') do set "SHA256=%%a"

echo:
move %OUTPUT% dist

echo Done compiling.
echo:

set "HASHES=Hashes (%OUTPUT%): & echo MD5: %MD5% & echo SHA1: %SHA1% & echo SHA256: %SHA256%"

setlocal enabledelayedexpansion

set /p choice="Upload 'dist/%OUTPUT%' to VirusTotal? (y/n): "

if /i "!choice!"=="y" (
  if defined VT_API_KEY (
    curl --request POST ^
         --url https://www.virustotal.com/api/v3/files ^
         --header "accept: application/json" ^
         --header "content-type: multipart/form-data" ^
         --header "x-apikey: %VT_API_KEY%" ^
         --form "file=@dist/%OUTPUT%"

    echo:
    echo:
    echo File uploaded to VirusTotal.
    set "HASHES=%HASHES% & echo VirusTotal: https://www.virustotal.com/gui/file/%SHA256%"
    echo:
  ) else (
  echo Error: VT_API_KEY is not set in PATH.
  )
) else (
    echo No files were uploaded to VirusTotal.
)

echo:
echo %HASHES%
cmd /c "echo %HASHES%" | clip

echo:

set /p choice="Open explorer and GitHub? (y/n): "

set "BROWSER=C:\Progra~1\Google\Chrome\Application\chrome.exe"
set "URL=https://github.com/vieuxtemps/%PROJECT%/releases/new"

if /i "!choice!"=="y" (
  explorer.exe dist
  timeout /t 1 /nobreak 1>nul
  start "" %BROWSER% %URL%
)

echo Done.
echo:
pause