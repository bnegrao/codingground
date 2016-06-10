function fix {
    while read IP TYPE HOUR DATE; do
        #echo DEBUG $IP $TYPE $HOUR $DATE 1>&2
        if [ ! -z "$PREVIOUS_IP" ]; then
            if [ $IP == $PREVIOUS_IP ]; then
                TYPE=both
                [[ $DATE < $PREVIOUS_DATE ]] && DATE="$PREVIOUS_DATE"
                EQUAL_IPS=true
            else
                echo $PREVIOUS_LINE
                EQUAL_IPS=false
            fi
        fi
        PREVIOUS_DATE="$DATE"
        PREVIOUS_IP=$IP;
        PREVIOUS_LINE="$IP $TYPE $HOUR $DATE";
    done
    [ "$EQUAL_IPS" == true ] && echo $PREVIOUS_LINE
}

LOGFILE=$1

cat $LOGFILE | awk '{print $3 " " $4 " " $1 " " $2;}' | \
  sort | fix | awk '{print $3 " " $4 " " $1 " " $2;}' | sort