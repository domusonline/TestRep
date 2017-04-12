#!/bin/ksh
# Name: $RCSfile: extract_info.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/extract_info.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/extract_info.sh,v 1.1 2011/03/09 18:42:19 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 18:42:19 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:

show_help()
{
	echo "${PROGNAME} <instance> <online.log|NULL> <bar_act.log|NULL>" >&2
}

PROGNAME=`basename $0`
VERSION=`echo "$Revision: 1.1 $" | cut -f2 -d' '`

if [ $# != 3 ]
then
	show_help
	exit 1
else
	INSTANCE=$1
	ONLINE_LOG=$2
	BAR_LOG=$3
fi

if [ ${ONLINE_LOG} != NULL ]
then
	if [ ! -r ${ONLINE_LOG} ]
	then
		echo "Online log ( ${ONLINE_LOG} ) does not exist!" >&2
		exit 1
	else
		printf "Processing archives from online.log...\n"	
		find_archives.sh ${ONLINE_LOG} > arch_${INSTANCE}.unl
		printf "LOAD FROM `pwd`/arch_${INSTANCE}.unl INSERT INTO archives;\n" >> load_info_files_${INSTANCE}.sql

		printf "Processing checkpoints from online.log...\n"	
		find_checkpoint.sh ${ONLINE_LOG} > checkpoints_${INSTANCE}.unl
		printf "LOCK TABLE checkpoints IN EXCLUSIVE MODE;\nLOAD FROM `pwd`/checkpoints_${INSTANCE}.unl INSERT INTO checkpoints;\nUNLOCK TABLE checkpoints;\n" >> load_info_files_${INSTANCE}.sql
#		find_checkpoint_v10.sh

		printf "Processing evidences from online.log...\n"	
		find_evidences.sh ${ONLINE_LOG} > evidences_${INSTANCE}.txt

		printf "Processing max connections from online.log...\n"	
		find_maxconnections.sh ${ONLINE_LOG} > max_conns_${INSTANCE}.unl
		printf "LOCK TABLE maxconnections IN EXCLUSIVE MODE;\nLOAD FROM `pwd`/max_conns_${INSTANCE}.unl INSERT INTO maxconnections;\nUNLOCK TABLE maxconnections;\n" >> load_info_files_${INSTANCE}.sql

		printf "Processing long transactions from online.log...\n"	
		find_longtx.sh ${ONLINE_LOG} > longtx_${INSTANCE}.unl
		printf "LOAD FROM `pwd`/longtx_${INSTANCE}.unl INSERT INTO longtxs;" >> load_info_files_${INSTANCE}.sql
	fi
fi

if [ ${BAR_LOG} != NULL ]
then
	if [ ! -r ${BAR_LOG} ]
	then
		echo "BAR activity log ( ${BAR_LOG} ) does not exist!" >&2
		exit 1
	else
		printf "Processing onbar archives from bar_act.log...\n"	
		find_bar_archives.sh ${BAR_LOG} > arch_bar_${INSTANCE}.unl
		printf "LOAD FROM `pwd`/arch_bar_${INSTANCE}.unl INSERT INTO archives_bar;" >> load_info_files_${INSTANCE}.sql
	fi
fi
