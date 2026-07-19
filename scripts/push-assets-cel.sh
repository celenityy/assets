#!/bin/bash

set -euo pipefail

# Ensure this is never ran with xtrace...
set +x

# Set-up our environment
source $(dirname $0)/env.sh

# Include utilities
source "${CEL_ASSETS_UTILS}"

if [[ -z "${CEL_ASSETS_FROM_PUSH+x}" ]]; then
  echo_red_text 'ERROR: Do not call push-assets-cel.sh directly. Instead, use push-assets.sh.' >&1
  exit 1
fi

if [[ -z "${CEL_ASSETS_S3_ACCESS_KEY_FILE}" ]]; then
  echo_red_text 'ERROR: The CEL_ASSETS_S3_ACCESS_KEY_FILE environment variable is missing! Aborting...'
  exit 1
fi

if [[ ! -f "${CEL_ASSETS_S3_ACCESS_KEY_FILE}" ]]; then
  echo_red_text "ERROR: S3 access key file not found! (${CEL_ASSETS_S3_ACCESS_KEY_FILE})"
  echo_green_text "Please ensure the CEL_ASSETS_S3_ACCESS_KEY_FILE environment variable is set to the correct path in which the key file is located."
  echo_red_text "Aborting..."
  exit 1
fi

if [[ ! -s "${CEL_ASSETS_S3_ACCESS_KEY_FILE}" ]]; then
  echo_red_text "ERROR: S3 access key file ${CEL_ASSETS_S3_ACCESS_KEY_FILE} is empty!"
  exit 1
fi

if [[ -z "${CEL_ASSETS_S3_BUCKET_NAME_FILE}" ]]; then
  echo_red_text 'ERROR: The CEL_ASSETS_S3_BUCKET_NAME_FILE environment variable is missing! Aborting...'
  exit 1
fi

if [[ ! -f "${CEL_ASSETS_S3_BUCKET_NAME_FILE}" ]]; then
  echo_red_text "ERROR: S3 bucket name file not found! (${CEL_ASSETS_S3_BUCKET_NAME_FILE})"
  echo_green_text "Please ensure the CEL_ASSETS_S3_BUCKET_NAME_FILE environment variable is set to the correct path in which the bucket name file is located."
  echo_red_text "Aborting..."
  exit 1
fi

if [[ ! -s "${CEL_ASSETS_S3_BUCKET_NAME_FILE}" ]]; then
  echo_red_text "ERROR: S3 bucket name file ${CEL_ASSETS_S3_BUCKET_NAME_FILE} is empty!"
  exit 1
fi

if [[ -z "${CEL_ASSETS_S3_ENDPOINT_FILE}" ]]; then
  echo_red_text 'ERROR: The CEL_ASSETS_S3_ENDPOINT_FILE environment variable is missing! Aborting...'
  exit 1
fi

if [[ ! -f "${CEL_ASSETS_S3_ENDPOINT_FILE}" ]]; then
  echo_red_text "ERROR: S3 endpoint file not found! (${CEL_ASSETS_S3_ENDPOINT_FILE})"
  echo_green_text "Please ensure the CEL_ASSETS_S3_ENDPOINT_FILE environment variable is set to the correct path in which the endpoint file is located."
  echo_red_text "Aborting..."
  exit 1
fi

if [[ ! -s "${CEL_ASSETS_S3_ENDPOINT_FILE}" ]]; then
  echo_red_text "ERROR: S3 bucket name file ${CEL_ASSETS_S3_ENDPOINT_FILE} is empty!"
  exit 1
fi

if [[ -z "${CEL_ASSETS_S3_SECRET_KEY_FILE}" ]]; then
  echo_red_text 'ERROR: The CEL_ASSETS_S3_SECRET_KEY_FILE environment variable is missing! Aborting...'
  exit 1
fi

if [[ ! -f "${CEL_ASSETS_S3_SECRET_KEY_FILE}" ]]; then
  echo_red_text "ERROR: S3 secret key file not found! (${CEL_ASSETS_S3_SECRET_KEY_FILE})"
  echo_green_text "Please ensure the CEL_ASSETS_S3_SECRET_KEY_FILE environment variable is set to the correct path in which the key file is located."
  echo_red_text "Aborting..."
  exit 1
fi

if [[ ! -s "${CEL_ASSETS_S3_SECRET_KEY_FILE}" ]]; then
  echo_red_text "ERROR: S3 secret key file ${CEL_ASSETS_S3_SECRET_KEY_FILE} is empty!"
  exit 1
fi

readonly target="$1"

