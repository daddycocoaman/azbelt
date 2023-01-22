import std/tables
import winim/lean
import winim/inc/lm

import ../utils

type
    DSREG_JOIN_TYPE = enum
        DSREG_UNKNOWN_JOIN = 0
        DSREG_DEVICE_JOIN = 1
        DSREG_WORKPLACE_JOIN = 2
    
    DSREG_USER_INFO = object
        pszUserEmail: LPWSTR
        pszUserKeyId: LPWSTR
        pszUserKeyName: LPWSTR

    DSREG_JOIN_INFO = object
        joinType: DSREG_JOIN_TYPE
        pJoinCertificate: PCCERT_CONTEXT
        pszDeviceId: LPWSTR
        pszIdpDomain: LPWSTR
        pszTenantId: LPWSTR
        pszJoinUserEmail: LPWSTR
        pszTenantDisplayName: LPWSTR
        pszMdmEnrollmentUrl: LPWSTR
        pszMdmTermsOfUseUrl: LPWSTR
        pszMdmComplianceUrl: LPWSTR
        pszUserSettingSyncUrl: LPWSTR
        pUserInfo: ptr DSREG_USER_INFO
    
    PDSREG_JOIN_INFO = ptr DSREG_JOIN_INFO

proc NetGetAadJoinInformation(pcszTenantId: LPCWSTR, ppJoinInfo: ptr PDSREG_JOIN_INFO): NET_API_STATUS {.winapi, stdcall, dynlib: "netapi32", importc.}

proc runAADJoin*(): string =    
    var
        pJoinInfo: PDSREG_JOIN_INFO
        tenantId: LPCWSTR = nil
    let
        status = NetGetAadJoinInformation(tenantId, addr pJoinInfo)

    result.add makeSectionTitle("AAD Join")
    if status == 0:
        var joinInfo = pJoinInfo[]
        if joinInfo != nil:
            result.add "Join Type: ".green & $joinInfo.joinType & "\n"
            result.add "Username: ".green & $joinInfo.pszJoinUserEmail & "\n"
            result.add "Tenant ID: ".green & $joinInfo.pszTenantId & "\n"
            result.add "Tenant Display Name: ".green & $joinInfo.pszTenantDisplayName & "\n"
            result.add "Device ID: ".green & $joinInfo.pszDeviceId & "\n"
            result.add "IDP Domain: ".green & $joinInfo.pszIdpDomain & "\n"
            result.add "MDM Enrollment URL: ".green & $joinInfo.pszMdmEnrollmentUrl & "\n"

            if joinInfo.pUserInfo[] != nil:
                result.add $joinInfo.pUserInfo[].pszUserEmail & "\n"
                result.add $joinInfo.pUserInfo[].pszUserKeyId & "\n"
                result.add $joinInfo.pUserInfo[].pszUserKeyName & "\n"
    else:
        result = "Error: " & $status
        