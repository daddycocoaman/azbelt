import winim/lean
import std/strutils

proc green*(s: string): string = "\e[32m" & s & "\e[0m"
proc grey*(s: string): string = "\e[90m" & s & "\e[0m"
proc yellow*(s: string): string = "\e[33m" & s & "\e[0m"
proc red*(s: string): string = "\e[31m" & s & "\e[0m"
proc cyan*(s: string): string = "\e[36m" & s & "\e[0m"
proc magenta*(s: string): string = "\e[35m" & s & "\e[0m"
proc blue*(s: string): string = "\e[34m" & s & "\e[0m"

proc makeSectionTitle*(title: string): string =
  result = "*".repeat(10).cyan & "\n"
  result.add title.cyan & "\n"
  result.add "*".repeat(10).cyan

proc cryptUnprotectData*(data: openarray[byte|char]): string =
  var
    input = DATA_BLOB(cbData: cint data.len, pbData: cast[ptr BYTE](unsafeaddr data[0]))
    output: DATA_BLOB
  
  if CryptUnprotectData(addr input, nil, nil, nil, nil, 0, addr output) != 0:
    result.setLen(output.cbData)
    if output.cbData != 0:
      copyMem(addr result[0], output.pbData, output.cbData)
    LocalFree(cast[HLOCAL](output.pbData))

proc cryptUnprotectData*(data: string): string {.inline.} =
  result = cryptUnprotectData(data.toOpenArray(0, data.len - 1))

proc swapInt32Endian*(x: int): int {.inline.} =
  result = ((x shr 24) and 0x000000FF).int or
           ((x shr  8) and 0x0000FF00).int or
           ((x shl  8) and 0x00FF0000).int or
           ((x shl 24) and 0xFF000000).int

proc swapInt64Endian*(x: int64): int64 {.inline.} =
  result = ((x shr 56) and 0x00000000000000FF).int64 or
           ((x shr 40) and 0x000000000000FF00).int64 or
           ((x shr 24) and 0x0000000000FF0000).int64 or
           ((x shr  8) and 0x00000000FF000000).int64 or
           ((x shl  8) and 0x000000FF00000000).int64 or
           ((x shl 24) and 0x0000FF0000000000).int64 or
           ((x shl 40) and 0x00FF000000000000).int64 or
           ((x shl 56) and 0xFF00000000000000).int64