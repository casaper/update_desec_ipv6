#!/bin/bash
USERNAME="your_faboulous_domainname.dedyn.io"
PASSWORD="your_dedyn_update_password"
# the interface to check for changing ip
INTERFACE="eth0"
# the chosen logfile name (needs to match the one in logrotate.sh)
LOGFILE_NAME="ips.log"

IP6_NOW=$(ip -6 address show ${INTERFACE} scope global | grep inet6 | egrep -o '[0-9a-f]{1,4}:.*:[0-9a-f]{1,4}')
NOW=$(date +%F_%H:%M:%S)

function updateDedyn() {
  curl -s "https://update6.dedyn.io/update?username=${1}&password=${2}"
}

if [ -e "${LOGFILE_NAME}" ]; then
  LASTIP=$(tail -n 1 ips.log | cut -d ';' -f 2)
  echo "${NOW};${IP6_NOW}" >> "${LOGFILE_NAME}"
  if ! [ $LASTIP=$IP6_NOW ]; then
    logger -p local0.notice -t DEDYNUPDATE "IP6 on dedyn updated $(updateDedyn "${USERNAME}" "${PASSWORD}")"
  fi
else
  echo "${NOW};${IP6_NOW}" > "${LOGFILE_NAME}"
  logger -p local0.notice -t DEDYNUPDATE "IP6 on dedyn updated $(updateDedyn "${USERNAME}" "${PASSWORD}")"
fi

exit 0
