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
    id integer,
    intvl integer,
    type char(12),
    caller char(10),
    clock_time integer,
    crit_time float,
    flush_time float,
    cp_time float,
    n_dirty_buffs integer,
    plogs_per_sec integer,
    llogs_per_sec integer,
    dskflush_per_sec integer,
    ckpt_logid integer,
    ckpt_logpos integer,
    physused integer,
    logused integer,
    n_crit_waits integer,
    tot_crit_wait float,
    longest_crit_wait float,
    block_time float
}
SELECT
	intvl,
	type,
	caller,
	DBINFO('utc_to_datetime',clock_time) ckp_clock_time,
	crit_time,
	flush_time,
	cp_time,
	n_dirty_buffs,
	block_time
FROM
	mon_checkpoint
ORDER BY block_time DESC
