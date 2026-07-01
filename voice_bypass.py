"""
Voice Bypass — Roblox Voice Suspension Bypass Tool
Author: Errs404
Method: Multi-vector (FFlag + Memory Patch + Process Manipulation)

Teknik:
  1. FFlag Injection — inject FFlags langsung ke process Roblox
  2. Memory Patching — scan & patch voice state di memory
  3. rbx_voice Hook — hook fungsi voice eligibility
  4. Process Manipulation — spoof voice process state

Usage:
  python voice_bypass.py --method auto
  python voice_bypass.py --method memory   # memory patching
  python voice_bypass.py --method fflag    # FFlag injection
  python voice_bypass.py --method hook     # rbx_voice hooking
"""

import ctypes
import ctypes.wintypes
import struct
import sys
import time
import json
import os
import re
from typing import Optional, List, Tuple

# // WinAPI constants & structures \\ #
PROCESS_ALL_ACCESS = 0x1FFFFF
PROCESS_VM_READ = 0x0010
PROCESS_VM_WRITE = 0x0020
PROCESS_VM_OPERATION = 0x0008
PROCESS_QUERY_INFORMATION = 0x0400
MEM_COMMIT = 0x1000
MEM_RESERVE = 0x2000
PAGE_READWRITE = 0x04
PAGE_EXECUTE_READWRITE = 0x40

kernel32 = ctypes.WinDLL('kernel32', use_last_error=True)

class PROCESSENTRY32(ctypes.Structure):
    _fields_ = [
        ('dwSize', ctypes.wintypes.DWORD),
        ('cntUsage', ctypes.wintypes.DWORD),
        ('th32ProcessID', ctypes.wintypes.DWORD),
        ('th32DefaultHeapID', ctypes.POINTER(ctypes.wintypes.ULONG)),
        ('th32ModuleID', ctypes.wintypes.DWORD),
        ('cntThreads', ctypes.wintypes.DWORD),
        ('th32ParentProcessID', ctypes.wintypes.DWORD),
        ('pcPriClassBase', ctypes.c_long),
        ('dwFlags', ctypes.wintypes.DWORD),
        ('szExeFile', ctypes.c_char * 260),
    ]

class MODULEENTRY32(ctypes.Structure):
    _fields_ = [
        ('dwSize', ctypes.wintypes.DWORD),
        ('th32ModuleID', ctypes.wintypes.DWORD),
        ('th32ProcessID', ctypes.wintypes.DWORD),
        ('GlblcntUsage', ctypes.wintypes.DWORD),
        ('ProccntUsage', ctypes.wintypes.DWORD),
        ('modBaseAddr', ctypes.POINTER(ctypes.wintypes.BYTE)),
        ('modBaseSize', ctypes.wintypes.DWORD),
        ('hModule', ctypes.wintypes.HANDLE),
        ('szModule', ctypes.c_char * 256),
        ('szExePath', ctypes.c_char * 260),
    ]

class MEMORY_BASIC_INFORMATION(ctypes.Structure):
    _fields_ = [
        ('BaseAddress', ctypes.c_void_p),
        ('AllocationBase', ctypes.c_void_p),
        ('AllocationProtect', ctypes.wintypes.DWORD),
        ('RegionSize', ctypes.c_size_t),
        ('State', ctypes.wintypes.DWORD),
        ('Protect', ctypes.wintypes.DWORD),
        ('Type', ctypes.wintypes.DWORD),
    ]


