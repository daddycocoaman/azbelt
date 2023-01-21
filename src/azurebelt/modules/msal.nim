import os
import std/[base64, json, strtabs, strutils, times]

import ../constants
import ../utils

proc parseMSALCache*(cache_path: string): void = 
    if not cache_path.fileExists():
        echo "No MSAL cache found"
        return

    var cache = try: readFile(cache_path)
                except:
                    echo "Failed to read MSAL cache"
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
    
    echo "Access Tokens:".green
    for key, entry in accessTokens.pairs():
        var token = entry["secret"].getStr()
        var token_json = parseJson(decode(token.split(".")[1]))
        var home_account_id = entry["home_account_id"].getStr()
        var audience = token_json["aud"].getStr()
        var isValid = token_json["exp"].getInt() > getTime().toUnix
        var valid_Str = if isValid: green("True") else: "False"

        echo "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id)
        echo "\tAudience: " & WELL_KNOWN_APPIDS.getOrDefault(audience, audience)
        echo "\tScopes: " & token_json["scp"].getStr()
        echo "\tValid: " & valid_Str
        echo "\tToken: " & token & "\n"
    
    echo "Refresh Tokens:".green
    for key, entry in refreshTokens.pairs():
        var home_account_id = entry["home_account_id"].getStr()
        var environment = entry["environment"].getStr() 
        var secret = entry["secret"].getStr()

        echo "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id)
        echo "\tEnvironment: " & environment
        echo "\tSecret: " & secret & "\n"
    
    echo "Id Tokens:".green
    for key, entry in idTokens.pairs():
        var home_account_id = entry["home_account_id"].getStr()
        var token = entry["secret"].getStr()
        var token_json = parseJson(decode(token.split(".")[1]))
        var audience = token_json["aud"].getStr()
        var isValid = token_json["exp"].getInt() > getTime().toUnix
        var valid_Str = if isValid: green("True") else: "False"

        echo "\tUsername: " & accountsTable.getOrDefault(home_account_id, home_account_id)
        echo "\tAudience: " & WELL_KNOWN_APPIDS.getOrDefault(audience, audience)
        echo "\tValid: " & valid_Str
        echo "\tToken: " & token & "\n"

proc runAzCliMSAL*() : void =
    echo makeSectionTitle("Azure CLI MSAL Cache")
    parseMSALCache(getHomeDir() / ".azure/msal_token_cache.bin")

proc runSharedMSAL*() : void =
    echo makeSectionTitle("Shared MSAL Cache")
    parseMSALCache(getHomeDir() / "Appdata/Local/.IdentityService/msal.cache")

proc runMSAL*() : void =
    runAzCliMSAL()
    runSharedMSAL()

