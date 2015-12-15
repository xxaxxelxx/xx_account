#!/bin/bash
SPLITBASEDIR="/customer"
CUSTOMER=$1
PRICE_PER_MBYTE="$(echo $2 | sed 's|\,|\.|g')"
SLEEP=60

test -d $SPLITBASEDIR/$CUSTOMER/logs || exit

while true; do
    TOFFSET=0
    while [ $TOFFSET -lt 86401 ]; do
	NOW=$(date +%s)
	TSTAMP=$(date -d @$(($NOW - $TOFFSET)) +%Y_%m)
	test -r $SPLITBASEDIR/$CUSTOMER/logs/$TSTAMP.bytesum
	if [ $? -eq 0 ]; then
	    cat $SPLITBASEDIR/$CUSTOMER/logs/$TSTAMP.bytesum | grep '[[:digit:]]' > /dev/null
	    if [ $? -eq 0 ]; then
		MBYTES=$(echo "$(cat $SPLITBASEDIR/$CUSTOMER/logs/$TSTAMP.bytesum) / ( 1024 * 1024 )" | bc) #"
		ACCOUNT=$(echo "scale=2;( $MBYTES * $PRICE_PER_MBYTE ) / 100" | bc) #"
		echo "$ACCOUNT Euro for $MBYTES MBytes" | sed 's|^\.|0\.|' > $SPLITBASEDIR/$CUSTOMER/logs/$TSTAMP.account.txt
	    fi
	fi
	TOFFSET=$(($TOFFSET + 86400))
    done
    sleep $SLEEP
done
exit
