import std/dynlib
import winim/lean
import os
import std/sequtils

type
  EntryFunction = proc (args: varargs[LPCWSTR]): int {.gcsafe, stdcall.}

let lib = loadLib(paramStr(1))
assert lib != nil, "Error loading library"

let entry = cast[EntryFunction](lib.symAddr("entrypoint"))
assert entry != nil, "Error loading 'entrypoint' function from library"

let args = commandLineParams()[1..^1].mapIt(LPCWSTR(it))
discard entry(args)
unloadLib(lib)