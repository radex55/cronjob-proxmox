#!/bin/bash

# Declare Constants
DeviceID="<your-device-id>"
ClientID="<your-client-id>"
ClientSecret="<your-client-secret>"
BaseUrl="https://openapi.tuyaus.com"
Commands='{"commands":[{"code":"switch_1","value":false}]}'
tuyatime=$(date +%s000)

# Get Access Token
URL="/v1.0/token?grant_type=1"
StringToSign="${ClientID}${tuyatime}GET\n"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"\n\n${URL}"
AccessTokenSign=$(printf "$StringToSign" | openssl sha256 -hmac "$ClientSecret" | awk '{print toupper($0)}' | sed 's/^.*= //')
AccessTokenResponse=$(curl -sSLkX GET "$BaseUrl$URL" \
    -H "sign_method: HMAC-SHA256" \
    -H "client_id: $ClientID" \
    -H "t: $tuyatime"  \
    -H "mode: cors" \
    -H "Content-Type: application/json" \
    -H "sign: $AccessTokenSign")
AccessToken=$(echo $AccessTokenResponse | sed "s/.*\"access_token\":\"//g"  |sed "s/\".*//g")

# Send commands to turn ON the device
URL="/v1.0/devices/$DeviceID/commands"
StringToSign="${ClientID}${AccessToken}${tuyatime}POST\n$(echo -n "$Commands" | openssl dgst -sha256 | sed "s/.*[ ]//g")\n\n${URL}"
PostSign=$(printf $StringToSign | openssl sha256 -hmac  "$ClientSecret" | awk '{print toupper($0)}' | sed 's/^.*= //')
PostResponse=$(curl -sSLkX POST "$BaseUrl$URL" \
    -H "sign_method: HMAC-SHA256" \
    -H "client_id: $ClientID" \
    -H "t: $tuyatime" \
    -H "mode: cors" \
    -H "Content-Type: application/json" \
    -H "sign: $PostSign" \
    -H "access_token: $AccessToken" \
    -d "$Commands")

# Success message
timestamp=$(date '+%-I:%M%p 'on' %-m-%-d-%Y' | sed 's/AM/am/;s/PM/pm/')
success=$(echo "$PostResponse" | grep -o '"success":[^,]*' | awk -F ':' '{print $2}')
if [ "$success" = "true" ]; then
    echo "Device turned ON successfully at $timestamp"
else
    echo "Device failed to be turned ON at $timestamp"
fi
