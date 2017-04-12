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
	DBINFO('dbname')::CHAR(20) data_base,
	username[1,20],
	CASE usertype
		WHEN 'D' THEN
			'DBA'
		WHEN 'C' THEN
			'CONNECT'
		WHEN 'R' THEN
			'RESOURCE'
		ELSE
			usertype
	END::CHAR(10) privilege
FROM sysusers
ORDER BY 3
