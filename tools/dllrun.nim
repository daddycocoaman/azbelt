import std/dynlib
import winim/lean
import os
import std/sequtils

type
  EntryFunction = proc (args: varargs[LPCWSTR]): int {.gcsafe, stdcall.}

let lib = loadLib(paramStr(1))
if lib == nil:
  echo "Error loading library"
  quit(1)

let entry = cast[EntryFunction](lib.symAddr("go"))
if entry == nil:
  echo "Error loading 'entrypoint' function from library"
  quit(2)

let args = commandLineParams()[1..^1].mapIt(LPCWSTR(it))
discard entry(args)
unloadLib(lib)