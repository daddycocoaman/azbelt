# Package

version       = "0.1.0"
author        = "Leron Gray"
description   = "Azure credential searching in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["AzureBelt"]


# Dependencies

requires "nim >= 1.6.10"
requires "winim"

# Build
task dbuild, "Debug build":
    exec "nim c -d=mingw --app=lib --nomain --cpu=amd64 --gc:arc /workspaces/AzureBelt/src/AzureBelt.nim"

task rbuild, "Debug build":
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=lib --nomain --cpu=amd64 --gc:arc /workspaces/AzureBelt/src/AzureBelt.nim"
