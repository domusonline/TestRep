#!/bin/ksh
#----------------------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2017 Fernando Nunes - domusonline@gmail.com
# 
# $Author: Fernando Nunes - domusonline@gmail.com $
# $Revision: 2.0.3 $
# $Date 2016-04-12 16:11:06$
# Disclaimer: This software is provided AS IS, without any kind of guarantee. Use at your own risk.
#             Although the author is/was an IBM employee, this software was created outside his job engagements.
#             As such, all credits are due to the author.
#----------------------------------------------------------------------------------------------------------------

show_header()
{
	printf "\n\n\n\n"
	printf "#------------------------------------------------------------------------------------------------------------------------------------\n# START %s\n#------------------------------------------------------------------------------------------------------------------------------------\n" "$1"
	printf "\n\n\n\n" >&2
	printf "#------------------------------------------------------------------------------------------------------------------------------------\n# START %s\n#------------------------------------------------------------------------------------------------------------------------------------\n" "$1" >&2
}

TMP_FILE=/tmp/data_collect.tmp

clean_up()
{
	rm -f $TMP_FILE
}

trap clean_up 0

OUTPUT_FILE=mon_${INFORMIXSERVER}_`date +"%Y%m%d%H%M"`.txt
ERROR_FILE=err_${INFORMIXSERVER}_`date +"%Y%m%d%H%M"`.txt
SCRIPT_DIR=`dirname $0`

cat /dev/null > ${OUTPUT_FILE}

exec 1>${OUTPUT_FILE} 2>${ERROR_FILE}
show_header "Info (INFORMIXSERVER, hostname, date)"
echo "INFORMIXSERVER: $INFORMIXSERVER"
echo "Hostname: `hostname`"
echo "Time: `date`"

show_header "Uptime and stats (last_stat_reset, uptime)"
dbaccess sysmaster $SCRIPT_DIR/last_stat_reset.sql
onstat -
uptime

show_header "Machine Info: sysmachineinfo"
dbaccess sysmaster <<EOF
SELECT * FROM sysmaster:sysmachineinfo
EOF

SO=`uname -s | tr "[:upper:]" "[:lower:]"`
export SO
case $SO in
        sunos*)
		AWK=nawk
		echo "Solaris detected... showing /etc/system and /etc/project"
		echo "/etc/system:"
		cat /etc/system
		printf "---------------------------------------------------------------------\n"
		echo "/etc/project:"
		cat /etc/project
                ;;
        osf*)
		AWK=awk
		echo "Tru64 detected... showing /etc/sysconfigtab"
		cat /etc/sysconfigtab
                ;;
        hp-ux)
		AWK=awk
		echo "HP-UX detected... showing kcmodule -a -d"
                ;;
        aix)
		AWK=awk
		echo "AIX detected... showing ???"
                ;;
        linux)
		AWK=awk
		echo "Linux detected... showing sysctl -a"
		sysctl -a
                ;;
	*)
		AWK=awk
		echo "Unknown system... showing nothing"
		;;
esac

show_header "Assert fail files"
DUMPDIR=`onstat -c | grep "^[ 	]*DUMPDIR" | awk '{print $2}'`
if [ -d "$DUMPDIR" ]
then
	echo "Contents of DUMPDIR ( $DUMPDIR ):"
	ls -lia $DUMPDIR
else
	echo "DUMPDIR ($DUMPDIR)is not defined"
fi

show_header "Mountpoints and space"
case $SO in
	sunos*)
		df -h
		;;
	osf*)
		df -k
		;;
	hp-ux)
		bdf -k
		;;
	aix)
		df -h
		;;
	linux)
		df -h
		;;
	*)
		df -k
		;;
esac

MY_USER=`id | $AWK -F"[()]" ' { print $2 } '`

show_header "Crontab (crontab -l)"
if [ "X${MY_USER}" = "Xinformix" ]
then
	crontab -l
