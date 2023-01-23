# Package

version       = "0.1.0"
author        = "Leron Gray"
description   = "Azure credential searching in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["azbelt"]


# Dependencies

requires "nim >= 1.6.10"
requires "winim"

# Build
task release, "Release build":
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=lib --nomain --mm:arc --cpu=amd64 --gc:arc -o:azbelt.x64.dll src/AzBelt.nim"
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=lib --nomain --mm:arc --cpu=i386 --gc:arc -o:azbelt.x86.dll src/AzBelt.nim"

task dllrun, "Build DLL runner":
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=console --mm:arc --cpu=amd64 --gc:arc --outdir:tools tools/dllrun.nim"
    
task all, "Build all":
    releaseTask()
    dllrunTask()