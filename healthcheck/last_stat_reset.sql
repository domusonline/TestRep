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
--Time of last reset statistics
--Credits: Lester Knutsen (Advanced Datatools)


SELECT
    CURRENT YEAR TO SECOND now,
    DBINFO ('utc_to_datetime',sh_pfclrtime) last_reset_time,
    DBINFO ('utc_to_datetime',sh_boottime) boot_time
FROM
    sysmaster:sysshmvals;
