#!/bin/bash

# celenity assets environment variables

set -euo pipefail

if [[ ! -f "$(dirname $0)/env_local.sh" ]]; then
  readonly ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  readonly ENV_LOCAL="${ROOT}/scripts/env_local.sh"

  # Write env_local.sh
  echo "Writing ${ENV_LOCAL}..."
  cat > "${ENV_LOCAL}" << EOF
readonly CEL_ASSETS_ROOT="${ROOT}"
export CEL_ASSETS_ROOT

source "\${CEL_ASSETS_ROOT}/scripts/env_common.sh"
EOF
fi

if [[ -z "${CEL_ASSETS_SET_ENVS+x}" ]]; then
  source "$(dirname $0)/env_local.sh"

  # Set-up our PATH
  "${CEL_ASSETS_RM}" -rf                            "${CEL_ASSETS_PATH}"
  "${CEL_ASSETS_MKDIR}" -p                          "${CEL_ASSETS_PATH}"

  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_AWK}"        "${CEL_ASSETS_PATH}/awk"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_AWK}"        "${CEL_ASSETS_PATH}/gawk"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_BASENAME}"   "${CEL_ASSETS_PATH}/basename"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_CAT}"        "${CEL_ASSETS_PATH}/cat"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_CHMOD}"      "${CEL_ASSETS_PATH}/chmod"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_CP}"         "${CEL_ASSETS_PATH}/cp"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_CURL}"       "${CEL_ASSETS_PATH}/curl"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_DATE}"       "${CEL_ASSETS_PATH}/date"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_DATE}"       "${CEL_ASSETS_PATH}/gdate"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_DIRNAME}"    "${CEL_ASSETS_PATH}/dirname"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_GIT}"        "${CEL_ASSETS_PATH}/git"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_GZIP}"       "${CEL_ASSETS_PATH}/gzip"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_LN}"         "${CEL_ASSETS_PATH}/ln"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_LS}"         "${CEL_ASSETS_PATH}/ls"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_MD5SUM}"     "${CEL_ASSETS_PATH}/md5sum"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_MKDIR}"      "${CEL_ASSETS_PATH}/mkdir"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_MV}"         "${CEL_ASSETS_PATH}/mv"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_PYTHON}"     "${CEL_ASSETS_PATH}/python"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_PYTHON}"     "${CEL_ASSETS_PATH}/python3"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_RM}"         "${CEL_ASSETS_PATH}/rm"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_S3CMD}"      "${CEL_ASSETS_PATH}/s3cmd"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_SED}"        "${CEL_ASSETS_PATH}/gsed"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_SED}"        "${CEL_ASSETS_PATH}/sed"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_SHA1SUM}"    "${CEL_ASSETS_PATH}/sha1sum"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_SHA256SUM}"  "${CEL_ASSETS_PATH}/sha256sum"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_SHA512SUM}"  "${CEL_ASSETS_PATH}/sha512sum"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_TAR}"        "${CEL_ASSETS_PATH}/gtar"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_TAR}"        "${CEL_ASSETS_PATH}/tar"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_TEE}"        "${CEL_ASSETS_PATH}/tee"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_TOUCH}"      "${CEL_ASSETS_PATH}/touch"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_UNAME}"      "${CEL_ASSETS_PATH}/uname"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_UNZIP}"      "${CEL_ASSETS_PATH}/unzip"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_UV}"         "${CEL_ASSETS_PATH}/uv"
  "${CEL_ASSETS_LN}" -sf "${CEL_ASSETS_XARGS}"      "${CEL_ASSETS_PATH}/xargs"

  readonly PATH="${CEL_ASSETS_PATH}"
  export PATH
fi
