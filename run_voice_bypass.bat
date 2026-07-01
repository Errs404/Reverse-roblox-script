@echo off
title Roblox Voice Bypass — Errs404/Squeezy
cd /d "%~dp0"

:MENU
cls
echo.
echo  ╔═══════════════════════════════════════╗
echo  ║    Roblox Voice Suspension Bypass     ║
echo  ║         by Errs404 // Squeezy         ║
echo  ╚═══════════════════════════════════════╝
echo.
echo  [1] Full Auto Bypass (all methods)
echo  [2] FFlag Injection Only
echo  [3] Memory Patching Only
echo  [4] rbx_voice Hooking Only
echo  [5] Inject Lua V1 (executor required)
echo  [6] Inject Lua V2 — AGGRESSIVE (executor required)
echo  [7] Unpatch / Restore Defaults
echo  [8] Exit
echo.
set /p choice="Select option [1-8]: "

if "%choice%"=="1" goto AUTO
if "%choice%"=="2" goto FFLAG
if "%choice%"=="3" goto MEMORY
if "%choice%"=="4" goto HOOK
if "%choice%"=="5" goto LUA
if "%choice%"=="6" goto LUAV2
if "%choice%"=="7" goto RESTORE
if "%choice%"=="8" goto EXIT
goto MENU

:AUTO
cls
echo [*] Running full auto bypass...
python voice_bypass.py --method auto
echo.
echo [*] Also inject Lua via executor for full coverage
pause
goto MENU

:FFLAG
cls
echo [*] Running FFlag injection...
python voice_bypass.py --method fflag
pause
goto MENU

:MEMORY
cls
echo [*] Running memory patching...
python voice_bypass.py --method memory
pause
goto MENU

:HOOK
cls
echo [*] Running rbx_voice hooking...
python voice_bypass.py --method hook
pause
goto MENU

:LUA
cls
echo.
echo  ===== LUA SCRIPT V1 =====
echo.
echo  Inject via executor. V1 = public API hooking.
echo.
echo  loadstring(readfile("voice_bypass.lua"))()
echo.
echo  Atau copy paste dari voice_bypass.lua
echo.
pause
goto MENU

:LUAV2
cls
echo.
echo  ===== LUA SCRIPT V2 — AGGRESSIVE MODE =====
echo.
echo  Inject via executor. V2 = deep GC + upvalue + manual UI.
echo.
echo  loadstring(readfile("voice_bypass_v2.lua"))()
echo.
echo  Atau copy paste dari voice_bypass_v2.lua
echo.
echo  FITUR V2:
echo  - Deep GC upvalue patch (patch closures internal)
echo  - CoreScript env injection (inject langsung ke module state)
echo  - Manual mic button creator (bikin UI mic dari 0)
echo  - Aggressive heap scan (patch semua boolean voice-related)
echo  - Persistent loop (tiap frame force state)
echo  - Audio capture hook
echo.
pause
goto MENU

:RESTORE
cls
echo [*] Restoring default voice state...
echo.
echo  Untuk restore:
echo  1. Tutup Roblox完全
echo  2. Hapus file ClientAppSettings.json di:
echo     %%localappdata%%\Roblox\Versions\*\ClientSettings\
echo  3. Buka Roblox lagi
echo.
echo  Atau run ini:
python -c "
import os, json, glob
localappdata = os.environ.get('LOCALAPPDATA', '')
pattern = os.path.join(localappdata, 'Roblox', 'Versions', '*', 'ClientSettings', 'ClientAppSettings.json')
for f in glob.glob(pattern):
    try:
        with open(f, 'r') as fp:
            data = json.load(fp)
        # Remove voice-related FFlags
        keys_to_remove = [k for k in data if 'voice' in k.lower() or 'Voice' in k]
        for k in keys_to_remove:
            del data[k]
        with open(f, 'w') as fp:
            json.dump(data, fp, indent=2)
        print(f'Cleaned: {f} (removed {len(keys_to_remove)} keys)')
    except: pass
"
pause
goto MENU

:EXIT
exit /b 0
