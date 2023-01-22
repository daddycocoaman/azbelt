import os
import std/[base64, json, strtabs, strutils, times]

import winim/lean
import ../constants
import ../utils
import winim/inc/wincred

proc runVSCode*() : string =
    result = makeSectionTitle("Visual Studio Code")
    # var
    #     cred_count: ptr int
    #     cred_array: PCREDENTIALW
            
    # var creds =  CredEnumerateW(NULL, 0, out cred_count, out ptr cred_array)
    # if creds == 0:
    #     echo "Error: " & $getLastError()