else
	echo "Running with a non informix user ($MY_USER)"
fi
 

show_header "Extents (extents_unl.sql)"
dbaccess sysmaster $SCRIPT_DIR/extents_unl.sql
printf "Database                Table                           Extents Max     Avail   DBSpace\n"
printf "----------------------- ------------------------------- ------- ------- ------- ---------------------\n"
cat $TMP_FILE

show_header "Sequential Scans (ixseqscans -r)"
ixseqscans -r

show_header "Sequential Scans (ixseqscans -d)"
ixseqscans -d

show_header "Session memory (onstat -g ses | sort -nk 7)"
onstat -g ses | sort -nk 7

show_header "Engine memory segments (onstat -g seg)"
onstat -g seg

show_header "Buffer cache (onstat -p)"
onstat -p

show_header "User sessions (onstat -u)"
onstat -u

show_header "LRUs (onstat -F)"
onstat -F

show_header "LRUs (onstat -R)"
onstat -R

show_header "Logical Logs (onstat -l)"
onstat -l

show_header "Checkpoints (onstat -g ckp)"
onstat -g ckp

show_header "Cache usage (onstat -P)"
onstat -P | awk '/partnum/,/^$/ {print $1"|"$2"|"$3"|"$4"|"$5"|"$6}' | egrep -v -e "partnum|\|\|\|\|" > $TMP_FILE
dbaccess sysmaster <<EOF
CREATE TEMP TABLE run_all_cache_usage
(
	partnum INTEGER,
	total INTEGER,
	btree INTEGER,
	data INTEGER,
	other INTEGER,
	dirty INTEGER
);

LOAD FROM $TMP_FILE INSERT INTO run_all_cache_usage;

UNLOAD TO $TMP_FILE
SELECT
	NVL(
		(TRIM(t.dbsname)||':'||TRIM(TRAILING FROM t.tabname)),
		'UNKNOWN:'||my.partnum
	),
	my.total,
	my.btree,
	my.data,
	my.other,
	my.dirty
FROM run_all_cache_usage my, outer systabnames t
WHERE my.partnum = t.partnum
ORDER BY 2 DESC;
EOF

awk -F'|' 'BEGIN {
printf "%-64s %-10s %-10s %-10s %-10s %-10s\n", "Database:Table", "Total", "BTree", "Data", "Other", "Dirty";
printf "---------------------------------------------------------------- ---------- ---------- ---------- ---------- ----------\n";
}
{
	printf "%-64s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6;
}' $TMP_FILE

#onstat -P

show_header "Page reads (ixtop -H none -p pagereads)"
ixtop -H none -p pagreads


show_header "Chunk list (onstat -d)"
onstat -d
show_header "Archive status (onstat -g arc)"
onstat -g arc
show_header "Server environment (onstat -g env)"
onstat -g env
show_header "Server replication HDR (onstat -g dri)"
onstat -g dri 
show_header "Server replication RSS (onstat -g rss)"
onstat -g rss
show_header "Server replication CM (onstat -g cmsm)"
onstat -g cmsm
show_header "Server I/O stats (onstat -g ioa)"
onstat -g ioa

show_header "Instance profile counters (list_profile.sql)"
dbaccess sysmaster $SCRIPT_DIR/list_profile.sql

show_header "Tasks (list_tasks.sql)"
dbaccess sysadmin $SCRIPT_DIR/list_tasks.sql

show_header "Big tables (big_tables.sql)"
dbaccess sysmaster $SCRIPT_DIR/big_tables.sql

show_header "Databases (list_databases.sql)"
dbaccess sysmaster $SCRIPT_DIR/list_databases.sql

show_header "Atached indexes (attached_indexes.sql)"
dbaccess sysmaster $SCRIPT_DIR/attached_indexes.sql

show_header "DBSPACE usage (list_space.sql)"
dbaccess sysmaster $SCRIPT_DIR/list_space.sql

