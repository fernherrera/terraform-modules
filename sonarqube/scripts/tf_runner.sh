#!/bin/bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

# Paths
root_path="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd -P)"
config_path="$root_path/configs"
plans_path="$root_path/plans"
script_path="$root_path/scripts"
tf_path="$root_path/src"


usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [command] [options ... ]

Commands:
  build                 Create terraform execution plan file for the specified configuration and environment.
  deploy                Runs the execution plan for the specified configuration and environment.
  destroy               Destroys all resources previously created with the specified configuration and environment.
  import                Imports existing resources into Terraform state file.
  validate              Validate that terraform configuration is syntactically valid and internally consistent.

Options:
  -h, --help            Print this help and exit.
  -v, --verbose         Print script debug info.
  -l, --list            Print a list of available configurations.
  -p, --preview         When used in conjunction with destroy or import commands will print out a list of resource 
                        to be destroyed or imported.
  -c, --config <name>   Build output for the specified configuration.
  -e, --env <name>      Build output for the specified environment.
  --use-az-cli          Use Azure CLI to login.
EOF
  exit
}

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

parse_params() {
  # default values of variables set from params
  action=''
  environment=''
  config=''
  use_az_cli=false
  preview=false

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -v ;;
    -l | --list) list_configs ;;
    -p | --preview) preview=true ;;
    -e | --env) # example named parameter
      environment="${2-}"
      shift
      ;;
    -c | --config)
      config="${2-}"
      shift
      ;;
    --use-az-cli) set use_az_cli=true ;;
    build) action="build" ;;
    deploy) action="deploy" ;;
    destroy) action="destroy" ;;
    import) action="import" ;;
    validate) action="validate" ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${action-}" ]] && die "Missing required command."
  [[ -z "${config-}" ]] && die "Missing required parameter: -c or --config"
  [[ -z "${environment-}" ]] && die "Missing required parameter: -e or --env"

  return 0
}

load_env_file() {
  local env_file=".env.$environment"

  # Load .env file.
  if [[ -e $env_file ]]; then
    msg "Loading environment variables from [${env_file}]"
    set -a
    source .env.$environment
    set +a
  else
    msg "Local environment file not found: [${env_file}]. Skipping."
  fi
}

check_env_vars() {
  # check for required environment variables
  [[ -z "${ARM_SUBSCRIPTION_ID-}" ]] && die "Missing required environment variable: [ARM_SUBSCRIPTION_ID]"
  [[ -z "${TF_BACKEND_RESOURCE_GROUP-}" ]] && die "Missing required environment variable: [TF_BACKEND_RESOURCE_GROUP]"
  [[ -z "${TF_BACKEND_STORAGE_ACCOUNT-}" ]] && die "Missing required environment variable: [TF_BACKEND_STORAGE_ACCOUNT]"
  [[ -z "${TF_BACKEND_CONTAINER-}" ]] && die "Missing required environment variable: [TF_BACKEND_CONTAINER]"
  [[ -z "${TF_BACKEND_STORAGE_ACCESS_KEY-}" ]] && die "Missing required environment variable: [TF_BACKEND_STORAGE_ACCESS_KEY]"
  [[ -z "${TF_BACKEND_SUBSCRIPTION_ID-}" ]] && die "Missing required environment variable: [TF_BACKEND_SUBSCRIPTION_ID]"
  # [[ -z "${TF_BACKEND_TENANT_ID-}" ]] && die "Missing required environment variable: [TF_BACKEND_TENANT_ID]"
  # [[ -z "${TF_BACKEND_CLIENT_ID-}" ]] && die "Missing required environment variable: [TF_BACKEND_CLIENT_ID]"
  # [[ -z "${TF_BACKEND_CLIENT_SECRET-}" ]] && die "Missing required environment variable: [TF_BACKEND_CLIENT_SECRET]"
  # [[ -z "${CLOUDFLARE_API_TOKEN-}" ]] && die "Missing required environment variable: [CLOUDFLARE_API_TOKEN]"

  return 0
}

display_summary() {
  msg "Runner Parameters:" 
  msg " Command       [${action}]"
  msg " Preview       [${preview}]"
  msg " Configuration [${config}]"
  msg " Environment   [${environment}]"
  msg " TF Plan       [${plan_file}]"
  msg " TF State      [${tfstate_key}]"
}

list_configs() {
  configs=("${config_path}"/*/)

  for d in "${configs[@]}"; do
    ds="${d%/}"
    dn="${ds##*/}"
    msg "${dn}"
  done

  exit
}

azure_login() {
  msg "Setting Azure subscription [$ARM_SUBSCRIPTION_ID]"
  az account set --subscription $ARM_SUBSCRIPTION_ID
}

