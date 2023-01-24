# AzBelt

Standalone DLL and sliver extension for enumerating Azure related credentials, primarily on AAD joined machines

A devcontainer is a provided for easy development and building. To build, simply:

``nimble release``

This will drop the DLLs into the project folder. If you want the exe for testing the DLL, you can also build the DLL runner:

``nimble dllrun``

You can do both at the same time:

``nimble all``

### Special Thanks

- [@_xpn_](https://twitter.com/@_xpn_) - [TokenBroker Cache research](https://blog.xpnsec.com/wam-bam/)
- [@tifkin](https://twitter.com/tifkin_) - [AAD SSO Refresh Token research](https://posts.specterops.io/requesting-azure-ad-request-tokens-on-azure-ad-joined-machines-for-browser-sso-2b0409caad30)
- [@_dirkjan](https://twitter.com/_dirkjan) - [PRT research](https://dirkjanm.io/abusing-azure-ad-sso-with-the-primary-refresh-token/)