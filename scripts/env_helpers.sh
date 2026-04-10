
# Set platform
if [[ "${OSTYPE}" == "darwin"* ]]; then
    readonly CEL_ASSETS_PLATFORM='darwin'
else
    readonly CEL_ASSETS_PLATFORM='linux'
fi
export CEL_ASSETS_PLATFORM

# Set OS
if [[ "${CEL_ASSETS_PLATFORM}" == 'darwin' ]]; then
    readonly CEL_ASSETS_OS='osx'
elif [[ "${CEL_ASSETS_PLATFORM}" == 'linux' ]]; then
    if [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        if [[ -n "${ID}" ]]; then
            readonly CEL_ASSETS_OS="${ID}"
        else
            readonly CEL_ASSETS_OS='unknown'
        fi
    else
        readonly CEL_ASSETS_OS='unknown'
    fi
else
    readonly CEL_ASSETS_OS='unknown'
fi
export CEL_ASSETS_OS

# Set architecture
readonly PLATFORM_ARCH=$(uname -m)
if [[ "${PLATFORM_ARCH}" == 'arm64' ]]; then
    readonly CEL_ASSETS_PLATFORM_ARCH='arm64'
else
    readonly CEL_ASSETS_PLATFORM_ARCH='x86_64'
fi
export CEL_ASSETS_PLATFORM_ARCH
