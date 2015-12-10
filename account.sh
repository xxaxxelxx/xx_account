#!/bin/bash
SPLITBASEDIR="/customer"
CUSTOMER=$1
PRICE_PER_MBYTE_IN_CENT=$( echo "$2" | sed 's|\,|\.|g')
SLEEP=60

test -d $SPLITBASEDIR/$CUSTOMER/logs || exit

while true; do
    test -r $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).bytesum || ( sleep $SLEEP; continue )
    MBYTES=$(echo "$(cat $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).bytesum) / ( 1024 * 1024 )" | bc) #"
    ACCOUNT=$(echo "scale=2;( $MBYTES * $PRICE_PER_MBYTE_IN_CENT ) / 100" | bc) #"
    echo $ACCOUNT > $SPLITBASEDIR/$CUSTOMER/logs/$(date +%Y_%m).account
sleep $SLEEP
done
exit
