import os

import ../utils

proc runEnvironment*(): string =
    result.add makeSectionTitle("Environment") 
    let
        vars = @["AZURE_CLIENT_ID", 
                 "AZURE_TENANT_ID",
                 "AZURE_USERNAME", 
                 "AZURE_PASSWORD", 
                 "AZURE_CLIENT_SECRET", 
                 "AZURE_CLIENT_CERTIFICATE_PATH", 
                 "AZURE_CLIENT_CERTIFICATE_PASSWORD",
                 "AZURE_POD_IDENTITY_AUTHORITY_HOST",
                 "IDENTITY_ENDPOINT",
                 "IDENTITY_HEADER",
                 "IDENTITY_SERVER_THUMBPRINT",
                 "IMDS_ENDPOINT",
                 "MSI_ENDPOINT",
                 "MSI_SECRET",
                 "AZURE_AUTHORITY_HOST",
                 "AZURE_IDENTITY_DISABLE_MULTITENANTAUTH",
                 "AZURE_REGIONAL_AUTHORITY_NAME",
                 "AZURE_FEDERATED_TOKEN_FILE",
                 "ONEDRIVE"]
    
    for key in vars:
        var value = getEnv(key)
        if value != "":
            result.add key & " = " & value & "\n"