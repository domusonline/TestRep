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
select tk_name[1,28], tk_start_time, tk_stop_time, tk_frequency, 
case tk_type
	WHEN 'TASK' THEN
		"TASK"
		WHEN "SENSOR" THEN
		"SENSOR"
		WHEN "STARTUP SENSOR" THEN
		"S SENSOR"
		WHEN "STARTUP TASK" THEN
		"S TASK"
		END type
from ph_task where tk_enable = 't';
