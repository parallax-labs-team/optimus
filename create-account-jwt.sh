#!/bin/bash

NAME="YOUR NAME"
AUTH_EMAIL="YOUR-EMAIL-HERE"
AUTH_PASSWORD="YOUR_PASSWORD"

curl -s -XPOST -H 'Content-Type: application/json' https://sandbox.primetrust.com/v2/users \
--data @- << BODY
{
    "data": {
        "type": "user",
        "attributes": {
            "email": "${AUTH_EMAIL}",
            "name": "${NAME}",
            "password": "${AUTH_PASSWORD}"
        }
    }
}
BODY

printf "\n\n"

jwt=$(curl -s -XPOST -u "${AUTH_EMAIL}:${AUTH_PASSWORD}" https://sandbox.primetrust.com/auth/jwts)

if ! command -v jq &> /dev/null
then
    printf "\n%s\n" "$jwt"
else
    printf "%s" "$jwt" | jq -r ".token"
fi
