# Name: $RCSfile: find_bar_archives.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/find_bar_archives.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/find_bar_archives.sh,v 1.1 2011/03/09 10:46:42 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 10:46:42 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:


if [ $# = 1 ]
then
	BAR_LOG=$1
else
	BAR_LOG=`onstat -c | egrep -e "^[ 	]*BAR_ACT_LOG" | nawk 'print $2'`
fi

egrep -e "onbar_d |Archive|Begin backup logical log|Completed backup logical log" $BAR_LOG  | awk ' BEGIN {
		BACKUP_START_FLAG=0;
		BACKUP_LOG_START_FLAG=0;
		BACKUP_LOG_END_FLAG=0;
}

/onbar_d -b -l/ {
		if ( BACKUP_LOG_START_FLAG == 0 )
		{
#			LEVEL="L"
			LOG_HOUR_START=$2;
			LOG_DATE_START=$1;
			BACKUP_LOG_START_FLAG=1;
			BACKUP_LOG_END_FLAG=1;
			LOG_PID=$4;
			LOGICAL_LOG_NUMBER=""
		}
		else
		{
			if ( BACKUP_LOG_START_FLAG < 0 )
				printf "Debug: logical log start flag less than zero: %s.\nDebug: %s\n", BACKUP_LOG_START_FLAG, $0;

			BACKUP_LOG_START_FLAG=BACKUP_LOG_START_FLAG+1;
			BACKUP_LOG_END_FLAG=BACKUP_LOG_END_FLAG+1;
		}
}

/onbar_d -b -w -L/ {
		if ( BACKUP_START_FLAG == 1 )
		{
			printf "NOTOK_d|"LEVEL"|"DATE_START" "HOUR_START"||"$1" "$2"|||"$4"|\n";
		}
		if ( BACKUP_START_FLAG == 2 )
		{
			printf "NOTOK_d|"LEVEL"|"DATE_START" "HOUR_START"|"START_DATE_START" "START_HOUR_START"|"$1" "$2"|||"$4"|\n";
		}
		LEVEL=$NF;
		HOUR_START=$2;
		DATE_START=$1;
		BACKUP_START_FLAG=1;
		PID=$4;
		LOGICAL_LOGS_BACKUP_0="";
}
/Archive started/ {
		
		START_HOUR_START=$2
		START_DATE_START=$1
		if ( BACKUP_START_FLAG != 1 )
		{
			printf "Error in backup state (1). BACKUP_START_FLAG: %s\n%s", BACKUP_START_FLAG, $0;
#			exit 1;
		}
		BACKUP_START_FLAG=2;
#		printf "Debug: backup start_flag change to 2\n%s\n", $0;
	}
/Archive .*ABORTED/ {
		if ( BACKUP_START_FLAG != 0 )
		{
			HOUR_STOP=$2
			DATE_STOP=$1
			printf "NOTOK|"LEVEL"|"DATE_START" "HOUR_START"|"START_DATE_START" "START_HOUR_START"|"DATE_STOP" "HOUR_STOP"|-1||"$4"|\n";
			BACKUP_START_FLAG=1;
#		printf "Debug: backup start_flag change to 1 archive aborted\n%s\n", $0;
		}
	}

/Completed backup logical log/ {
	if ( $4 == PID )
	{
		if ( LOGICAL_LOGS_BACKUP_0 == "" )
		{
			LOGICAL_LOGS_BACKUP_0=$9;
		}
		LOGICAL_LOGS_BACKUP_0_END=$9;
	}
	else
	{
		if ( $4 == LOG_PID)
		{
			if ( LOGICAL_LOG_NUMBER == "" )
			{
				LOGICAL_LOG_NUMBER=$9;
			}
			LOGICAL_LOG_NUMBER_END=$9;
		}
	}
}

/onbar_d complete/ {
		if ( (BACKUP_START_FLAG != 0) || (BACKUP_LOG_START_FLAG != 0) )
		{
			if ( $4 == PID )
			{
				HOUR_STOP=$2
				DATE_STOP=$1
				RC=$8
				if ( RC == 0 )
				{
					STATUS="OK";
				}
				else
				{
					STATUS="NOTOK";
				}
				printf STATUS"|"LEVEL"|"DATE_START" "HOUR_START"|"START_DATE_START" "START_HOUR_START"|"DATE_STOP" "HOUR_STOP"|"RC"|"LOGICAL_LOGS_BACKUP_0" - "LOGICAL_LOGS_BACKUP_0_END"|"$4"|\n";
				BACKUP_START_FLAG=0;
#		printf "Debug: backup start_flag change to 0 onbar_d complete 4=PID\n%s\n", $0;
				next;
			}
			LOG_HOUR_STOP=$2
			LOG_DATE_STOP=$1
			RC=$8
			if ( RC == 0 )
			{
				STATUS="OK";
				printf STATUS"|L|"LOG_DATE_START" "LOG_HOUR_START"||"LOG_DATE_STOP" "LOG_HOUR_STOP"|"RC"|"LOGICAL_LOG_NUMBER" - "LOGICAL_LOG_NUMBER_END"|"$4"|\n";
			}
			else
			{
				STATUS="NOTOK";
				printf STATUS"|L|"LOG_DATE_START" "LOG_HOUR_START"||"LOG_DATE_STOP" "LOG_HOUR_STOP"|"RC"||"$4"|\n";
			}
			BACKUP_LOG_START_FLAG=BACKUP_LOG_START_FLAG-1;
			BACKUP_LOG_END_FLAG=BACKUP_LOG_END_FLAG-1;
		}
}
/Archive .*Completed/ {
		if ( BACKUP_START_FLAG == 2 )
		{
			HOUR_STOP=$2;
			DATE_STOP=$1;
			BACKUP_START_FLAG=1;
#			printf "Debug: backup start_flag change to 1 archve completed\n%s\n", $0;
		}
#		else
#			print "Debug: backup start_flag not changed";
			
}
'
