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
{
objtype  I
owner    informix
name      100_1
tabid    100
state    E
}
SELECT
	SUBSTR(DBINFO('dbname'),1,20) dbname,
	SUBSTR(t.tabname,1,20) tabname,
	SUBSTR(o.name,1,20) obj_name,
	CASE objtype
		WHEN 'I' THEN
			'Index'
		WHEN 'C' THEN
			'Constraint'
		ELSE
			objtype
	END::CHAR(10) obj_type,
	state st
FROM
	systables t, sysobjstate o
WHERE
	t.tabid = o.tabid AND
	state != 'E'
ORDER BY
	tabname, obj_name