show_header "Possible tables with chaining"
dbaccess sysmaster <<EOF
UNLOAD TO $TMP_FILE
SELECT
        TRIM(t.dbsname)||':'||TRIM(t.tabname),
        p.rowsize, p.pagesize,
        TRUNC(p.rowsize / p.pagesize,1) pper_row

FROM
        systabnames t, sysptnhdr p
WHERE
        t.partnum = p.lockid
        AND (p.rowsize / p.pagesize) > 1
ORDER BY 4 DESC;
EOF
awk -F'|' 'BEGIN {
printf "%-80s %-10s %-10s %-10s\n", "Database:Table", "Row Size", "Pagesize", "Pages/Row";
printf "-------------------------------------------------------------------------------- ---------- ---------- ----------\n";
}
{
	printf "%-80s %-10s %-10s %-10s\n", $1, $2, $3, $4;
}' $TMP_FILE

show_header "Lock Level (lock_level.sql)"
#$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/lock_level.sql | egrep -v -e "^data_base" -e "^$"
$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/lock_level.sql | egrep -v -e "^data_base|^$"

show_header "Table stats (list_table_stats.sql)"
$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/list_table_stats.sql /tmp/list_table_stats.unl /tmp/all_table_stats.unl

$AWK -F'|' 'BEGIN {
printf "%-20s %-7s %-25s %-10s %-13s %-13s %-10s %-15s %-10s\n", "Database", "TabId", "Table", "NRows", "Low Built", "Dist Built", "DistNRows", "Dist Dur", "Real NRows";
printf "-------------------- ------- ------------------------- ---------- ------------- ------------- ---------- --------------- ----------\n";
}
{
	printf "%-20s %-7s %-25s %-10s %-13s %-13s %-10s %-15s %-10s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9;
}' /tmp/all_table_stats.unl
rm -f /tmp/all_table_stats.unl /tmp/list_table_stats.unl

show_header "Database privileges (list_privileges.sql)"
#$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/list_privileges.sql | egrep -v -e "^data_base" -e "^$"
$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/list_privileges.sql | egrep -v -e "^data_base|^$"

show_header "Instance trusts"
if [ -r /etc/hosts.equiv ]
then
	echo /etc/hosts.equiv
	cat /etc/hosts.equiv
	printf "---------------------------------------------------------------------\n"
else
	echo "Cannot find/read /etc/hosts.equiv"
fi

if [ -r ~informix/.rhosts ]
then
	echo ~informix/.rhosts
	cat ~informix/.rhosts
	printf "---------------------------------------------------------------------\n"
else
	echo "Cannot find/read ~informix/.rhosts"
fi
#For 11.70+
REMOTE_SERVER_CFG=`onstat -c | egrep "^[ 	]*REMOTE_SERVER_CFG" | awk '{print $2}'`
if [ -r "$REMOTE_SERVER_CFG" ]
then
	echo REMOTE_SERVER_CFG: $REMOTE_SERVER_CFG
	cat $REMOTE_SERVER_CFG
	printf "---------------------------------------------------------------------\n"
else
	echo "REMOTE_SERVER_CFG is not configured"
fi
REMOTE_USER_CFG=`onstat -c | egrep "^[ 	]*REMOTE_USER_CFG" | awk '{print $2}'`
if [ -r "$REMOTE_USER_CFG" ]
then
	echo REMOTE_USER_CFG: $REMOTE_USER_CFG
	cat $REMOTE_USER_CFG
	printf "---------------------------------------------------------------------\n"
else
	echo "REMOTE_SERVER_CFG is not configured"
fi

if [ -r $INFORMIXDIR/etc/hosts.equiv ]
then
	echo \$INFORMIXDIR/etc/hosts.equiv
	cat $INFORMIXDIR/etc/hosts.equiv
else
	echo "Cannot read/find \$INFORMIXDIR/etc/hosts.equiv"
