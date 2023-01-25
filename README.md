# azbelt

Standalone DLL and sliver extension for enumerating Azure related credentials, primarily on AAD joined machines

## Modules
- `aadjoin` - Gets info about machine AAD status via `NetGetAadJoinInformation`
- `credman` - Gets credentials from Credential Manager
- `env` - Looks for Azure/AAD specific environment variables that may contain secrets
- `managed` - Calls IMDS endpoint to get info about machine with managed identity
- `msal` - Looks in various MSAL caches for tokens. Tokens are parsed to display scope and validity
- `sso` - If machine is AAD joined, get signed PRT cookie
- `tbres` - Gets tokens from Token Broker cache
- `all` - Runs all enumeration except SSO

## Building from source
A devcontainer is a provided for easy development and building. The devcontainer base definition is located [here](https://github.com/daddycocoaman/devcontainers/blob/main/nim/.devcontainer/devcontainer.json).

To build, simply:

``nimble release``

This will drop the DLLs into the project folder. If you want the exe for testing the DLL, you can also build the DLL runner:

``nimble dllrun``

You can do both at the same time:

``nimble all``

### Special Thanks
- [@byt3bl33d3r](https://twitter.com/byt3bl33d3r) - [OffensiveNim](https://github.com/byt3bl33d3r/OffensiveNim)
- [@_xpn_](https://twitter.com/@_xpn_) - [TokenBroker Cache research](https://blog.xpnsec.com/wam-bam/)
- [@tifkin](https://twitter.com/tifkin_) - [AAD SSO Refresh Token research](https://posts.specterops.io/requesting-azure-ad-request-tokens-on-azure-ad-joined-machines-for-browser-sso-2b0409caad30)
- [@_dirkjan](https://twitter.com/_dirkjan) - [PRT research](https://dirkjanm.io/abusing-azure-ad-sso-with-the-primary-refresh-token/)