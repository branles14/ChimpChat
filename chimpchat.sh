#!/bin/bash

error() {
  echo "${1:-Unknown error}" >&2
  exit 1
}

load_config() {
  if [[ -f .config ]]; then
    source .config
  else
    manage_config
  fi

  if [[ -z "$dataset_owner" || -z "$dataset_name" || -z "$dataset_keyfile" || -z "$openai_api_key" ]]; then
    manage_config
  elif [[ "$1" == "--update" ]]; then
    manage_config
  fi
}

manage_config() {
  touch .config && source .config || error "manage_config failed"
  local opts=("dataset_owner" "dataset_name" "dataset_keyfile" "openai_api_key")
  local prompt value

  for opt in "${opts[@]}"; do
    if [[ -z "${!opt}" ]]; then
      prompt="Enter $opt: "
    else
      prompt="$opt is set to '$current_value'. Change? (y/n): "
    fi

    read -p "$prompt" value
    if [[ -z "$value" ]]; then
      error "aborted"
    else
      eval "$opt=\"$value\""
      unset value
    fi
  done

  echo "dataset_owner=\"$dataset_owner\""      > .config
  echo "dataset_name=\"$dataset_name\""       >> .config
  echo "dataset_keyfile=\"$dataset_keyfile\"" >> .config
  echo "openai_api_key=\"$openai_api_key\""   >> .config
}

error_checks() {
  :
}

main() {
  # Load configuration
  if [[ "$1" == "--config" ]]; then
    load_config --update
  else
    load_config
  fi

  error_checks
}

main "$@"
