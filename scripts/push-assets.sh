#!/bin/bash

set -euo pipefail

# Set-up our environment
if [[ -z "${CEL_ASSETS_SET_ENVS+x}" ]]; then
  /bin/bash -x $(dirname $0)/env.sh
fi
source $(dirname $0)/env.sh

# Include utilities
source "${CEL_ASSETS_UTILS}"

# Set up target parameters
if [[ -z "${1+x}" ]]; then
  readonly target='all'
else
  readonly target=$(echo "${1}" | "${CEL_ASSETS_AWK}" '{print tolower($0)}')
fi

# Push celenity assets
readonly CEL_ASSETS_FROM_PUSH=1
export CEL_ASSETS_FROM_PUSH
if [[ "${CEL_ASSETS_LOG_PUSH}" == 1 ]]; then
  readonly PUSH_LOG_FILE="${CEL_ASSETS_LOG_DIR}/push-${target}.log"

  # If the log file already exists, remove it
  if [[ -f "${PUSH_LOG_FILE}" ]]; then
    "${CEL_ASSETS_RM}" "${PUSH_LOG_FILE}"
  fi

  # Ensure our log directory exists
  "${CEL_ASSETS_MKDIR}" -vp "${CEL_ASSETS_LOG_DIR}"

  /bin/bash "${CEL_ASSETS_SCRIPTS}/push-assets-cel.sh" "${target}" > >("${CEL_ASSETS_TEE}" -a "${PUSH_LOG_FILE}") 2>&1
else
  /bin/bash "${CEL_ASSETS_SCRIPTS}/push-assets-cel.sh" "${target}"
fi
