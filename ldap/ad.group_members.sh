#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query
# ****************************************

# input arg should be userid to search for
: ${1?"ERROR: you must specify groupid, i.e $0 <groupid>"}
#  Script exits here if command-line parameter absent,

GROUP_ID=$1
log "GROUP_ID: [${GROUP_ID}]"

LDAP_ENV_FILE="./active_directory.env"

# check env file exists
if [ ! -f ${LDAP_ENV_FILE} ]; then
	log "ERROR: env file not found: [${LDAP_ENV_FILE}]"
	exit 1
fi

# source env file
. ${LDAP_ENV_FILE}

# check we have env vars we need
ENV_VARIABLES="LDAP_URL"
ERROR=0
for ENV_VAR in ${ENV_VARIABLES}; do
   VALUE=${!ENV_VAR}
   log "   $ENV_VAR: [$VALUE]"
   if [ -z "${VALUE}" ]; then
      log "ERROR: variable [$ENV_VAR] not defined, check [${LDAP_ENV_FILE}] env file"
      ERROR=1
   fi
done
if [ $ERROR -ne 0 ]; then
   log "ERROR: some of required env variables not defined (see above)"
   exit 1
fi


ldapsearch -w $(cat ${BIND_PASSWORD_FILE}) -x -H ${LDAP_URL} -D ${BIND_USER} -b 'OU=Groups,OU=Users and groups,OU=XXX,DC=YYYYY,DC=ZZZZZZZ' "(CN=${GROUP_ID})" member | grep 'member:'

exit $RC