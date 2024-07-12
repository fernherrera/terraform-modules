#!/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# Paths
root_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)"
config_path="$root_path/configs"
plans_path="$root_path/plans"
script_path="$root_path/scripts"
tf_path="$root_path/src"
tf_modules_path="$tf_path/modules"

# List of Terraform modules to install
tf_modules=()
tf_modules+=("app_service_linux")
tf_modules+=("app_service_plan")
tf_modules+=("keyvault")
tf_modules+=("keyvault_access_policies")
tf_modules+=("managed_identity")
tf_modules+=("mssql_database")
tf_modules+=("mssql_server")
tf_modules+=("private_dns")
tf_modules+=("private_endpoint")
tf_modules+=("storage_account")
tf_modules+=("virtual_network")


cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
  # unset TF_BACKEND_RESOURCE_GROUP TF_BACKEND_STORAGE_ACCOUNT TF_BACKEND_CONTAINER TF_BACKEND_STORAGE_ACCESS_KEY
  # unset ARM_TENANT_ID ARM_SUBSCRIPTION_ID ARM_CLIENT_ID ARM_CLIENT_SECRET
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

install_tf_modules() {
  if [ -d "${root_path}/tmp" ]; then rm -Rf "${root_path}/tmp"; fi

  msg "[*] Downloading: [Terraform Modules]"
  repo_url="https://github.com/fernherrera/terraform-modules"
  git clone --depth 1 -c advice.detachedHead=false ${repo_url} tmp/

  for module in ${tf_modules[@]}; do

    if [ -d "${tf_modules_path}/${module}" ]; then
      msg " - Updating module (${module})"
      rm -Rf "${tf_modules_path}/${module}"
    else
      msg " - Installing module (${module})"
    fi

    mkdir "${tf_modules_path}/${module}"
    cp -R ${root_path}/tmp/azurerm/${module} "${tf_modules_path}"

  done
}

init_root_module() {
  msg "[*] Initializing root module"

  tf_root_files=("backend.tf" "data.tf" "locals.tf" "main.tf" "providers.tf" "variables.tf" "versions.tf")

  for file in ${tf_root_files[@]}; do

    if [ ! -e "${tf_path}/${file}" ]; then
      msg " - Creating ${tf_path}/${file}"
      touch "${tf_path}/${file}"
    fi

  done
}

init_paths() {
  # Ensure paths exist
  msg "[*] Checking paths"
  if [ ! -d "${config_path}" ]; then mkdir "${config_path}"; fi
  if [ ! -d "${plans_path}" ]; then mkdir "${plans_path}"; fi
  if [ ! -d "${tf_path}" ]; then mkdir "${tf_path}"; fi
  if [ ! -d "${tf_modules_path}" ]; then mkdir "${tf_modules_path}"; fi
}

execute_main() {
  # Set working dir
  cd $root_path

  init_paths
  init_root_module
  install_tf_modules
}

execute_main