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
UNLOAD TO /tmp/list_table_stats.unl
SELECT
	DBINFO('dbname')::CHAR(32) dbname,
	t.tabid,
	t.tabname::CHAR(32) table,
	t.nrows::INT8 n_rows,
	EXTEND(t.ustlowts, YEAR TO HOUR) low_built,
	MIN(EXTEND(d.constr_time, YEAR TO HOUR)) dist_built,
	MAX(d.ustnrows)::INT8 dist_nrows,
--	MAX(d.ustbuildduration) dist_dur,
	MAX('No SELECT'),
	-- This needs review... because of the join with sysdistrib the query "multiplies" the rows from sysptnhdr.
	-- The DISTINCT is a workaround... if different parttions have same nrows the result will be wrong
	SUM(DISTINCT p.nrows)::INT8 real_nrows
FROM
	systables t, sysmaster:systabnames t1, sysmaster:sysptnhdr p, OUTER sysdistrib d
WHERE
	d.tabid = t.tabid AND
	t.tabtype = 'T' AND
	t.partnum = t1.partnum AND
	t.tabname = t1.tabname AND
	t1.dbsname = DBINFO('dbname') AND
	p.lockid = t.partnum
GROUP BY
	1, 2, 3, 4, 5
ORDER BY
	5
