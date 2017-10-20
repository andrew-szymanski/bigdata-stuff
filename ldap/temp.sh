
=========================
list group members AD

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


ldapsearch -x -H ${LDAP_URL} -b 'o=axa.be' "(cn=${GROUP_ID})" | grep memberUid

ldapsearch -w $(cat ${BIND_PASSWORD_FILE}) -x -H ${LDAP_URL} -D ${BIND_USER} -b 'OU=Groups,OU=Users and groups,OU=Axa,DC=AXA-BE,DC=INTRAXA' "(CN=${GROUP_ID})" member | grep 'member:'

exit $RC

=========================
list group members LDAP

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

LDAP_ENV_FILE="./ldap.env"

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


ldapsearch -x -H ${LDAP_URL} -b 'o=axa.be' "(cn=${GROUP_ID})" | grep memberUid


exit $RC

=========================
list groups AD

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** Active Directory LDAP query: list groups matching specified pattern 
# *** or $DEFAULT_PATTERN if pattern not specified
# ****************************************
log "$0 starting..."

DEFAULT_PATTERN="glb_ods*"
LDAP_ENV_FILE="./active_directory.env"

# check env file exists
if [ ! -f ${LDAP_ENV_FILE} ]; then
	log "ERROR: env file not found: [${LDAP_ENV_FILE}]"
	exit 1
fi

# source env file
. ${LDAP_ENV_FILE}

# check we have env vars we need
ENV_VARIABLES="LDAP_URL BIND_USER BIND_PASSWORD_FILE"
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

PATTERN=${1:-"$DEFAULT_PATTERN"}
log "PATTERN: [${PATTERN}]"


ldapsearch -w $(cat ${BIND_PASSWORD_FILE}) -x -H ${LDAP_URL} -D ${BIND_USER} -b 'OU=Groups,OU=Users and groups,OU=Axa,DC=AXA-BE,DC=INTRAXA' "(CN=${PATTERN})" cn | grep 'cn:'


exit $RC

=========================
list groups LDAP

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query: list groups matching specified pattern 
# *** or $DEFAULT_PATTERN if pattern not specified
# ****************************************
log "$0 starting..."

DEFAULT_PATTERN="gu*"
LDAP_ENV_FILE="./ldap.env"

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

PATTERN=${1:-"$DEFAULT_PATTERN"}
log "PATTERN: [${PATTERN}]"

ldapsearch -x -H ${LDAP_URL} -b 'o=axa.be' "(&(objectClass=posixGroup)(cn=${PATTERN}))" cn | grep 'cn:'


exit $RC

======================
list user groups AD

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query - list groups user belongs to
# ****************************************

# input arg should be userid to search for
: ${1?"ERROR: you must specify userid, i.e $0 <userid>"}
#  Script exits here if command-line parameter absent,

USER_ID=$1
log "USER_ID: [${USER_ID}]"

LDAP_ENV_FILE="./active_directory.env"

# check env file exists
if [ ! -f ${LDAP_ENV_FILE} ]; then
	log "ERROR: env file not found: [${LDAP_ENV_FILE}]"
	exit 1
fi

# source env file
. ${LDAP_ENV_FILE}

# check we have env vars we need
ENV_VARIABLES="LDAP_URL BIND_USER BIND_PASSWORD_FILE"
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


ldapsearch -w $(cat ${BIND_PASSWORD_FILE}) -x -H ${LDAP_URL} -D ${BIND_USER} -b 'OU=Users and groups,OU=Axa,DC=AXA-BE,DC=INTRAXA' "(&(objectClass=Group)(memberOf=${USER_ID}))" 




exit $RC

====================
list user groups LDAP

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query - list groups user belongs to
# ****************************************

# input arg should be userid to search for
: ${1?"ERROR: you must specify userid, i.e $0 <userid>"}
#  Script exits here if command-line parameter absent,

USER_ID=$1
log "USER_ID: [${USER_ID}]"

LDAP_ENV_FILE="./ldap.env"

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


ldapsearch -x -H ${LDAP_URL} -b 'o=axa.be' "(&(objectClass=posixGroup)(memberUid=${USER_ID}))" | grep 'cn:'


exit $RC

=======================
query user AD

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query
# ****************************************

# input arg should be userid to search for
: ${1?"ERROR: you must specify userid, i.e $0 <userid>"}
#  Script exits here if command-line parameter absent,

USER_ID=$1
log "USER_ID: [${USER_ID}]"

LDAP_ENV_FILE="./active_directory.env"

# check env file exists
if [ ! -f ${LDAP_ENV_FILE} ]; then
	log "ERROR: env file not found: [${LDAP_ENV_FILE}]"
	exit 1
fi

# source env file
. ${LDAP_ENV_FILE}

# check we have env vars we need
ENV_VARIABLES="LDAP_URL BIND_USER BIND_PASSWORD_FILE"
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


# check password file exists / is readable
if [ ! -f ${BIND_PASSWORD_FILE} ]; then
  log "ERROR: env file not found / not readable: [${BIND_PASSWORD_FILE}]"
  exit 1
fi


ldapsearch -w $(cat ${BIND_PASSWORD_FILE}) -x -H ${LDAP_URL} -D ${BIND_USER} -b 'OU=Managed users,OU=Users and groups,OU=Axa,DC=AXA-BE,DC=INTRAXA' "(CN=${USER_ID})"



exit $RC

=============================
query user LDAP

#!/usr/bin/env bash

log() {
    date "+%m-%d:%H:%M:%S $*" 
}

# ****************************************
# *** LDAP query
# ****************************************

# input arg should be userid to search for
: ${1?"ERROR: you must specify userid, i.e $0 <userid>"}
#  Script exits here if command-line parameter absent,

USER_ID=$1
log "USER_ID: [${USER_ID}]"

LDAP_ENV_FILE="./ldap.env"

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


ldapsearch -x -H ${LDAP_URL} -b 'ou=People,o=axa.be' "(axauidunix=${USER_ID})"



exit $RC
