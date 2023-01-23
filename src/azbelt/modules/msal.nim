import os
import std/[base64, json, strtabs, strutils, times]

import ../constants
import ../utils

proc parseMSALCache*(cache_path: string): string =
    if not cache_path.fileExists(): 
        result.add "No MSAL cache found" & "\n"
        return

    var cache = try: readFile(cache_path)
                except:
                    result.add "Failed to read MSAL cache" & "\n"
                    return
    var decrypted = cryptUnprotectData(cache)
    var tokens = parseJson(decrypted)
    var accountsTable = newStringTable()
    
    var accounts = tokens["Account"]
    var accessTokens = tokens["AccessToken"]
    var refreshTokens = tokens["RefreshToken"]
    var idTokens = tokens["IdToken"]

    for key, entry in accounts.pairs():
        var username = entry["username"].getStr()
        var homeAccountId = entry["home_account_id"].getStr()
        accountsTable[homeAccountId] = username        
    
    result.add "Access Tokens:".green & "\n"
    for key, entry in accessTokens.pairs():
        var token = entry["secret"].getStr()
        var token_json = parseJson(decode(token.split(".")[1]))
        var home_account_id = entry["home_account_id"].getStr()
        var audience = token_json["aud"].getStr()
        var isValid = token_json["exp"].getInt() > getTime().toUnix
        var valid_Str = if isValid: green("True") else: "False"

        result.add "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id) & "\n"
        result.add "\tAudience: " & WELL_KNOWN_APPIDS.getOrDefault(audience, audience) & "\n"
        result.add "\tScopes: " & token_json["scp"].getStr() & "\n"
        result.add "\tValid: " & valid_Str & "\n"
        result.add "\tToken: " & token & "\n"
    
    result.add "Refresh Tokens:".green & "\n"
    for key, entry in refreshTokens.pairs():
        var home_account_id = entry["home_account_id"].getStr()
        var environment = entry["environment"].getStr() 
        var secret = entry["secret"].getStr()

        result.add "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id) & "\n"
        result.add "\tEnvironment: " & environment & "\n"
        result.add "\tSecret: " & secret & "\n"
    
    result.add "Id Tokens:".green & "\n"
    for key, entry in idTokens.pairs():
        var home_account_id = entry["home_account_id"].getStr()
        var token = entry["secret"].getStr()
        var token_json = parseJson(decode(token.split(".")[1]))
        var audience = token_json["aud"].getStr()
        var isValid = token_json["exp"].getInt() > getTime().toUnix
        var valid_Str = if isValid: green("True") else: "False"

        result.add "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id) & "\n"
        result.add "\tAudience: " & WELL_KNOWN_APPIDS.getOrDefault(audience, audience) & "\n"
        result.add "\tValid: " & valid_Str & "\n"
        result.add "\tToken: " & token & "\n"

proc runAzCliMSAL*() : string =
    result.add makeSectionTitle("Azure CLI MSAL Cache")
    result.add parseMSALCache(getHomeDir() / ".azure/msal_token_cache.bin")

proc runSharedMSAL*() : string =
    result.add makeSectionTitle("Shared MSAL Cache")
    result.add parseMSALCache(getHomeDir() / "Appdata/Local/.IdentityService/msal.cache")

proc runMSAL*() : string =
    result.add runAzCliMSAL()
    result.add runSharedMSAL()

