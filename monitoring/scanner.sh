#! /bin/bash
# Disciver alive hosts in the subnet

OUTFILE=$1
SUBNET=$2

if [ ! $SUBNET ]; then
    SUBNET="10.0.3."
    echo "Scanning default subnet "$SUBNET"0/24" >&2
fi

if [ ! $OUTFILE ]; then
    OUTFILE="iplist.txt"
    echo "Saving to default file "$OUTFILE >&2
fi

start_scan () {
    for x in `seq 0 255`; do 
        nc -zv -w1 $SUBNET$x 7070 &
    done
}

start_scan 2>&1 |grep succe|cut -d " " -f 3 > $OUTFILE
echo "File $OUTFILE ready" >&2
