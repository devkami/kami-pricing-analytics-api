#!/bin/bash

# Function to try a request multiple times with an interval
# $1: Number of attempts
# $2: Interval between attempts (in seconds)
# ${@:3}: Arguments for curl
attempt_request() {
  local retries=$1
  local interval=$2
  local cmd=("curl" "-f" "-s" "${@:3}")
  
  for i in $(seq 1 $retries); do
    echo "Attempt $i of $retries for the request: ${cmd[*]}"
    if "${cmd[@]}" > /dev/null; then
      echo "Success on the request after $i attempts."
      return 0
    fi
    sleep $interval
  done
  echo "Failure after $retries attempts."
  return 1
}

# Check 1: GET /api/docs with 3 attempts and 1-second interval
if ! attempt_request 3 1 http://0.0.0.0:8001/api/docs; then
  exit 1
fi

# Check 2: POST /api/research with url for beleza_na_web |  with 3 attempts and 6-second interval
if ! attempt_request 3 6 -X 'POST' 'http://0.0.0.0:8001/api/research' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{ "url": "https://www.belezanaweb.com.br/amend-complete-repair-shampoo-250ml/ofertas-marketplace", "strategy_option": 0 , "store_result": false}'; then
  exit 1
fi

# Check 3: POST /api/research with marketplace and marketplace_id for amazon |  with 3 attempts and 24-second interval
if ! attempt_request 3 24 -X 'POST' 'http://0.0.0.0:8001/api/research' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{ "marketplace": "amazon", "marketplace_id": "B07GYX8QRJ", "strategy_option": 0 , "store_result": false}'; then
  exit 1
fi

# Check 4: POST /api/research with marketplace and marketplace_id for mercado livre |  with 3 attempts and 12-second interval
if ! attempt_request 3 12 -X 'POST' 'http://0.0.0.0:8001/api/research' -H 'accept: application/json' -H 'Content-Type: application/json' -d '{ "url": "https://produto.mercadolivre.com.br/MLB-1448733946", "strategy_option": 0 , "store_result": false}'; then
  exit 1
fi
