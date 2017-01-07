#!/bin/bash
LOGFILE_NAME="ips.log"
LASTLINE=$(tail -n 1 "${LOGFILE_NAME}")
gzip -9 "$LOGFILE_NAME"
mv "${LOGFILE_NAME}.gz" "${LOGFILE_NAME%log}$(date +%F_%H%M%S).log.gz"
echo "${LASTLINE}" > "$LOGFILE_NAME"
