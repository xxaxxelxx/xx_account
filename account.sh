#!/bin/bash
SPLITBASEDIR="/customer"
CUSTOMER=$1
PRICELIST_PER_GBYTE_IN_EURO="$(echo $2 | sed 's|\,|\.|g')"
DISCOUNTTYPE="$3"
OIFS=$IFS;IFS=$'|';A_PRICELIST_PER_GBYTE_IN_EURO=($PRICELIST_PER_GBYTE_IN_EURO);IFS=$OIFS
for STEP in "${A_PRICELIST_PER_GBYTE_IN_EURO[@]}"; do
    A_PRICELIST_PER_GBYTE_IN_EURO_REV=($STEP ${A_PRICELIST_PER_GBYTE_IN_EURO_REV[@]})
done

SLEEP=60

#WORKDIR="$SPLITBASEDIR/$CUSTOMER/logs"
WORKDIR="/mnt/docker/HOMEGROWN/TEST"
test -d $WORKDIR || exit

while true; do
    case $DISCOUNTTYPE in
    retroactive)
	TOFFSET=0
	while [ $TOFFSET -lt 86401 ]; do
	    NOW=$(date +%s)
	    TSTAMP=$(date -d @$(($NOW - $TOFFSET)) +%Y_%m)
	    test -r $WORKDIR/$TSTAMP.bytesum
	    if [ $? -eq 0 ]; then
		cat $WORKDIR/$TSTAMP.bytesum | grep '[[:digit:]]' > /dev/null
		if [ $? -eq 0 ]; then
		    GBYTES=$(echo "$(cat $WORKDIR/$TSTAMP.bytesum) / ( 1024 * 1024 * 1024 )" | bc) #"
		    PRICE=0
		    for STEP in "${A_PRICELIST_PER_GBYTE_IN_EURO[@]}"; do
			OIFS=$IFS;IFS=$'#';A_PRICE_PER_GBYTE_IN_EURO=($STEP);IFS=$OIFS
			BEYOND=${A_PRICE_PER_GBYTE_IN_EURO[0]}
			PRICE=${A_PRICE_PER_GBYTE_IN_EURO[1]}
			if [ $GBYTES -ge $BEYOND ]; then
			    ACCOUNT=$(echo "scale=2;( $GBYTES * $PRICE )" | bc) #"
			fi    
		    done
		    GBYTES_PRINT=$(echo $GBYTES | sed 's/\(...\)$/\.\1/') #'
		    echo "Actually you have to pay $ACCOUNT Euro for $GBYTES_PRINT Gbytes. ($PRICE Euro per GByte)" > $WORKDIR/$TSTAMP.account.txt
		fi
	    fi
	    TOFFSET=$(($TOFFSET + ( 86400 * 31 )))
	done
    ;;
    *)
	TOFFSET=0
	while [ $TOFFSET -lt 86401 ]; do
	    NOW=$(date +%s)
	    TSTAMP=$(date -d @$(($NOW - $TOFFSET)) +%Y_%m)
	    test -r $WORKDIR/$TSTAMP.bytesum
	    if [ $? -eq 0 ]; then
		cat $WORKDIR/$TSTAMP.bytesum | grep '[[:digit:]]' > /dev/null
		if [ $? -eq 0 ]; then
		    GBYTES=$(echo "$(cat $WORKDIR/$TSTAMP.bytesum) / ( 1024 * 1024 * 1024 )" | bc) #"
		    ACCOUNT=0
		    GBYTES_TOTAL=$GBYTES
		    for STEP in "${A_PRICELIST_PER_GBYTE_IN_EURO_REV[@]}"; do
			OIFS=$IFS;IFS=$'#';A_PRICE_PER_GBYTE_IN_EURO=($STEP);IFS=$OIFS
			BEYOND=${A_PRICE_PER_GBYTE_IN_EURO[0]}
			PRICE=${A_PRICE_PER_GBYTE_IN_EURO[1]}
			if [ $GBYTES -ge $BEYOND ]; then
			    GBYTES_COUNTED=$(($GBYTES - $BEYOND))
			    ACCOUNT=$(echo "scale=2;( ( $GBYTES_COUNTED * $PRICE ) + $ACCOUNT )" | bc) #"
			    GBYTES=$BEYOND
			fi    
		    done
		    GBYTES_PRINT=$(echo $GBYTES_TOTAL | sed 's/\(...\)$/\.\1/') #'
		    echo "Actually you have to pay $ACCOUNT Euro for $GBYTES_PRINT Gbytes." > $WORKDIR/$TSTAMP.account.txt
		fi
	    fi
	    TOFFSET=$(($TOFFSET + ( 86400 * 31 )))
	done
    ;;
    esac

    exit
    sleep $SLEEP
done
exit
