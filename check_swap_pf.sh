#!/bin/bash

# Sacamos los parametros
TOTAL=$(snmpwalk -v2c -c public $1 .1.3.6.1.4.1.2021.4.3.0 | awk '{print $4}')
FREE=$(snmpwalk -v2c -c public $1  .1.3.6.1.4.1.2021.4.4.0 | awk '{print $4}')

# Cambiamos los valores a MiB
TOTAL=$(($TOTAL / 1000))
FREE=$(($FREE / 1000))
USED=$(($TOTAL - $FREE))

# Sacamos los porcentajes
#PORC_FREE=$(($TOTAL * 100 / $FREE))
PORC_USED=$(($USED * 100 / $TOTAL))

# Sacamos la informacion
if [[ $PORC_USED -lt $2 ]]
   then
      echo "OK: Total: $TOTAL MiB - Free: $FREE MiB - Percent Used: $PORC_USED""%"
      exit 0
elif [[ $PORC_USED -ge $2 && $PORC_USED -le $3 ]]
   then
      echo "Warning: Total: $TOTAL MiB - Free: $FREE MiB - Percent Used: $PORC_USED""%"
      exit 1
elif [[ $PORC_USED -ge $3 ]]
   then
      echo "Critical: Total: $TOTAL MiB - Free: $FREE MiB - Percent Used: $PORC_USED""%"
      exit 2
else
   echo "UNKNOW"
   exit 3
fi
