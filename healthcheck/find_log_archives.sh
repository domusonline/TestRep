#!/bin/ksh
# Name: $RCSfile: find_archives.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/find_archives.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/find_archives.sh,v 1.1 2011/03/09 10:46:42 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 10:46:42 $
# Revised by: $Author: fnunes $ 
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:



ONLINELOG=$1

egrep -e "^(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) *[0-9][0-9]* [0-9]*:[0-9]*:[0-9]* [0-9][0-9][0-9][0-9] *$" -e "Logical Log" $ONLINELOG  | awk ' BEGIN {
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
		BACKUP_START_FLAG=0;
		BACKUP_END_FLAG=0;
		}

/^Mon|^Tue|^Wed|^Thu|^Fri|^Sat|^Sun/ {
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

#05:24:19  Logical Log 7897 Complete, timestamp: 0x4311c34a.
#05:24:20  Logical Log 7897 - Backup Started
#05:24:21  Logical Log 7897 - Backup Completed

/Logical Log.*Complete,/ {
		
		LOG=$4;
		LEVEL=$3;
		HOUR_START=$1
		DATE_START=YEAR"-"MONTH"-"DAY" "HOUR_START;
		if ( BACKUP_START_FLAG == 1 )
			printf "NOTOK|"LEVEL"|"DATE_START"||\n";
		BACKUP_START_FLAG=1;
	}
/Archive .*ABORTED/ {
		if ( BACKUP_START_FLAG == 1 )
		{
			HOUR_STOP=$1
			DATE_STOP=YEAR"-"MONTH"-"DAY" "HOUR_STOP;
			printf "NOTOK|"LEVEL"|"DATE_START"|"DATE_STOP"|\n";
		}
		BACKUP_START_FLAG=0;
		BACKUP_END_FLAG=0;
	}
/Archive .*Completed/ {
		if ( BACKUP_START_FLAG == 1 )
		{
			HOUR_STOP=$1
			DATE_STOP=YEAR"-"MONTH"-"DAY" "HOUR_STOP;
			printf "OK|"LEVEL"|"DATE_START"|"DATE_STOP"|\n";
		}
		BACKUP_START_FLAG=0;
		BACKUP_END_FLAG=0;
	}
'
