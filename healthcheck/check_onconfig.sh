#!/bin/ksh

PROGNAME=`basename $0`
TMP_FILE_1=/tmp/${PROGNAME}_$$_1
TMP_FILE_2=/tmp/${PROGNAME}_$$_2
TMP_FILE_3=/tmp/${PROGNAME}_$$_3


comment_obsolete()
{
cat $1 | awk ' BEGIN {
                i=1;
                while (getline < "obsolete_params" )
                {
                        OBS[i]=$0;
                        i++;
                }
        }
        {
                PARAMETER=$1;
                for(a=1;a<i;a++)
                {
                        if ( PARAMETER ~ OBS[a] )
                        {
                                print "#OBSOLETE:";
                                break;
                        }
                }
                print $0;
        }
'
}



print_usage()
{
        echo "${PROGNAME} <ONCONFIG_FILE> [ ONCONFIG_PARAMS ]"
        echo
}

if [ $# -lt 1 ]
then
        print_usage
        exit 1
else
        case $# in
        1)
                ONCONFIG_FILE=$1
                ONCONFIG_PARAMS_FILE=onconfig_params
                ;;
        2)
                ONCONFIG_FILE=$1
                ONCONFIG_PARAMS_FILE=$2
                ;;
        *)
                print_usage
                exit 1
        esac
fi

if [ ! -f $ONCONFIG_FILE ]
then
        echo "ONCONFIG file specified does not exist!" >&2
        exit 1
else
        if [ ! -r $ONCONFIG_FILE ]
        then
                echo "ONCONFIG file cannot be read (check permissions?)" >&2
                exit 1
        fi
fi
if [ ! -f $ONCONFIG_PARAMS_FILE ]
then
        echo "ONCONFIG parameter file specified does not exist!" >&2
        exit 1
else
        if [ ! -r $ONCONFIG_PARAMS_FILE ]
        then
                echo "ONCONFIG parameter file cannot be read (check permissions?)" >&2
                exit 1
        fi
fi

echo "#New Parameters:" > $TMP_FILE_3

egrep -v -e "^#" -e "^$" $ONCONFIG_FILE | awk '{print "^"$1}' > $TMP_FILE_1
egrep -E -v -f $TMP_FILE_1 $ONCONFIG_PARAMS_FILE > $TMP_FILE_2
cat $ONCONFIG_FILE $TMP_FILE_3 $TMP_FILE_2 > $TMP_FILE_1
comment_obsolete $TMP_FILE_1 > ${ONCONFIG_FILE}.new
rm -f $TMP_FILE_1 $TMP_FILE_2 $TMP_FILE_3
