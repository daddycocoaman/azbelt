import os
import std/[base64, json, strtabs, strutils, times, unicode]

import winim/lean
import ../constants
import ../utils
import winim/inc/wincred
import system

type
    CRED_TYPE = enum
        CRED_TYPE_GENERIC = 1
        CRED_TYPE_DOMAIN_PASSWORD = 2
        CRED_TYPE_DOMAIN_CERTIFICATE = 3
        CRED_TYPE_DOMAIN_VISIBLE_PASSWORD = 4
        CRED_TYPE_GENERIC_CERTIFICATE = 5
        CRED_TYPE_DOMAIN_EXTENDED = 6
        CRED_TYPE_MAXIMUM = 7
        CRED_TYPE_MAXIMUM_EX = CRED_TYPE_MAXIMUM.int + 1000
    
    CRED_PERSIST = enum
        CRED_PERSIST_SESSION = 1
        CRED_PERSIST_LOCAL_MACHINE = 2
        CRED_PERSIST_ENTERPRISE = 3

proc runCredman*() : string =
    result = makeSectionTitle("Credman")
    var
        filter: LPCWSTR = nil
        flags: DWORD = 1
        cred_count: DWORD
        cred_array: ptr PCREDENTIALW

    var creds =  CredEnumerateW(filter, flags, addr cred_count, addr cred_array)
    if creds == 0:
        result.add "Error: " & $GetLastError()
    else: 
        var derefed_array = cast[ptr UncheckedArray[PCREDENTIALW]](cred_array)
        for idx in 0 ..< cred_count:
            var blob_str = ""
            var blob_size = derefed_array[idx].CredentialBlobSize

            result.add ("TargetName: " & $derefed_array[idx].TargetName).green & "\n"
            result.add "\tCredential Type: " & $CRED_TYPE(derefed_array[idx].Type) & "\n"
            result.add "\tPersist: " & $CRED_PERSIST(derefed_array[idx].Persist) & "\n"
            result.add "\tUsername: " & $derefed_array[idx].UserName & "\n"
            result.add "\tCredentialBlobSize: " & $blob_size & "\n"

            if blob_size > 0:
                var blob = cast[ptr UncheckedArray[char]](derefed_array[idx].CredentialBlob)
                for i in 0 ..< blob_size:
                    blob_str.add blob[i]
                
                if blob_str.startsWith("AQAAA"):
                    try:
                        var decoded = cryptUnprotectData(base64.decode(blob_str))
                        result.add "\tCredentialBlobDecoded: " & $decoded & "\n"
                    except:
                        result.add "\tCredentialBlobDecoded: " & "Sorry" & "\n"
                result.add "\tCredentialBlob: " & blob_str.replace("\r\n", "") & "\n"