run_terraform_validate() {
  msg "Terraform Format Check"
  terraform fmt -check -recursive -diff

  msg "Terraform Init"
  terraform init -backend=false

  msg "Terraform Validate"
  terraform validate
}

run_terraform_init() {
  msg "Running Terraform init"
  terraform init -reconfigure -upgrade \
    -backend-config="key=${tfstate_key}" \
    -backend-config="resource_group_name=${TF_BACKEND_RESOURCE_GROUP}" \
    -backend-config="storage_account_name=${TF_BACKEND_STORAGE_ACCOUNT}" \
    -backend-config="container_name=${TF_BACKEND_CONTAINER}" \
    -backend-config="access_key=${TF_BACKEND_STORAGE_ACCESS_KEY}" \
    -backend-config="subscription_id=${TF_BACKEND_SUBSCRIPTION_ID}" \
    -backend-config="tenant_id=${TF_BACKEND_TENANT_ID}" \
    -backend-config="client_id=${TF_BACKEND_CLIENT_ID}" \
    -backend-config="client_secret=${TF_BACKEND_CLIENT_SECRET}"
}

run_terraform_plan() {
  msg "Running Terraform plan"
  terraform plan -var-file=${config_file} -out ${plan_file}
}

run_terraform_apply() {
  if [[ ! -e $plan_file ]] ; then
    die "Plan file not found.  Run the build command to create the terraform plan file first."
  fi

  msg "Running Terraform apply"
  terraform apply -input=false -auto-approve ${plan_file}
}

run_terraform_destroy_preview() {
  msg "Running Terraform destroy (preview)"
  terraform plan -var-file=${config_file} -destroy
}

run_terraform_destroy() {
  msg "Running Terraform destroy"
  terraform apply -var-file=${config_file} -destroy -auto-approve
}

run_terraform_import() {
  terraform_state_list="$(terraform state list)"
  msg "Terraform State resources"
  msg "${terraform_state_list-} \n"

  msg "Getting resources to import"
  import_list="$(terraform apply -input=false -auto-approve -var-file=${config_file} -no-color 2>&1 || true)"
  # if [ "$preview" = true ]; then msg "${import_list-} \n"; fi

  # Set initial values for resource id and import id
  resource_id="null"
  import_id="null"

  while IFS= read -r line; do
    if [[ $line == *"A resource with the ID"* ]]; then
      resource_id=$(echo "$line" | cut -d'"' -f2)
    fi

    if [[ $line == *"  with "* && $resource_id != "null" ]]; then
      import_id=$(echo "$line" | cut -d' ' -f4 | cut -d',' -f1)
    fi

    if [[ $resource_id != "null" && $import_id != "null" ]]; then
      tf_import_cmd="terraform import -var-file=${config_file} '$import_id' '$resource_id'"

      msg "Importing ${import_id-}"
      if [ "$preview" = true ]; then
        msg "Resource ID : $resource_id \n"
        # msg "Import CMD  : ${tf_import_cmd-}"
      else
        eval "$tf_import_cmd"
      fi

      resource_id="null"
      import_id="null"
    fi
  done <<< "$import_list"
}

execute_main() {
  # Check if config exists for the selected environment
  if [[ ! -e $config_file ]]; then
    msg "Config file not found. (${config_file})"
    exit 1
  fi

  # Show summary
  display_summary

  # Set working dir
  cd $tf_path

  # Azure CLI login
  if [ "$use_az_cli" = true ] ; then
    azure_login
  fi

  # Run Terraform Validate
  if [ "$action" = "validate" ] ; then
    run_terraform_validate
  fi

  # Run Terraform plan
  if [ "$action" = "build" ] ; then
    run_terraform_init
    run_terraform_plan
  fi

  # Run Terraform apply
  if [ "$action" = "deploy" ] ; then
    run_terraform_init
    run_terraform_apply
  fi

  # Run Terraform destroy preview
  if [ "$action" = "destroy" ] && [ "$preview" = true ] ; then
    run_terraform_init
    run_terraform_destroy_preview
  fi

  # Run Terraform destroy
  if [ "$action" = "destroy" ] && [ "$preview" = false ] ; then
    run_terraform_init
    run_terraform_destroy
  fi

  # Import existing resources not in Terraform state
  if [ "$action" = "import" ] ; then
    run_terraform_init
    # run_terraform_plan
    run_terraform_import
  fi
}

# ===[ script logic starts here ]==========================

# parse command line parameters
parse_params "$@"

# load and check environment variables.
load_env_file
check_env_vars

# Set config file and plan output paths 
config_file="$config_path/$config/$environment.tfvars"
plan_file="$plans_path/$config-$environment.tfplan"

# Set Terraform state key
tfstate_key="${TF_STATE_PREFIX:-}${config}-${environment}.tfstate"

# Execute Runner tasks
execute_main

exit 0