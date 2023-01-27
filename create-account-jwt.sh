#!/bin/bash

NAME=""
AUTH_EMAIL=""
AUTH_PASSWORD=""

if [[ -z "$NAME" || -z "$AUTH_EMAIL" || -z "$AUTH_PASSWORD" ]]
then
    echo "Credentials aren't fully specified, please define NAME/AUTH_EMAIL/AUTH_PASSWORD"
    exit 1
fi

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
