#!/usr/bin/env bash


log() {
    date "+%m-%d:%H:%M:%S $*" 
}


# source env file
ENV_FILE="./ldap.env"
. ${ENV_FILE}

# input arg should be userid to search for
: ${1?"Usage: $0 USERID"}
#  Script exits here if command-line parameter absent,
#+ with following error message.
#    usage-message.sh: 1: Usage: usage-message.sh ARGUMENT

echo "These two lines echo only if command-line parameter given."
echo "command-line parameter = \"$1\""

USERID=$1

# verify we have all env vars needed
ENV_VARIABLES="LDAP_HOST LDAP_PORT"
ERROR=0
for ENV_VAR in ${ENV_VARIABLES}; do
   VALUE=${!ENV_VAR}
   log "   $ENV_VAR: [$VALUE]"
   if [ -z "${VALUE}" ]; then
      log "ERROR: variable [$ENV_VAR] not defined, check [${ENV_FILE}] env file"
      ERROR=1
   fi
done
if [ $ERROR -ne 0 ]; then
   log "ERROR: some of required env variables not defined (see above)"
   exit 1
fi




# ldapsearch -h ldaphostname -p 389
