# AzBelt

Standalone DLL and sliver extension for enumerating Azure related credentials, primarily on AAD joined machines

A devcontainer is a provided for easy development and building. To build, simply:

``nimble release``

This will drop the DLLs into the project folder. If you want the exe for testing the DLL, you can also build the DLL runner:

``nimble dllrun``

You can do both at the same time:

``nimble all``