# Set-up target parameters
CEL_ASSETS_PUSH_UBO_BADLISTS=0
CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_DEV=0
CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_MAIN=0
CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS=0
CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK=0
CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK_TESTING=0
CEL_ASSETS_PUSH_UBO_DOVE_FILTERS=0
CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_DEV=0
CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_MAIN=0
CEL_ASSETS_PUSH_UBO_PHOENIX_BEACON=0
CEL_ASSETS_PUSH_UBO_PHOENIX_FILTERS=0
CEL_ASSETS_PUSH_UBO_PHOENIX_QUICK_FIXES=0
CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_DEV=0
CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_MAIN=0

if [[ "${target}" == 'ubo-badlists' ]]; then
  # Push uBlock Origin - Badlists
  CEL_ASSETS_PUSH_UBO_BADLISTS=1
elif [[ "${target}" == 'ubo-dove-assets-dev' ]]; then
  # Push uBlock Origin - Dove assets (development)
  CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_DEV=1
elif [[ "${target}" == 'ubo-dove-assets-main' ]]; then
  # Push uBlock Origin - Dove assets (production)
  CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_MAIN=1
elif [[ "${target}" == 'ubo-dove-block-js' ]]; then
  # Push uBlock Origin - Dove filters - Block JS
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS=1
elif [[ "${target}" == 'ubo-dove-block-js-unbreak' ]]; then
  # Push uBlock Origin - Dove filters - Block JS - Unbreak
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK=1
elif [[ "${target}" == 'ubo-dove-block-js-unbreak-testing' ]]; then
  # Push uBlock Origin - Dove filters - Block JS - Unbreak (Testing)
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK_TESTING=1
elif [[ "${target}" == 'ubo-dove-filters' ]]; then
  # Push uBlock Origin - Dove filters
  CEL_ASSETS_PUSH_UBO_DOVE_FILTERS=1
elif [[ "${target}" == 'ubo-phoenix-assets-dev' ]]; then
  # Push uBlock Origin - Phoenix assets (development)
  CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_DEV=1
elif [[ "${target}" == 'ubo-phoenix-assets-main' ]]; then
  # Push uBlock Origin - Phoenix assets (production)
  CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_MAIN=1
elif [[ "${target}" == 'ubo-phoenix-beacon' ]]; then
  # Push uBlock Origin - Phoenix filters - Beacon API Stub
  CEL_ASSETS_PUSH_UBO_PHOENIX_BEACON=1
elif [[ "${target}" == 'ubo-phoenix-filters' ]]; then
  # Push uBlock Origin - Phoenix filters
  CEL_ASSETS_PUSH_UBO_PHOENIX_FILTERS=1
elif [[ "${target}" == 'ubo-phoenix-quick-fixes' ]]; then
  # Push uBlock Origin - Phoenix filters - Quick fixes
  CEL_ASSETS_PUSH_UBO_PHOENIX_QUICK_FIXES=1
elif [[ "${target}" == 'ubo-titanium-assets-dev' ]]; then
  # Push uBlock Origin - Titanium assets (development)
  CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_DEV=1
elif [[ "${target}" == 'ubo-titanium-assets-main' ]]; then
  # Push uBlock Origin - Titanium assets (production)
  CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_MAIN=1
elif [[ "${target}" == 'all' ]]; then
  # If no argument is specified (or argument is set to "all"), just push everything
  CEL_ASSETS_PUSH_UBO_BADLISTS=1
  CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_DEV=1
  CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_MAIN=1
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS=1
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK=1
  CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK_TESTING=1
  CEL_ASSETS_PUSH_UBO_DOVE_FILTERS=1
  CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_DEV=1
  CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_MAIN=1
  CEL_ASSETS_PUSH_UBO_PHOENIX_BEACON=1
  CEL_ASSETS_PUSH_UBO_PHOENIX_FILTERS=1
  CEL_ASSETS_PUSH_UBO_PHOENIX_QUICK_FIXES=1
  CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_DEV=1
  CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_MAIN=1
else
  echo_red_text "ERROR: Invalid target: ${target}\n You must enter one of the following:"
  echo 'All:                                                          all (Default)'
  echo 'uBlock Origin - Badlists:                                     ubo-badlists'
  echo 'uBlock Origin - Dove assets (development):                    ubo-dove-assets-dev'
  echo 'uBlock Origin - Dove assets (production):                     ubo-dove-assets-main'
  echo 'uBlock Origin - Dove filters:                                 ubo-dove-filters'
  echo 'uBlock Origin - Dove filters - Block JS:                      ubo-dove-block-js'
  echo 'uBlock Origin - Dove filters - Block JS - Unbreak:            ubo-dove-block-js-unbreak'
  echo 'uBlock Origin - Dove filters - Block JS - Unbreak (Testing):  ubo-dove-block-js-unbreak-testing'
  echo 'uBlock Origin - Phoenix assets (development):                 ubo-phoenix-assets-dev'
  echo 'uBlock Origin - Phoenix assets (production):                  ubo-phoenix-assets-main'
  echo 'uBlock Origin - Phoenix filters:                              ubo-phoenix-filters'
  echo 'uBlock Origin - Phoenix filters - Beacon API Stub:            ubo-phoenix-beacon'
  echo 'uBlock Origin - Phoenix filters - Quick fixes:                ubo-phoenix-quick-fixes'
  echo 'uBlock Origin - Titanium assets (development):                ubo-titanium-assets-dev'
  echo 'uBlock Origin - Titanium assets (production):                 ubo-titanium-assets-main'
  exit 1
