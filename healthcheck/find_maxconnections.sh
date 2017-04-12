# Name: $RCSfile: find_maxconnections.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/find_maxconnections.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/find_maxconnections.sh,v 1.2 2011/03/09 16:25:41 fnunes Exp $
# Revision: $Revision: 1.2 $
# Revised on: $Date: 2011/03/09 16:25:41 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:

#00:06:25  Maximum server connections 273

ONLINELOG=$1

egrep -e "^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) *[0-9][0-9]* [0-9]*:[0-9]*:[0-9]* [0-9][0-9][0-9][0-9] *$" -e "Maximum server connections" $ONLINELOG  | awk ' BEGIN {
		MONTH_ARRAY["Jan"] = "01";
		MONTH_ARRAY["Feb"] = "02";
		MONTH_ARRAY["Mar"] = "03";
		MONTH_ARRAY["Apr"] = "04";
		MONTH_ARRAY["May"] = "05";
		MONTH_ARRAY["Jun"] = "06";
		MONTH_ARRAY["Jul"] = "07";
		MONTH_ARRAY["Aug"] = "08";
		MONTH_ARRAY["Sep"] = "09";
		MONTH_ARRAY["Oct"] = "10";
		MONTH_ARRAY["Nov"] = "11";
		MONTH_ARRAY["Dec"] = "12";
		LONGTX_START_FLAG=0;
		LONGTX_END_FLAG=0;
		}

/^Mon|^Tue|^Wed|^Thu|^Fri|^Sat|^Sun/ {
#		print $0;
		MONTH_NAME=$2;
		if ( MONTH_NAME in MONTH_ARRAY)
		{
			MONTH=MONTH_ARRAY[MONTH_NAME];
		}
		else
		{
			MONTH=-1;
		}
		
		DAY=$3;
		if (DAY >= 1 && DAY <= 9)
			DAY="0"DAY;
		HOUR=$4;
		YEAR=$5;
	}

#00:06:25  Maximum server connections 273
/Maximum server connections/ {
#		print $0
		MAX_CONN=$5
		HOUR_START=$1
		DATE_START=YEAR"-"MONTH"-"DAY" "HOUR_START;
		printf "0|"DATE_START"|"MAX_CONN"|\n";
	}
'
