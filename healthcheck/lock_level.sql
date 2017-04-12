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
-- counts the tables with each lock level mode

SELECT
	DBINFO('dbname')::CHAR(32) data_base,
	CASE locklevel
		WHEN 'R' THEN 'Row'
		WHEN 'P' THEN 'Page'
		ELSE 'Unexpected!'
	END lock_level,
	COUNT(*) num_tables
FROM
	systables
WHERE
	tabtype = 'T'
GROUP BY 1,locklevel;
