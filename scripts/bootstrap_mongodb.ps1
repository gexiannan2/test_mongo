param(
    [string]$Generator = "NMake Makefiles"
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$SourceRoot = Join-Path $Root "third_party/src"
$BuildRoot = Join-Path $Root "third_party/build"
$InstallRoot = Join-Path $Root "third_party/mongodb"
$CDriverSource = Join-Path $SourceRoot "mongo-c-driver"
$CxxDriverSource = Join-Path $SourceRoot "mongo-cxx-driver"

function Invoke-Native {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Command
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw ("Native command failed, exit code: {0}" -f $LASTEXITCODE)
    }
}

New-Item -ItemType Directory -Force -Path $SourceRoot, $BuildRoot, $InstallRoot | Out-Null

if (-not (Test-Path -LiteralPath $CDriverSource)) {
    Invoke-Native { git clone --branch 2.3.3 --depth 1 https://github.com/mongodb/mongo-c-driver.git $CDriverSource }
}

if (-not (Test-Path -LiteralPath $CxxDriverSource)) {
    Invoke-Native { git clone --branch r4.4.1 --depth 1 https://github.com/mongodb/mongo-cxx-driver.git $CxxDriverSource }
}

$CDriverConfig = Join-Path $InstallRoot "lib/cmake/mongoc-2.3.3/mongocConfig.cmake"
if (-not (Test-Path -LiteralPath $CDriverConfig)) {
    $CDriverBuild = Join-Path $BuildRoot "mongo-c-driver-nmake-v2"
    Invoke-Native {
        cmake -S $CDriverSource -B $CDriverBuild -G $Generator `
            -DCMAKE_INSTALL_PREFIX="$InstallRoot" `
            -DCMAKE_BUILD_TYPE=Release `
            -DCMAKE_C_FLAGS="/utf-8" `
            -DCMAKE_CXX_FLAGS="/utf-8" `
            -DBUILD_TESTING=OFF `
            -DENABLE_TESTS=OFF `
            -DENABLE_EXAMPLES=OFF `
            -DENABLE_SSL=WINDOWS `
            -DENABLE_SASL=SSPI `
            -DENABLE_CLIENT_SIDE_ENCRYPTION=OFF `
            -DENABLE_MONGODB_AWS_AUTH=OFF
    }
    Invoke-Native { cmake --build $CDriverBuild --target install }
}

$CxxDriverBuild = Join-Path $BuildRoot "mongo-cxx-driver-nmake-v3"
Invoke-Native {
    cmake -S $CxxDriverSource -B $CxxDriverBuild -G $Generator `
        -DCMAKE_INSTALL_PREFIX="$InstallRoot" `
        -DCMAKE_PREFIX_PATH="$InstallRoot" `
        -DCMAKE_BUILD_TYPE=Release `
        -DCMAKE_CXX_FLAGS="/utf-8" `
        -DCMAKE_CXX_STANDARD=20 `
        -DCMAKE_CXX_STANDARD_REQUIRED=ON `
        "-DBUILD_VERSION=4.4.1" `
        -DBUILD_SHARED_LIBS=ON `
        -DBUILD_SHARED_AND_STATIC_LIBS=OFF `
        -DBUILD_TESTING=OFF `
        -DENABLE_TESTS=OFF
}
Invoke-Native { cmake --build $CxxDriverBuild --target install }

Write-Host "MongoDB C/C++ Driver installation completed: $InstallRoot"
