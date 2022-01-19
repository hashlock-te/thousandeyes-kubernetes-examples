#!/bin/bash
GREEN='\033[92m'
BLUE='\033[96m'
YELLOW='\033[93m'
GREY='\033[37m'
CLEAR='\033[90m'

credFile="./te-credentials.yaml"

printf "${GREEN}Setting ThousandEyes Account Token${CLEAR}"
printf "\n"

if [[ -f "./$credFile" ]]; then
  printf "${BLUE}Credentials already set; to reset, delete ${YELLOW}$credFile${BLUE} and run again${CLEAR}\n"
else
  printf "${BLUE}Enter your ThousandEyes Account Group Token: ${YELLOW}"
  read ACCOUNT_TOKEN
  ACCOUNT_TOKEN_BASE64=$(echo $ACCOUNT_TOKEN | base64)
  printf "${CLEAR}"
  echo "apiVersion: v1
kind: Secret 
metadata: 
  name: te-credentials 
type: Opaque 
data: 
  ACCOUNT_TOKEN: ${ACCOUNT_TOKEN_BASE64}" > ./$credFile
  echo "Created base64 ThousandEyes token in $credFile"
fi