import winim/lean

import azurebelt/modules/tbres
import azurebelt/modules/msal

proc entrypoint(args: varargs[LPCWSTR]): int {.cdecl, exportc, dynlib.} =  
  when not defined(release):
    AttachConsole(ATTACH_PARENT_PROCESS)

  runMSAL()

proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  return true