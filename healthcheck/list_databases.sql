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
--List databases

SELECT
    -- use dbinfo function to convert partnum to dbspace
    --SUBSTR(DBINFO("DBSPACE",a.partnum),1,19) dbspace,
    DBINFO("DBSPACE",a.partnum)::CHAR(18) dbspace,
    a.name::CHAR(18) database,
    a.owner::CHAR(17) db_owner,
    a.is_logging::CHAR log,
    a.is_buff_log::CHAR buf,
    b.dbs_collate::CHAR(12) dbs_locale
FROM
    sysmaster:sysdatabases a, sysdbslocale b
WHERE
    a.name = b.dbs_dbsname
ORDER BY
    dbspace, database
