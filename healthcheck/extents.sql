-----------------------------------------------------------------------------------------------------------------
-- Copyright (c) 2010-2017 Fernando Nunes - domusonline@gmail.com
-- 
-- $Author: Fernando Nunes - domusonline@gmail.com $
-- $Revision: 2.0.3 $
-- $Date 2016-04-12 16:11:06$
-- Disclaimer: This software is provided AS IS, without any kind of guarantee. Use at your own risk.
--             Although the author is/was an IBM employee, this software was created outside his job engagements.
--             As such, all credits are due to the author.
-----------------------------------------------------------------------------------------------------------------
--Obtains the maximum number of extents per table, the current number and how many are free



SELECT
    t.dbsname database, t.tabname table,
    pt.nextns current_ext,
    pt.nextns + trunc(pg_frcnt / 8) max_ext,
    trunc(pg_frcnt / 8) free_ext,
    d.name dbspace
FROM
    sysmaster:systabnames t,
    sysmaster:syspaghdr p,
    sysmaster:sysptnhdr pt,
    sysmaster:sysdbstab d
WHERE
    pt.partnum = t.partnum AND
    p.pg_partnum = sysmaster:partaddr(sysmaster:partdbsnum(t.partnum),1) AND
    p.pg_pagenum = sysmaster:partpagenum(t.partnum) AND
    t.dbsname NOT IN ('sysmaster') and
    d.dbsnum = sysmaster:partdbsnum(t.partnum)
ORDER BY 5
