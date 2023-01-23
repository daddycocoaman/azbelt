import std/httpclient
import std/json

import ../utils

proc runManaged*(): string =
    var
        client = newHttpClient()

    result.add makeSectionTitle("Managed Identity")
    result.add makeSubSectionTitle("Metadata")
    client.headers = newHttpHeaders({"Content-Type": "application/json", "Metadata": "true"})
    try:
        var resp = client.get("http://169.254.169.254/metadata/instance?api-version=2021-12-13")
        if resp.status != $Http200:
            result.add "Error: " & resp.status & "\n" & resp.body & "\n"
            return result
        result.add pretty(parseJson(resp.body)) & "\n"
    except:
        result.add "Error: " & getCurrentExceptionMsg() & "\n"
        return result

    try:
        result.add makeSubSectionTitle("Token")
        var resp = client.get("http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://management.azure.com")
        if resp.status != $Http200:
            result.add "Error: " & resp.status & "\n" & resp.body & "\n"
            return result
        result.add pretty(parseJson(resp.body)) & "\n"
    except:
        result.add "Error: " & getCurrentExceptionMsg() & "\n"
        return result