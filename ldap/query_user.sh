#!/usr/bin/env bash

ENV_FILE="./ldap.env"

. ${ENV_FILE}




ldapsearch -h ldaphostname -p 389