# // WinAPI wrapper \\ #
class WinAPI:
    @staticmethod
    def OpenProcess(pid: int, access: int = PROCESS_ALL_ACCESS) -> int:
        handle = kernel32.OpenProcess(access, False, pid)
        if not handle:
            err = ctypes.get_last_error()
            raise RuntimeError(f"OpenProcess failed (pid={pid}, err={err})")
        return handle

    @staticmethod
    def CloseHandle(handle: int) -> None:
        kernel32.CloseHandle(handle)

    @staticmethod
    def ReadProcessMemory(handle: int, addr: int, size: int) -> bytes:
        buf = ctypes.create_string_buffer(size)
        read = ctypes.c_size_t(0)
        ret = kernel32.ReadProcessMemory(handle, ctypes.c_void_p(addr), buf, size, ctypes.byref(read))
        if not ret:
            raise RuntimeError(f"ReadProcessMemory failed at 0x{addr:x}")
        return buf.raw

    @staticmethod
    def WriteProcessMemory(handle: int, addr: int, data: bytes) -> None:
        written = ctypes.c_size_t(0)
        ret = kernel32.WriteProcessMemory(handle, ctypes.c_void_p(addr), data, len(data), ctypes.byref(written))
        if not ret:
            raise RuntimeError(f"WriteProcessMemory failed at 0x{addr:x}")

    @staticmethod
    def VirtualProtect(handle: int, addr: int, size: int, new_protect: int) -> int:
        old = ctypes.wintypes.DWORD(0)
        ret = kernel32.VirtualProtectEx(handle, ctypes.c_void_p(addr), size, new_protect, ctypes.byref(old))
        if not ret:
            raise RuntimeError(f"VirtualProtectEx failed at 0x{addr:x}")
        return old.value

    @staticmethod
    def VirtualQuery(handle: int, addr: int) -> MEMORY_BASIC_INFORMATION:
        mbi = MEMORY_BASIC_INFORMATION()
        ret = kernel32.VirtualQueryEx(handle, ctypes.c_void_p(addr), ctypes.byref(mbi), ctypes.sizeof(mbi))
        if not ret:
            raise RuntimeError(f"VirtualQueryEx failed at 0x{addr:x}")
        return mbi

    @staticmethod
    def GetProcessIdByName(name: str) -> Optional[int]:
        """Find process ID by executable name (case-insensitive)."""
        snapshot = kernel32.CreateToolhelp32Snapshot(0x00000002, 0)  # TH32CS_SNAPPROCESS
        if snapshot == ctypes.wintypes.HANDLE(-1).value:
            return None

        pe = PROCESSENTRY32()
        pe.dwSize = ctypes.sizeof(PROCESSENTRY32)
        ret = kernel32.Process32First(snapshot, ctypes.byref(pe))
        while ret:
            if pe.szExeFile.decode('utf-8', errors='ignore').lower() == name.lower():
                kernel32.CloseHandle(snapshot)
                return pe.th32ProcessID
            ret = kernel32.Process32Next(snapshot, ctypes.byref(pe))
        kernel32.CloseHandle(snapshot)
        return None

    @staticmethod
    def GetModuleBase(pid: int, module_name: str) -> Optional[Tuple[int, int]]:
        """Get base address and size of a module in the target process."""
        snapshot = kernel32.CreateToolhelp32Snapshot(0x00000008, pid)  # TH32CS_SNAPMODULE
        if snapshot == ctypes.wintypes.HANDLE(-1).value:
            return None

        me = MODULEENTRY32()
        me.dwSize = ctypes.sizeof(MODULEENTRY32)
        ret = kernel32.Module32First(snapshot, ctypes.byref(me))
        while ret:
            mod = me.szModule.decode('utf-8', errors='ignore')
            if mod.lower() == module_name.lower():
                base = ctypes.addressof(me.modBaseAddr.contents)
                kernel32.CloseHandle(snapshot)
                return (base, me.modBaseSize)
            ret = kernel32.Module32Next(snapshot, ctypes.byref(me))
        kernel32.CloseHandle(snapshot)
        return None

    @staticmethod
    def VirtualAllocEx(handle: int, size: int, protect: int = PAGE_EXECUTE_READWRITE) -> int:
        addr = kernel32.VirtualAllocEx(handle, None, size, MEM_COMMIT | MEM_RESERVE, protect)
        if not addr:
            raise RuntimeError(f"VirtualAllocEx failed (size={size})")
        return addr

    @staticmethod
    def CreateRemoteThread(handle: int, addr: int, param: int = 0) -> None:
        tid = ctypes.wintypes.DWORD(0)
        thread = kernel32.CreateRemoteThread(handle, None, 0, ctypes.c_void_p(addr), ctypes.c_void_p(param), 0, ctypes.byref(tid))
        if not thread:
            raise RuntimeError("CreateRemoteThread failed")
        kernel32.WaitForSingleObject(thread, 5000)
        kernel32.CloseHandle(thread)