fi

readonly CEL_ASSETS_PUSH_UBO_BADLISTS
readonly CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_DEV
readonly CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_MAIN
readonly CEL_ASSETS_PUSH_UBO_DOVE_FILTERS
readonly CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS
readonly CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK
readonly CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK_TESTING
readonly CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_DEV
readonly CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_MAIN
readonly CEL_ASSETS_PUSH_UBO_PHOENIX_BEACON
readonly CEL_ASSETS_PUSH_UBO_PHOENIX_FILTERS
readonly CEL_ASSETS_PUSH_UBO_PHOENIX_QUICK_FIXES
readonly CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_DEV
readonly CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_MAIN

# Set timezone to UTC for consistency
unset TZ
export TZ="UTC"

function push_file() {
  local readonly push_file="$1"
  local readonly s3_path="$2"
  local readonly s3_full_path="${s3_path}/$("${CEL_ASSETS_BASENAME}" "${push_file}")"

  if [[ ! -f "${push_file}" ]]; then
    echo_red_text "ERROR: File ${push_file} does not exist!"
    exit 1
  fi

  if [[ ! -s "${push_file}" ]]; then
    echo_red_text "ERROR: File ${push_file} is empty!"
    exit 1
  fi

  # Set our MIME type
  case "${push_file}" in
    *.json)
      local readonly mime_type='application/json'
      ;;
    *.txt)
      local readonly mime_type='text/plain'
      ;;
    *)
      echo_red_text "ERROR: Unsupported file type: ${push_file}"
      exit 1
      ;;
  esac

  local readonly s3_access_key=$("${CEL_ASSETS_CAT}" "${CEL_ASSETS_S3_ACCESS_KEY_FILE}" | "${CEL_ASSETS_XARGS}")
  local readonly s3_bucket_name=$("${CEL_ASSETS_CAT}" "${CEL_ASSETS_S3_BUCKET_NAME_FILE}" | "${CEL_ASSETS_XARGS}")
  local readonly s3_endpoint=$("${CEL_ASSETS_CAT}" "${CEL_ASSETS_S3_ENDPOINT_FILE}" | "${CEL_ASSETS_XARGS}")
  local readonly s3_secret_key=$("${CEL_ASSETS_CAT}" "${CEL_ASSETS_S3_SECRET_KEY_FILE}" | "${CEL_ASSETS_XARGS}")

  echo_red_text "Pushing ${push_file} to S3..."
  source "${CEL_ASSETS_PYENV}"
  "${CEL_ASSETS_S3CMD}" ${CEL_ASSETS_S3CMD_FLAGS} --mime-type="${mime_type}" put "${push_file}" "s3://${s3_bucket_name}/${s3_full_path}" \
    --access_key="${s3_access_key}" \
    --secret_key="${s3_secret_key}" \
    --host="${s3_endpoint}" \
    --host-bucket="${s3_endpoint}"
  echo_green_text "SUCCESS: Pushed ${push_file} to S3"
}

function add_sha512sum() {
  local readonly sha512sum_file_in="$1"
  local readonly sha512sum_file_name=$("${CEL_ASSETS_BASENAME}" "${sha512sum_file_in}")
  local readonly sha512sum_file_path=$("${CEL_ASSETS_DIRNAME}" "${sha512sum_file_in}")

  if [[ -z "${2+x}" ]]; then
    local readonly sha512sum_s3path=$("${CEL_ASSETS_BASENAME}" "${sha512sum_file_path}" | "${CEL_ASSETS_AWK}" '{print tolower($0)}')
  else
    local readonly sha512sum_s3path="$2"
  fi

  local readonly sha512sum_file_out="${sha512sum_file_path}/${sha512sum_file_name}-sha512sum.txt"

  # If there's already a SHA512sum file, remove it
  if [[ -f "${sha512sum_file_out}" ]]; then
    "${CEL_ASSETS_RM}" -f "${sha512sum_file_out}"
  fi

  local readonly local_sha512sum=$("${CEL_ASSETS_SHA512SUM}" "${sha512sum_file_in}" | "${CEL_ASSETS_AWK}" '{print $1}')
  echo -n "${local_sha512sum}" > "${sha512sum_file_out}"

  push_file "${sha512sum_file_out}" "${sha512sum_s3path}"
}

