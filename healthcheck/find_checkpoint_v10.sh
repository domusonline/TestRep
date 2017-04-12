# Name: $RCSfile: find_checkpoint_v10.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/find_checkpoint_v10.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/find_checkpoint_v10.sh,v 1.1 2011/03/09 10:46:42 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 10:46:42 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:

#23:56:15  Checkpoint Completed:  duration was 3 seconds.
#23:56:15  Thu Apr 22 - loguniq 13606851, logpos 0x8a4018, timestamp: 0xa7e5b240 Interval: 24733
#23:56:15  Maximum server connections 273
#23:56:15  Checkpoint Statistics - Avg. Txn Block Time 0.000, # Txns blocked 1, Plog used 2828, Llog used 19240

ONLINELOG=$1

egrep -e "^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) *[0-9][0-9]* [0-9]*:[0-9]*:[0-9]* [0-9][0-9][0-9][0-9] *$" -e "Checkpoint Completed:" -e "loguniq .*logpos .*timestamp:" $ONLINELOG  | awk ' BEGIN {
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

#V10:
#18:47:13  Fuzzy Checkpoint Completed:  duration was 1 seconds, 3604 buffers not flushed.
#18:37:11  Checkpoint loguniq 513700, logpos 0xc6f94c, timestamp: 0x884a517a

#V11
#23:56:15  Checkpoint Completed:  duration was 3 seconds.
#23:56:15  Thu Apr 22 - loguniq 13606851, logpos 0x8a4018, timestamp: 0xa7e5b240 Interval: 24733
#23:56:15  Checkpoint Statistics - Avg. Txn Block Time 0.000, # Txns blocked 1, Plog used 2828, Llog used 19240
/Checkpoint Completed:/ {
#		print $0
		DURATION=$6
		HOUR_CKP=$1
		CKP_TSTAMP=YEAR"-"MONTH"-"DAY" "HOUR_CKP;
	}
/Fuzzy Checkpoint Completed:/ {
#		print $0
		DURATION=$7
		HOUR_CKP=$1
		CKP_TSTAMP=YEAR"-"MONTH"-"DAY" "HOUR_CKP;
	}
/loguniq.*logpos.*timestamp/ {
#		print $0;
		LLOG=$4;
		gsub(",", "",LLOG);
		LLOGPOS=$6;
		gsub(",", "",LLOGPOS);
		TIMESTAMP=$8;
		gsub(",", "",TIMESTAMP);
		printf "%s|%s|%s|%s|%s\n", CKP_TSTAMP, DURATION, LLOG, LLOGPOS, TIMESTAMP;
	}
'