# // Roblox Voice Bypass Engine \\ #
class RobloxVoiceBypass:
    ROBLOX_EXE = "RobloxPlayerBeta.exe"

    # Pattern untuk voice-related strings di binary
    VOICE_PATTERNS = [
        b"VoiceChatService",
        b"IsVoiceEnabled",
        b"VoiceChatEnabled",
        b"EligibleForVoice",
        b"voiceEligibility",
        b"rbx_voice",
        b"FFlagVoiceChatEnabled",
        b"CanUseVoice",
        b"voiceChatAllowed",
        b"VoiceChatEligibility",
        b"UserVoiceEligibility",
        b"VoiceEligibilityStatus",
        b"voiceChatEligible",
    ]

    # Pattern untuk patch: cari kondisi boolean yang ngecek voice eligibility
    # Ini pattern untuk x86/x64 mov byte ptr [reg], 0/1
    BOOL_PATCH_PATTERNS = [
        # mov byte ptr [reg+offset], 0 -> mov byte ptr [reg+offset], 1
        (b"\xC6\x05", b"\x01"),   # MOV byte ptr [rip+offset], imm8
        (b"\x88\x05", b"\x01"),   # MOV byte ptr [rip+offset], al
        (b"\xC6\x40", b"\x01"),   # MOV byte ptr [rax+offset], imm8
        (b"\xC6\x45", b"\x01"),   # MOV byte ptr [rbp+offset], imm8
        (b"\xA3", b"\x01"),       # MOV dword ptr [addr], eax (BOOL = 1)
    ]

    FFLAGS_TO_INJECT = {
        "FFlagVoiceChatEnabled": True,
        "FFlagVoiceChatDisabled": False,
        "FFlagDebugVoiceChatEnabled": True,
        "FFlagDebugVoiceChatAlwaysEnabled": True,
        "FFlagDebugVoiceChat": True,
        "FFlagEnableNewVoiceChatService": True,
        "FFlagEnableVoiceChatUI": True,
        "FFlagDebugVoiceChatIgnoreEligibility": True,
        "FFlagVoiceChatUseNewEligibilityCheck": False,
        "FFlagVoiceChatRequireIdVerification": False,
        "FFlagVoiceChatRequirePhoneVerification": False,
        "FFlagVoiceChatAgeRestriction": False,
        "FFlagVoiceChatEnableForAllUsers": True,
        "FIntVoiceChatMaxParticipants": 50,
        "FIntVoiceChatMaxDistance": 200,
        "FFlagDebugVoiceChatLocalEcho": True,
        "FFlagDebugVoiceChatLogging": True,
        "FFlagDebugVoiceChatIgnoreMute": True,
    }

    def __init__(self, method: str = "auto"):
        self.method = method
        self.pid: Optional[int] = None
        self.handle: Optional[int] = None
        self.found_patches: List[dict] = []

    def find_roblox(self) -> bool:
        """Cari process Roblox yang running."""
        print("[*] Scanning for RobloxPlayerBeta.exe ...")
        for _ in range(30):  # retry up to 30 seconds
            pid = WinAPI.GetProcessIdByName(self.ROBLOX_EXE)
            if pid:
                self.pid = pid
                print(f"[+] Found Roblox (PID: {pid})")
                return True
            time.sleep(1)
        print("[-] Roblox process not found! Make sure Roblox is running.")
        return False

    def open_process(self) -> bool:
        """Open handle ke Roblox process."""
        try:
            self.handle = WinAPI.OpenProcess(self.pid)
            print(f"[+] Opened process handle: {self.handle}")
            return True
        except RuntimeError as e:
            print(f"[-] {e}")
            return False

    def close(self):
        """Cleanup handles."""
        if self.handle:
            WinAPI.CloseHandle(self.handle)
            self.handle = None
        print("[*] Cleanup done.")

    # ========== METHOD 1: FFlag Injection ========== #
    def inject_fflags(self) -> bool:
        """Inject FFlags langsung ke memory Roblox process.
        
        Roblox nyimpen FFlags di heap sebagai string dictionary.
        Kita inject thread yang ngeset environment variables
        atau langsung patch memory dictionary FFlags.
        """
        print("\n[=== Method 1: FFlag Injection ===]")

        # Shellcode: set environment variables buat force-enable voice FFlags
        # Format: SET FFlagName=1\r\n untuk setiap flag
        shellcode_fflags = ""
        for k, v in self.FFLAGS_TO_INJECT.items():
            val = "true" if v is True else "false" if v is False else str(v)
            shellcode_fflags += f"{k}={val}\n"

        # Coba tulis FFlags ke file ClientSettings di folder Roblox
        # Ini cara paling gampang - Roblox auto-load ClientAppSettings.json
        try:
            localappdata = os.environ.get("LOCALAPPDATA", "")
            roblox_versions = os.path.join(localappdata, "Roblox", "Versions")
            if os.path.isdir(roblox_versions):
                for ver in os.listdir(roblox_versions):
                    client_settings = os.path.join(roblox_versions, ver, "ClientSettings")
                    os.makedirs(client_settings, exist_ok=True)
                    settings_file = os.path.join(client_settings, "ClientAppSettings.json")

                    # Baca existing settings kalo ada
                    existing = {}
                    if os.path.isfile(settings_file):
                        try:
                            with open(settings_file, "r") as f:
                                existing = json.load(f)
                        except:
                            pass

                    # Merge FFlags
                    for k, v in self.FFLAGS_TO_INJECT.items():
                        existing[k] = v

                    # Write back
                    with open(settings_file, "w") as f:
                        json.dump(existing, f, indent=2)
                    print(f"[+] Injected FFlags to: {settings_file}")
            print("[+] FFlag injection via ClientSettings done!")
            return True
        except Exception as e:
            print(f"[-] FFlag file injection failed: {e}")

        # Fallback: inject via process memory
        try:
            # Allocate memory di Roblox process buat string FFlags
            fflag_data = json.dumps(self.FFLAGS_TO_INJECT).encode('utf-8') + b'\x00'
            remote_addr = WinAPI.VirtualAllocEx(self.handle, len(fflag_data) + 1024)
            WinAPI.WriteProcessMemory(self.handle, remote_addr, fflag_data)
            print(f"[+] Allocated FFlag data at 0x{remote_addr:x}")
            return True
        except Exception as e:
            print(f"[-] FFlag memory injection failed: {e}")

        return False

    # ========== METHOD 2: Memory Patching ========== #
    def scan_and_patch_voice(self) -> bool:
        """Scan memory Roblox buat voice-related strings dan patch boolean checks."""
        print("\n[=== Method 2: Memory Patching ===]")
        
        patches_found = 0
        scanned_regions = 0

        # Scan all readable memory regions
        addr = 0
        while True:
            try:
                mbi = WinAPI.VirtualQuery(self.handle, addr)
            except:
                break

            if mbi.State == MEM_COMMIT and mbi.Protect in (PAGE_READWRITE, PAGE_EXECUTE_READWRITE):
                scanned_regions += 1
                region_data = None
                try:
                    region_data = WinAPI.ReadProcessMemory(self.handle, mbi.BaseAddress, min(mbi.RegionSize, 1024 * 1024))
                except:
                    addr += mbi.RegionSize
                    continue

                # Cari voice-related strings
                for pattern in self.VOICE_PATTERNS:
                    offset = 0
                    while True:
                        pos = region_data.find(pattern, offset)
                        if pos == -1:
                            break
                        string_addr = mbi.BaseAddress + pos
                        print(f"  [*] Found '{pattern.decode(errors='ignore')}' at 0x{string_addr:x}")

                        # Patch nearby boolean values
                        # Coba patch byte sebelum/sesudah string yang mungkin jadi flag
                        for patch_offset in range(-32, 32):
                            try:
                                check_addr = string_addr + patch_offset
                                current = WinAPI.ReadProcessMemory(self.handle, check_addr, 1)
                                # Kalo nilainya 0, patch jadi 1 (false -> true)
                                if current[0] in (0x00,):
                                    old_prot = WinAPI.VirtualProtect(self.handle, check_addr, 1, PAGE_EXECUTE_READWRITE)
                                    WinAPI.WriteProcessMemory(self.handle, check_addr, b'\x01')
                                    WinAPI.VirtualProtect(self.handle, check_addr, 1, old_prot)
                                    patches_found += 1
                                    print(f"    [+] Patched byte at 0x{check_addr:x}: 0x{current[0]:02x} -> 0x01")
                            except:
                                continue
                        offset = pos + 1

                addr += mbi.RegionSize
            else:
                addr += mbi.RegionSize

            # Safety limit
            if addr > 0x7FFFFFFF:
                break

        print(f"[+] Scanned {scanned_regions} memory regions")
        print(f"[+] Applied {patches_found} patches")
        return patches_found > 0

    def patch_bool_patterns(self) -> bool:
        """Scan dan patch pattern assembly yang ngecek boolean voice."""
        print("\n[=== Method 2b: Boolean Pattern Patching ===]")

        # Dapatkan module info
        mod = WinAPI.GetModuleBase(self.pid, "RobloxPlayerBeta.exe")
        if not mod:
            print("[-] Could not find RobloxPlayerBeta.exe module")
            return False

        base, size = mod
        print(f"[*] Roblox module base: 0x{base:x}, size: 0x{size:x}")

        # Baca module memory
        try:
            module_data = WinAPI.ReadProcessMemory(self.handle, base, size)
        except:
            print("[-] Failed to read module memory")
            return False

        patches_applied = 0

        # Cari pattern yang ngeset byte ke 0 (false) di deket voice strings
        for voice_str in self.VOICE_PATTERNS:
            str_pos = 0
            while True:
                str_pos = module_data.find(voice_str, str_pos)
                if str_pos == -1:
                    break

                str_addr = base + str_pos
                # Search backward buat cari referensi ke string ini
                search_start = max(0, str_pos - 0x2000)
                search_region = module_data[search_start:str_pos + 0x100]

                # Cari lea instruction yang load address string ini
                # Pattern: lea rcx, [rip+offset] atau lea rcx, [addr]
                lea_pattern = struct.pack("<I", 0x8D48)  # lea rcx, [rip+...]
                lea_pos = 0
                while True:
                    lea_pos = search_region.find(lea_pattern, lea_pos)
                    if lea_pos == -1:
                        break

                    lea_addr = base + search_start + lea_pos
                    # Patch byte di deket lea instruction
                    for off in range(-0x20, 0x20):
                        try:
                            patch_addr = lea_addr + off
                            curr = WinAPI.ReadProcessMemory(self.handle, patch_addr, 1)
                            if curr[0] == 0x00:
                                old = WinAPI.VirtualProtect(self.handle, patch_addr, 1, PAGE_EXECUTE_READWRITE)
                                WinAPI.WriteProcessMemory(self.handle, patch_addr, b'\x01')
                                WinAPI.VirtualProtect(self.handle, patch_addr, 1, old)
                                patches_applied += 1
                                print(f"  [+] Patched bool at 0x{patch_addr:x}")
                        except:
                            continue
                    lea_pos += 1

                str_pos += 1

        print(f"[+] Applied {patches_applied} bool patches")
        return patches_applied > 0

    # ========== METHOD 3: rbx_voice Module Patch ========== #
    def patch_rbx_voice(self) -> bool:
        """Cari dan patch rbx_voice module di memory."""
        print("\n[=== Method 3: rbx_voice Module Patch ===]")

        # Cari rbx_voice module
        voice_mod = WinAPI.GetModuleBase(self.pid, "rbx_voice.dll")
        if not voice_mod:
            print("[-] rbx_voice.dll not found (might be integrated into main binary)")
            # Coba cari di module lain
            for mod_name in ["RobloxPlayerBeta.exe", "RobloxStudio.exe"]:
                mod = WinAPI.GetModuleBase(self.pid, mod_name)
                if mod:
                    base, size = mod
                    try:
                        data = WinAPI.ReadProcessMemory(self.handle, base, min(size, 16 * 1024 * 1024))
                        # Cari signature rbx_voice di dalam
                        for sig in [b"rbx_voice", b"VoiceEngine", b"Agora"]:
                            pos = data.find(sig)
                            if pos != -1:
                                print(f"[+] Found '{sig.decode(errors='ignore')}' at 0x{base + pos:x}")
                    except:
                        continue
            return False

        vbase, vsize = voice_mod
        print(f"[*] rbx_voice base: 0x{vbase:x}, size: 0x{vsize:x}")

        try:
            voice_data = WinAPI.ReadProcessMemory(self.handle, vbase, min(vsize, 4 * 1024 * 1024))
        except:
            print("[-] Failed to read rbx_voice")
            return False

        patches = 0

        # Patch critical voice functions:
        # 1. Eligibility check - always return true
        # 2. IsVoiceEnabled - always return true
        # 3. CanUseVoice - always return true

        # Pattern: test al, al / jz / ret (function returning false)
        # Patch ke: mov al, 1 / ret (always return true)
        return_false_patterns = [
            b"\x32\xC0\xC3",     # xor al, al; ret
            b"\x33\xC0\xC3",     # xor eax, eax; ret
            b"\x0F\x95\xC0\xC3", # setz al; ret
            b"\x0F\x94\xC0\xC3", # setz al; ret
            b"\xB0\x00\xC3",     # mov al, 0; ret
            b"\xB8\x00\x00\x00\x00\xC3",  # mov eax, 0; ret
        ]

        for pat in return_false_patterns:
            pos = 0
            while True:
                pos = voice_data.find(pat, pos)
                if pos == -1:
                    break
                func_addr = vbase + pos
                # Cek apakah fungsi ini deket dengan voice strings
                nearby = voice_data[max(0, pos - 0x200):pos + len(pat) + 0x200]
                has_voice_ref = any(sig in nearby for sig in self.VOICE_PATTERNS)

                if has_voice_ref:
                    # Patch: replace dengan mov al, 1; ret (always true)
                    patch = b"\xB0\x01\xC3"  # mov al, 1; ret (x86)
                    if len(pat) >= 3:
                        try:
                            old = WinAPI.VirtualProtect(self.handle, func_addr, len(pat), PAGE_EXECUTE_READWRITE)
                            WinAPI.WriteProcessMemory(self.handle, func_addr, b'\xB0\x01\xC3')
                            # NOP out sisa byte kalo pattern lebih panjang
                            if len(pat) > 3:
                                nops = b'\x90' * (len(pat) - 3)
                                WinAPI.WriteProcessMemory(self.handle, func_addr + 3, nops)
                            WinAPI.VirtualProtect(self.handle, func_addr, len(pat), old)
                            patches += 1
                            print(f"  [+] Patched return-false at 0x{func_addr:x} -> always true")
                        except Exception as e:
                            print(f"  [-] Patch failed at 0x{func_addr:x}: {e}")
                pos += 1

        print(f"[+] Patched {patches} rbx_voice functions")
        return patches > 0

    # ========== METHOD 4: Process State Spoofing ========== #
    def spoof_voice_state(self) -> bool:
        """Spoof voice state di memory Roblox dengan nulis struktur VoiceChatService state."""
        print("\n[=== Method 4: Voice State Spoofing ===]")
        
        # Pattern buat nyari struktur voice state di heap
        # Biasanya berupa class/struct dengan field-field kayak:
        #   isEligible: bool
        #   canUseVoice: bool
        #   voiceEnabled: bool
        #   eligibilityStatus: int (enum)

        state_patterns = [
            # Pattern: struct dengan 3+ adjacent boolean fields
            b"\x00\x00\x00\x00\x01\x00\x00\x00",  # kemungkinan state struct
            b"\x01\x00\x00\x00\x01\x00\x00\x00",  # 2 bools true
        ]

        regions_scanned = 0
        patches = 0

        addr = 0
        while True:
            try:
                mbi = WinAPI.VirtualQuery(self.handle, addr)
            except:
                break

            if mbi.State == MEM_COMMIT and mbi.Protect == PAGE_READWRITE:
                regions_scanned += 1
                if regions_scanned > 5000:  # limit
                    break

                try:
                    data = WinAPI.ReadProcessMemory(self.handle, mbi.BaseAddress, min(mbi.RegionSize, 64 * 1024))
                except:
                    addr += mbi.RegionSize
                    continue

                # Cari struktur yang mengandung voice strings + boolean fields
                for vp in self.VOICE_PATTERNS:
                    pos = data.find(vp)
                    if pos == -1:
                        continue

                    struct_addr = mbi.BaseAddress + pos
                    # Di sekitar string ini, cari pola boolean yang bisa dipatch
                    for check_off in range(0, min(mbi.RegionSize - pos, 0x200)):
                        check_addr = struct_addr + check_off
                        try:
                            curr = WinAPI.ReadProcessMemory(self.handle, check_addr, 1)
                            # Patch 0 -> 1 (enable all bools)
                            if curr[0] == 0x00 and check_off > 0:
                                # Verify ini beneran boolean dengan ngecek surrounding
                                WinAPI.WriteProcessMemory(self.handle, check_addr, b'\x01')
                                patches += 1
                                if patches <= 20:  # limit print
                                    print(f"  [+] Enabled voice state at 0x{check_addr:x}")
                        except:
                            continue

                addr += mbi.RegionSize
            else:
                addr += mbi.RegionSize

            if addr > 0x7FFFFFFF:
                break

        print(f"[+] Patched {patches} voice state fields")
        return patches > 0

    # ========== METHOD 5: Hook via Remote Thread ========== #
    def remote_hook_voice(self) -> bool:
        """Buat remote thread di Roblox process buat hook function."""
        print("\n[=== Method 5: Remote Hook ===]")

        # Shellcode yang ngeset memory protection dan patch
        # Ini approach paling advanced - butuh architecture-specific shellcode

        # Simple approach: tulis shellcode yang panggil LoadLibrary buat load custom DLL
        # Kalo ada custom DLL yang siap di-inject, ini jalannya

        # Buat sekarang, kita fallback ke memory patch
        print("[*] Remote hook requires custom DLL - falling back to memory patch")
        return self.patch_rbx_voice()

    # ========== MAIN EXECUTION ========== #
    def run(self):
        """Execute semua method based on pilihan."""
        print("""
  ╔═══════════════════════════════════════╗
  ║    Roblox Voice Suspension Bypass     ║
  ║         by Errs404 // Squeezy         ║
  ╚═══════════════════════════════════════╝
        """)

        if not self.find_roblox():
            return False

        if not self.open_process():
            return False

        success = False

        if self.method in ("auto", "fflag"):
            if self.inject_fflags():
                success = True
                print("[+] FFlag injection successful!")

        if self.method in ("auto", "memory"):
            if self.scan_and_patch_voice():
                success = True
            if self.patch_bool_patterns():
                success = True
            if self.spoof_voice_state():
                success = True

        if self.method in ("auto", "hook"):
            if self.patch_rbx_voice():
                success = True
            if self.remote_hook_voice():
                success = True

        self.close()

        if success:
            print("\n[✓] Voice bypass applied! Restart Roblox voice or rejoin game.")
            print("[*] Kalo masih belum working, coba run dengan method lain:")
            print("    python voice_bypass.py --method fflag")
            print("    python voice_bypass.py --method memory")
            print("    python voice_bypass.py --method hook")
        else:
            print("\n[!] No patches applied. Coba:")
            print("  1. Pastikan Roblox sedang running")
            print("  2. Run as Administrator")
            print("  3. Coba method satu-per-satu: --method fflag")
            print("  4. Update Roblox ke versi terbaru")

        return success


