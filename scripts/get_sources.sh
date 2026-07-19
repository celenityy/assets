#!/bin/bash

set -euo pipefail

# Set-up our environment
if [[ -z "${CEL_ASSETS_SET_ENVS+x}" ]]; then
  bash -x $(dirname $0)/env.sh
fi
source $(dirname $0)/env.sh

# Set up target parameters
if [[ -z "${1+x}" ]]; then
  readonly target='all'
else
  readonly target=$(echo "${1}" | "${CEL_ASSETS_AWK}" '{print tolower($0)}')
fi

if [[ -z "${2+x}" ]]; then
  readonly mode='download'
else
  readonly mode=$(echo "${2}" | "${CEL_ASSETS_AWK}" '{print tolower($0)}')
fi

# Get sources
readonly CEL_ASSETS_FROM_SOURCES=1
export CEL_ASSETS_FROM_SOURCES
if [[ "${CEL_ASSETS_LOG_SOURCES}" == 1 ]]; then
  readonly SOURCES_LOG_FILE="${CEL_ASSETS_LOG_DIR}/get_sources.log"

  # If the log file already exists, remove it
  if [[ -f "${SOURCES_LOG_FILE}" ]]; then
    rm "${SOURCES_LOG_FILE}"
  fi

  # Ensure our log directory exists
  mkdir -vp "${CEL_ASSETS_LOG_DIR}"

  bash -x "${CEL_ASSETS_SCRIPTS}/get_sources-cel.sh" "${target}" "${mode}" > >(tee -a "${SOURCES_LOG_FILE}") 2>&1
else
  bash -x "${CEL_ASSETS_SCRIPTS}/get_sources-cel.sh" "${target}" "${mode}"
fi
