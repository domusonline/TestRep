#!/bin/ksh
# Name: $RCSfile: merge_unloads.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/merge_unloads.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/merge_unloads.sh,v 1.1 2011/03/09 18:42:20 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 18:42:20 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:


show_help()
{
	echo "${PROGNAME} <initial_date> <end_date>" >&2
	echo "Ex: ${PROGNAME} 20110226 20110203" >&2
}

PROGNAME=`basename $0`
VERSION=`echo "$Revision: 1.1 $" | cut -f2 -d' '`

if [ $# != 2 ]
then
	show_help
	exit 1
else
	INITIAL_DATE=$1
	END_DATE=$2
	if [ ${INITIAL_DATE} -gt ${END_DATE} ]
	then
		echo "End date ( ${END_DATE} ) must be greater or equal than initial date ( ${INITIAL_DATE} )" >&2
		exit 1
	fi
fi

for PREFIX in ixmon_dbwho_ ixmon_locks_ ixmon_memory_ ixmon_profile_ ixmon_space_ ixmon_syscheckpoint_ ixmon_sysptprof_ ixmon_systabinfo_
do
	for FICH in `ls ${PREFIX}*.unl`
	do
		INSTANCE=`echo ${FICH} | awk -F'_' '{for(n=3;n<=NF-1;n++){ printf $n};printf "\n"}'`
		UNLOAD_FILE=${PREFIX}${INSTANCE}.unl
		CURR_DATE=`echo ${FICH} | awk -F'_' '{print $NF}' | awk -F'.' '{print $1}'`
		if [ $CURR_DATE -ge ${INITIAL_DATE} -a ${CURR_DATE} -le ${END_DATE} ]
		then
			cat ${FICH} >> ${UNLOAD_FILE}
		fi
	done

	case $PREFIX in
	ixmon_dbwho*)
		TABLE=who
		;;
	ixmon_locks*)
		TABLE=locks
		;;
	ixmon_memory*)
		TABLE=memory
		;;
	ixmon_profile*)
		TABLE=sysprofile
		;;
	ixmon_space*)
		TABLE=space
		;;
	ixmon_syscheckpoint*)
		TABLE=syscheckpoint
		;;
	ixmon_sysptprof*)
		TABLE=ptprof
		;;
	ixmon_systabinfo*)
		TABLE=tabinfo
		;;
	esac
	printf "LOCK TABLE ${TABLE} IN EXCLUSIVE MODE;\nLOAD FROM `pwd`/$UNLOAD_FILE INSERT INTO ${TABLE};\nUNLOCK TABLE ${TABLE};\n" >>load_files_${INSTANCE}.sql
done