fi

show_header "Object state (obj_state.sql)"
$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/obj_state.sql

show_header "Procedures with PDQ (proc_pdq.sql)"
$SCRIPT_DIR/ixrunalldbs $SCRIPT_DIR/proc_pdq.sql


show_header "Cache suggestion (ixcaches)"
ixcaches

show_header "Sysadmin mon_checkpoints (mon_checkpoint.sql)"
dbaccess sysadmin <<EOF
UNLOAD TO $TMP_FILE
SELECT
	intvl, type,
	caller, DBINFO('utc_to_datetime',clock_time) ckp_clock_time,
	TRUNC(crit_time,8), TRUNC(flush_time,8), TRUNC(cp_time,8), n_dirty_buffs, TRUNC(block_time,8)
FROM
	mon_checkpoint
ORDER BY 4 DESC
EOF
awk -F'|' 'BEGIN {
printf "%-10s %-15s %-15s %-19s %-10s %-10s %-10s %-10s %-10s\n", "Interval", "Type", "Caller", "Clock Time", "Crit Time", "Flush time", "Ckp Time", "Buff Dirty", "Block Time";
printf "---------- --------------- --------------- ------------------- ---------- ---------- ---------- ---------- ----------\n"
}
{
	printf "%-10s %-15s %-15s %-19s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9;
}' $TMP_FILE

show_header "ONCONFIG"
cat $INFORMIXDIR/etc/$ONCONFIG

show_header "Online.log"
ONLINE_LOG=`cat $INFORMIXDIR/etc/$ONCONFIG | grep "^[ 	]*MSGPATH" | awk '{print $2}'`
ONLINE_LOG=`eval echo $ONLINE_LOG`
if [ ! \( -r $ONLINE_LOG -a -f $ONLINE_LOG \) ]
then
	echo "Could not get online.log filename: $ONLINE_LOG"
else
	tail -5000 $ONLINE_LOG
fi


show_header "Alarm Program"
ALARM_SCRIPT=`cat $INFORMIXDIR/etc/$ONCONFIG | egrep -e "^[ 	]*ALARMPROGRAM" | $AWK '{print $2}'`
ALARM_SCRIPT=`eval echo $ALARM_SCRIPT`
if [ ! \( -r $ALARM_SCRIPT -a -f $ALARM_SCRIPT \) ]
then
	echo "Could not get alarm program filename: $ALARM_SCRIPT"
else
	cat $ALARM_SCRIPT
fi

show_header "Informix machine notes"
if [ -r $INFORMIXDIR/release/en_us/0333/*machine_notes*.txt ]
then
	cat $INFORMIXDIR/release/en_us/0333/*machine_notes*.txt
else
	printf "Could not open/access the IDS machine notes\n"
fi

show_header "syslicenseinfo"
dbaccess sysmaster <<EOF
UNLOAD TO $TMP_FILE
SELECT
        version, week, year, max_cpu_vps, max_vps, max_conns, max_sec_conns, max_sds_conns, max_sds_clones,
        max_rss_clones, total_size, total_size_used, max_memory, max_memory_used, feature_flags, feature_flags2
FROM syslicenseinfo
EOF

$AWK -F'|' 'BEGIN {
printf "%-12s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-10s %-10s %-10s %-10s %-10s %-10s\n", "version", "week", "year", "MCVPs", "MCPUs", "MConn", "MSecC", "MSDSC", "MSDSC", "MRSSC", "Tot Size", "TotSizeUse", "Max Mem", "Max MemUse", "Fea Flag", "Fea Flag 2";
printf "------------ ----- ----- ----- ----- ----- ----- ----- ----- ----- ---------- ---------- ---------- ---------- ---------- ----------\n";
}
{
        printf "%-12s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-5s %-10s %-10s %-10s %-10s %-10s %-10s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16;
}' $TMP_FILE
