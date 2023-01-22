import std/tables

import winim/lean

import azurebelt/modules/tbres
import azurebelt/modules/msal
import azurebelt/modules/vscode

proc entrypoint(args: varargs[LPCWSTR, `$`]): void {.cdecl, exportc, dynlib.} =  
  when not defined(release):
    AttachConsole(ATTACH_PARENT_PROCESS)

  let
    moduleTable = {
      "tbres": runTBRES,
      "msal": runMSAL,
      "vscode": runVSCode
    }.toTable()
  
  case ($args[0]):
    of "all":
      for module in moduleTable.values:
        echo module()
    else:
      if moduleTable.hasKey($args[0]):
        echo moduleTable[$args[0]]()
      else:
        echo "Unknown command: " & $args[0]

proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  return true