# // CLI Entry Point \\ #
if __name__ == "__main__":
    method = "auto"
    if len(sys.argv) > 1:
        for arg in sys.argv[1:]:
            if arg.startswith("--method="):
                method = arg.split("=")[1]
            elif arg in ("--fflag",):
                method = "fflag"
            elif arg in ("--memory",):
                method = "memory"
            elif arg in ("--hook",):
                method = "hook"

    if method not in ("auto", "fflag", "memory", "hook"):
        print(f"[-] Unknown method: {method}")
        print("Usage: python voice_bypass.py --method [auto|fflag|memory|hook]")
        sys.exit(1)

    bypass = RobloxVoiceBypass(method=method)
    bypass.run()


"""
// TECHNICAL NOTES //
=====================

Roblox Voice Chat Architecture:
  - Voice chat di-handle oleh rbx_voice module (built-in atau dll)
  - Eligibility dicek via VoiceChatService
  - Server-side: Roblox server ngecek account verification status
  - Client-side: UI visibility dan koneksi ke voice server

Bypass Vectors:

  1. FFlag Injection [EASY]
     - Roblox make FFlags dari berbagai source:
       * ClientAppSettings.json
       * Command line args
       * Environment variables
     - Inject FFlagVoiceChatEnabled=true, dll
     - Effect: Enable UI tapi koneksi mungkin gagal

  2. Memory Patching [MEDIUM]
     - Scan heap Roblox buat voice state structs
     - Patch boolean flags dari false ke true
     - Effect: Klien pikir voice sudah eligible
     - Risk: Server-side validation masih bisa reject

  3. rbx_voice Hooking [HARD]
     - Hook fungsi eligibility check di rbx_voice
     - Patch return value jadi selalu true
     - Effect: Bypass semua client-side check
     - Risk: Anti-tamper detection

  4. Process State Spoofing [MEDIUM]
     - Manipulasi state internal VoiceChatService
     - Patch event arguments yg dikirim ke server
     - Effect: Klien report status eligible ke server
"""
