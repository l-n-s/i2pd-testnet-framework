#! /bin/bash
FLAG=$1

while true; do
    if [ "$( ip address show dev CONT_IFNAME | grep inet | grep CONT_IFNAME )" ];
    then
        I2PD_DIR/i2pd --datadir I2PD_DIR $FLAG
        break
    else
        echo "$( hostname ) --> CONT_IFNAME is not ready, re-trying in 3 seconds"
        sleep 3
    fi
done;
