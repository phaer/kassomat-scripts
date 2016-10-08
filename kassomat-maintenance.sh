#!/bin/bash
set -eu

LOCK_FILE="/tmp/maintenance_active"
if [ -f ${LOCK_FILE} ]
then echo "already in maintenance"; exit 1
else touch ${LOCK_FILE}
fi

finish() {
  rm ${LOCK_FILE}
  changeomatic start
}

trap finish EXIT
changeomatic stop
DISPLAY=:0 xterm \
  -n kassomat-maintenance \
  -T kassomat-maintenance \
  -fa "Monospace" -fs 20 \
  -e kassomat-set-coin-levels


