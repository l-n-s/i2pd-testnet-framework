#! /bin/bash
# Monitor list of i2pd nodes in realtime
# Takes IP address from the file iplist.txt

IPLIST=$1
if [ ! $IPLIST ]; then
    echo "USAGE: $1 iplist.txt"
    exit
fi

while read ip; do
    PAGE=$( wget -q -O- -T0 -t1 http://$ip:7070/ )
    TCSRATE=$( echo "$PAGE" | grep "success rate" | cut -d " " -f 5 | cut -d "<" -f 1 )
    NSTAT=$( echo "$PAGE" | grep status | cut -d " " -f 3 | cut -d "<" -f 1 )
    ROUTERS=$( echo "$PAGE" |grep Floodfills |cut -d " " -f 2 )
    FFS=$( echo "$PAGE" |grep Floodfills |cut -d " " -f 4 )
    LSS=$( echo "$PAGE" |grep Floodfills |cut -d " " -f 6 |cut -d "<" -f1)
    CTUNS=$( echo "$PAGE" |grep "Transit Tunnels" |cut -d " " -f 3 )
    TTUNS=$( echo "$PAGE" |grep "Transit Tunnels" |cut -d " " -f 6 |cut -d "<" -f1)
    if [ "$PAGE" != "" ]; then
        echo "$ip $NSTAT TCSRate: $TCSRATE --> Rs: $ROUTERS, FFs: $FFS, LSets: $LSS, Tuns C/T: $CTUNS/$TTUNS"
    else
        echo $ip is down
    fi
done < $IPLIST
