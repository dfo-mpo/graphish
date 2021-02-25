#!/bin/sh

echo 'Example: ./test_nlp.sh http://localhost:8000/process/ nlp_input.json'

curl -w '\n' -X POST $1 -H "Content-Type: application/json" -H "Accept: application/json" -d @$2 | python -m json.tool
