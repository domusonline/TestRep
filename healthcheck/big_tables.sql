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
SELECT
	t.dbsname[1,18] database, t.tabname[1,19] tabname, t1.tabname[1,18] partname,
	pt.npused::char(8) pages, pt.nrows::CHAR(10) rows
--, d.name, pt.partnum
FROM
	sysmaster:systabnames t,
	sysmaster:systabnames t1,
	sysmaster:sysptnhdr pt,
	sysmaster:sysdbstab d
WHERE
	t.partnum = pt.lockid AND
	pt.partnum = t1.partnum AND
	t.dbsname NOT IN ('sysmaster') and
	d.dbsnum = sysmaster:partdbsnum(t.partnum) and
	pt.npused >= 10000000
ORDER by 4 DESC, 1, 2, 3
