# Package

version       = "0.3.1"
author        = "Leron Gray"
description   = "Azure credential searching in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["azbelt"]


# Dependencies

requires "nim >= 1.6.10"
requires "puppy 2.0.3"
requires "winim"

# Build
var depsChecked = false
task ensureDeps, "Ensure Dependencies Installed":
    if depsChecked == false:
        exec "nimble -d -y install"
    depsChecked = true

task dll, "Build DLLs":
    ensureDepsTask()
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=lib --nomain --mm:arc --cpu=amd64 --gc:arc -o:build/azbelt.x64.dll src/azbelt.nim"
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=lib --nomain --mm:arc --cpu=i386 --gc:arc -o:build/azbelt.x86.dll src/azbelt.nim"

task exe, "Build EXEs":
    ensureDepsTask()
    exec "nim c -d=mingw -d:danger -d:strip --opt=size -d:release --passc=-flto --passl=-flto --app=console --mm:arc --cpu=amd64 --gc:arc -o:build/azbelt.x64.exe src/azbelt.nim"
    exec "nim c -d=mingw -d:danger -d:strip --opt=size -d:release --passc=-flto --passl=-flto --app=console --mm:arc --cpu=i386 --gc:arc -o:build/azbelt.x86.exe src/azbelt.nim"

task release, "Release build":
    dllTask()
    exeTask()

task dllrun, "Build DLL runner":
    exec "nim c -d=mingw -d:danger -d:strip --opt:size -d:release --passc=-flto --passl=-flto --app=console --mm:arc --cpu=amd64 --gc:arc --outdir:tools tools/dllrun.nim"

task all, "Build all":
    releaseTask()
    dllrunTask()