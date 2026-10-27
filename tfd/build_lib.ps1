<#
	Rebuilds tinyfiledialogs.lib as an x64 Windows static library with MSVC.

	/Dgetcwd=_getcwd works around lld-link (Odin's default Windows linker)
	being unable to parse OLDNAMES.lib from the VS2019 build tools.
#>

$ErrorActionPreference = 'Stop'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path

$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
if (-not (Test-Path $vswhere)) {
	throw 'vswhere.exe not found. Install the Visual Studio C++ build tools.'
}

$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) {
	throw 'MSVC x64 build tools not found.'
}

$vcvars = Join-Path $vs 'VC\Auxiliary\Build\vcvars64.bat'
$source = Join-Path $here 'tinyfiledialogs.c'
$obj    = Join-Path $here 'tinyfiledialogs.obj'
$lib    = Join-Path $here 'tinyfiledialogs.lib'

cmd /c "`"$vcvars`" >nul && cl /nologo /O2 /W3 /TC /Dgetcwd=_getcwd /c `"$source`" /Fo:`"$obj`" && lib /nologo /OUT:`"$lib`" `"$obj`""
if ($LASTEXITCODE -ne 0) {
	throw "tinyfiledialogs build failed with exit code $LASTEXITCODE"
}

Write-Host "Wrote $lib"