function push_ubo_badlists() {
  push_file "${CEL_ASSETS_ROOT}/ublock/badlists.txt" 'ublock'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/badlists.txt" 'ublock'
}

function push_ubo_dove_assets_dev() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/assets.dev.json" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/assets.dev.json" 'ublock/dove'
}

function push_ubo_dove_assets_main() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/assets.json" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/assets.json" 'ublock/dove'
}

function push_ubo_dove_block_js() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/block-js.txt" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/block-js.txt" 'ublock/dove'
}

function push_ubo_dove_block_js_unbreak() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/unbreak-js.txt" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/unbreak-js.txt" 'ublock/dove'
}

function push_ubo_dove_block_js_unbreak_testing() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/unbreak-js-testing.txt" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/unbreak-js-testing.txt" 'ublock/dove'
}

function push_ubo_dove_filters() {
  push_file "${CEL_ASSETS_ROOT}/ublock/dove/filters.txt" 'ublock/dove'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/dove/filters.txt" 'ublock/dove'
}

function push_ubo_phoenix_assets_dev() {
  push_file "${CEL_ASSETS_ROOT}/ublock/phoenix/assets.dev.json" 'ublock/phoenix'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/phoenix/assets.dev.json" 'ublock/phoenix'
}

function push_ubo_phoenix_assets_main() {
  push_file "${CEL_ASSETS_ROOT}/ublock/phoenix/assets.json" 'ublock/phoenix'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/phoenix/assets.json" 'ublock/phoenix'
}

function push_ubo_phoenix_beacon() {
  push_file "${CEL_ASSETS_ROOT}/ublock/phoenix/beacon.txt" 'ublock/phoenix'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/phoenix/beacon.txt" 'ublock/phoenix'
}

function push_ubo_phoenix_filters() {
  push_file "${CEL_ASSETS_ROOT}/ublock/phoenix/filters.txt" 'ublock/phoenix'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/phoenix/filters.txt" 'ublock/phoenix'
}

function push_ubo_phoenix_quick_fixes() {
  push_file "${CEL_ASSETS_ROOT}/ublock/phoenix/quick-fixes.txt" 'ublock/phoenix'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/phoenix/quick-fixes.txt" 'ublock/phoenix'
}

function push_ubo_titanium_assets_dev() {
  push_file "${CEL_ASSETS_ROOT}/ublock/titanium/assets.dev.json" 'ublock/titanium'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/titanium/assets.dev.json" 'ublock/titanium'
}

function push_ubo_titanium_assets_main() {
  push_file "${CEL_ASSETS_ROOT}/ublock/titanium/assets.json" 'ublock/titanium'
  add_sha512sum "${CEL_ASSETS_ROOT}/ublock/titanium/assets.json" 'ublock/titanium'
}

if [[ "${CEL_ASSETS_PUSH_UBO_BADLISTS}" == 1 ]]; then
  push_ubo_badlists
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_DEV}" == 1 ]]; then
  push_ubo_dove_assets_dev
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_ASSETS_MAIN}" == 1 ]]; then
  push_ubo_dove_assets_main
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS}" == 1 ]]; then
  push_ubo_dove_block_js
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK}" == 1 ]]; then
  push_ubo_dove_block_js_unbreak
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_BLOCK_JS_UNBREAK_TESTING}" == 1 ]]; then
  push_ubo_dove_block_js_unbreak_testing
fi

if [[ "${CEL_ASSETS_PUSH_UBO_DOVE_FILTERS}" == 1 ]]; then
  push_ubo_dove_filters
fi

if [[ "${CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_DEV}" == 1 ]]; then
  push_ubo_phoenix_assets_dev
fi

if [[ "${CEL_ASSETS_PUSH_UBO_PHOENIX_ASSETS_MAIN}" == 1 ]]; then
  push_ubo_phoenix_assets_main
fi

if [[ "${CEL_ASSETS_PUSH_UBO_PHOENIX_BEACON}" == 1 ]]; then
  push_ubo_phoenix_beacon
fi

if [[ "${CEL_ASSETS_PUSH_UBO_PHOENIX_FILTERS}" == 1 ]]; then
  push_ubo_phoenix_filters
fi

if [[ "${CEL_ASSETS_PUSH_UBO_PHOENIX_QUICK_FIXES}" == 1 ]]; then
  push_ubo_phoenix_quick_fixes
fi

if [[ "${CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_DEV}" == 1 ]]; then
  push_ubo_titanium_assets_dev
fi

if [[ "${CEL_ASSETS_PUSH_UBO_TITANIUM_ASSETS_MAIN}" == 1 ]]; then
  push_ubo_titanium_assets_main
fi
