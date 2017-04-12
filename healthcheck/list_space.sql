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
	d.dbsnum,  
	name[1,18] dbspace,  
	CASE
		WHEN is_sbspace = 1 THEN
			'SmartBlob'
		WHEN is_blobspace = 1 THEN
			'Blob'
		WHEN is_temp = 1 THEN
			'Temporary'
		WHEN (SELECT COUNT(*) FROM sysplog p WHERE p.pl_chunk = c.chknum) > 0 THEN
			'Contains Phys Log'
		WHEN (SELECT COUNT(*) FROM syslogfil l WHERE l.chunk = c.chknum) > 0 THEN
			'Contains Logical Logs'
		ELSE
			'Data'
	END dbspace_type,
	COUNT(*) number_of_chunks,
	-- DBSPACE size
	FORMAT_UNITS(SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				udsize  
			ELSE  
				chksize  
		END * c.pagesize) , 'B',2) dbspace_size,  

	-- DBSPACE free
	FORMAT_UNITS(SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				udfree  
			ELSE  
				nfree  
		END * c.pagesize), 'B',2) dbspace_free,  

	-- DBSPACE used
	FORMAT_UNITS((SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				udsize  
			ELSE  
				chksize  
		END * c.pagesize) - SUM(  
			CASE  
				WHEN is_sbspace = 1 THEN  
					udfree  
				ELSE  
					nfree  
				END * c.pagesize)), 'B', 2)  dbspace_used,  

	-- DBSPACE Metadata
	FORMAT_UNITS(SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				mdsize * c.pagesize  
			ELSE  
				0  
		END ), 'B',2) dbspace_metadata,  

	-- DBSPACE Metadata free
	FORMAT_UNITS(SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				nfree  * c.pagesize
			ELSE  
				0
		END ), 'B',2) dbspace_md_free,  

	-- DBSPACE Metadata used
	FORMAT_UNITS((SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				mdsize * c.pagesize
			ELSE  
				0
		END ) - SUM(  
			CASE  
				WHEN is_sbspace = 1 THEN  
					nfree
				ELSE  
					0
				END * c.pagesize)), 'B', 2)  dbspace_md_used,  

	-- DBSPACE Percentage free
	ROUND((SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				udfree  
			ELSE  
				nfree  
		END)) / (SUM(  
			CASE  
				WHEN is_sbspace = 1 THEN  
					udsize  
				ELSE  
					chksize  
			END)) * 100, 1)::char(4) Percent_data_free,

	-- DBSPACE Percentage metadata free
	ROUND((SUM(  
		CASE  
			WHEN is_sbspace = 1 THEN  
				nfree  
			ELSE  
				0
		END)) / (SUM(  
			CASE  
				WHEN is_sbspace = 1 THEN  
					mdsize
				ELSE  
					1
			END)) * 100, 1)::char(4) Percent_md_free
FROM
	sysmaster:sysdbspaces d, sysmaster:syschunks c
WHERE
	d.dbsnum = c.dbsnum  
GROUP BY 1, 2, 3
ORDER By 1;
