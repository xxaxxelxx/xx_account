#!/bin/bash
SPLITBASEDIR="/customer"
CUSTOMER=$1
PRICE_PER_MBYTE="$(echo $2 | sed 's|\,|\.|g')"
SLEEP=60

test -d $SPLITBASEDIR/$CUSTOMER/logs || exit

while true; do
    test -r $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).bytesum
    if [ $? -eq 0 ]; then
	cat $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).bytesum | grep '[[:digit:]]' > /dev/null
	if [ $? -eq 0 ]; then
	    MBYTES=$(echo "$(cat $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).bytesum) / ( 1024 * 1024 )" | bc) #"
	    ACCOUNT=$(echo "scale=2;( $MBYTES * $PRICE_PER_MBYTE ) / 100" | bc) #"
	    echo "$ACCOUNT Euro for $MBYTES MBytes" | sed 's|^\.|0\.|' > $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).account.txt
	fi
    fi
    sleep $SLEEP
done
exit
