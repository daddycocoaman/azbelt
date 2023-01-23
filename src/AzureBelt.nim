import winim/lean

import azurebelt/modules/aadjoin
import azurebelt/modules/credman
import azurebelt/modules/environment
import azurebelt/modules/msal
import azurebelt/modules/tbres

type
  callback = proc(msg: LPCSTR, msglen: int): int {.cdecl.}

proc enter*(args: LPCSTR, bufferSize: int, cb: callback): int {.cdecl, exportc, dynlib.} =
  var output = ""

  case ($args):
    of "":
      output.add "Options - all, aadjoin, credman, env, tbres, msal"
    of "all":
      output.add runAADJoin()
      output.add runEnvironment()
      output.add runTBRES()
      output.add runMSAL()
      output.add runCredman()
    of "aadjoin":
      output.add runAADJoin()
    of "credman":
      output.add runCredman()
    of "env":
      output.add runEnvironment()
    of "tbres":
      output.add runTBRES()
    of "msal":
      output.add runMSAL()
    else:
        output.add "Unknown command: " & $args
  discard cb(output, output.len)
  return 0  

proc go*(args: varargs[LPCWSTR]): void {.cdecl, exportc, dynlib.} =  
  when not defined(release):
    AttachConsole(ATTACH_PARENT_PROCESS)

  case ($args[0]):
    of "all":
      echo runAADJoin()
      echo runEnvironment()
      echo runTBRES()
      echo runMSAL()
      echo runCredman()
    of "aadjoin":
      echo runAADJoin()
    of "credman":
      echo runCredman()
    of "env":
      echo runEnvironment()
    of "tbres":
      echo runTBRES()
    of "msal":
      echo runMSAL()
    else:
        echo "Unknown command: " & $args[0]

proc NimMain() {.cdecl, importc.}

proc DllMain(hinstDLL: HINSTANCE, fdwReason: DWORD, lpvReserved: LPVOID) : BOOL {.stdcall, exportc, dynlib.} =
  NimMain()
  return true