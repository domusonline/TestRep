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
--f.procname,
SUBSTR(DBINFO('dbname'),1,32) data_base,
CASE data[1,3]
	WHEN "AAA" THEN 0
	WHEN "AQA" THEN 1
	WHEN "AAE" THEN 1
	WHEN "AgA" THEN 2
	WHEN "AAI" THEN 2
	WHEN "AwA" THEN 3
	WHEN "AAM" THEN 3
	WHEN "BAA" THEN 4
	WHEN "AAQ" THEN 4
	WHEN "BQA" THEN 5
	WHEN "AAU" THEN 5
	WHEN "BgA" THEN 6
	WHEN "AAY" THEN 6
	WHEN "BwA" THEN 7
	WHEN "AAc" THEN 7
	WHEN "CAA" THEN 8
	WHEN "AAg" THEN 8
	WHEN "CQA" THEN 9
	WHEN "AAk" THEN 9
	WHEN "CgA" THEN 10
	WHEN "AAo" THEN 10
	WHEN "CwA" THEN 11
	WHEN "AAs" THEN 11
	WHEN "DAA" THEN 12
	WHEN "AAw" THEN 12
	WHEN "DQA" THEN 13
	WHEN "AA0" THEN 13
	WHEN "DgA" THEN 14
	WHEN "AA4" THEN 14
	WHEN "DwA" THEN 15
	WHEN "AA8" THEN 15
	WHEN "EAA" THEN 16
	WHEN "ABA" THEN 16
	WHEN "EQA" THEN 17
	WHEN "ABE" THEN 17
	WHEN "EgA" THEN 18
	WHEN "ABI" THEN 18
	WHEN "EwA" THEN 19
	WHEN "ABM" THEN 19
	WHEN "FAA" THEN 20
	WHEN "ABQ" THEN 20
	WHEN "FQA" THEN 21
	WHEN "ABU" THEN 21
	WHEN "FgA" THEN 22
	WHEN "ABY" THEN 22
	WHEN "FwA" THEN 23
	WHEN "ABc" THEN 23
	WHEN "GAA" THEN 24
	WHEN "ABg" THEN 24
	WHEN "GQA" THEN 25
	WHEN "ABk" THEN 25
	WHEN "GgA" THEN 26
	WHEN "ABo" THEN 26
	WHEN "GwA" THEN 27
	WHEN "ABs" THEN 27
	WHEN "HAA" THEN 28
	WHEN "ABw" THEN 28
	WHEN "HQA" THEN 29
	WHEN "AB0" THEN 29
	WHEN "HgA" THEN 30
	WHEN "AB4" THEN 30
	WHEN "HwA" THEN 31
	WHEN "AB8" THEN 31
	WHEN "IAA" THEN 32
	WHEN "ACA" THEN 32
	WHEN "IQA" THEN 33
	WHEN "ACE" THEN 33
	WHEN "IgA" THEN 34
	WHEN "ACI" THEN 34
	WHEN "IwA" THEN 35
	WHEN "ACM" THEN 35
	WHEN "JAA" THEN 36
	WHEN "ACQ" THEN 36
	WHEN "JQA" THEN 37
	WHEN "ACU" THEN 37
	WHEN "JgA" THEN 38
	WHEN "ACY" THEN 38
	WHEN "JwA" THEN 39
	WHEN "ACc" THEN 39
	WHEN "KAA" THEN 40
	WHEN "ACg" THEN 40
	WHEN "KQA" THEN 41
	WHEN "ACk" THEN 41
	WHEN "KgA" THEN 42
	WHEN "ACo" THEN 42
	WHEN "KwA" THEN 43
	WHEN "ACs" THEN 43
	WHEN "LAA" THEN 44
	WHEN "ACw" THEN 44
	WHEN "LQA" THEN 45
	WHEN "AC0" THEN 45
	WHEN "LgA" THEN 46
	WHEN "AC4" THEN 46
	WHEN "LwA" THEN 47
	WHEN "AC8" THEN 47
	WHEN "MAA" THEN 48
	WHEN "ADA" THEN 48
	WHEN "MQA" THEN 49
	WHEN "ADE" THEN 49
	WHEN "MgA" THEN 50
	WHEN "ADI" THEN 50
	WHEN "MwA" THEN 51
	WHEN "ADM" THEN 51
	WHEN "NAA" THEN 52
	WHEN "ADQ" THEN 52
	WHEN "NQA" THEN 53
	WHEN "ADU" THEN 53
	WHEN "NgA" THEN 54
	WHEN "ADY" THEN 54
	WHEN "NwA" THEN 55
	WHEN "ADc" THEN 55
	WHEN "OAA" THEN 56
	WHEN "ADg" THEN 56
	WHEN "OQA" THEN 57
	WHEN "ADk" THEN 57
	WHEN "OgA" THEN 58
	WHEN "ADo" THEN 58
	WHEN "OwA" THEN 59
	WHEN "ADs" THEN 59
	WHEN "PAA" THEN 60
	WHEN "ADw" THEN 60
	WHEN "PQA" THEN 61
	WHEN "AD0" THEN 61
	WHEN "PgA" THEN 62
	WHEN "AD4" THEN 62
	WHEN "PwA" THEN 63
	WHEN "AD8" THEN 63
	WHEN "QAA" THEN 64
	WHEN "AEA" THEN 64
	WHEN "QQA" THEN 65
	WHEN "AEE" THEN 65
	WHEN "QgA" THEN 66
	WHEN "AEI" THEN 66
	WHEN "QwA" THEN 67
	WHEN "AEM" THEN 67
	WHEN "RAA" THEN 68
	WHEN "AEQ" THEN 68
	WHEN "RQA" THEN 69
	WHEN "AEU" THEN 69
	WHEN "RgA" THEN 70
	WHEN "AEY" THEN 70
	WHEN "RwA" THEN 71
	WHEN "AEc" THEN 71
	WHEN "SAA" THEN 72
	WHEN "AEg" THEN 72
	WHEN "SQA" THEN 73
	WHEN "AEk" THEN 73
	WHEN "SgA" THEN 74
	WHEN "AEo" THEN 74
	WHEN "SwA" THEN 75
	WHEN "AEs" THEN 75
	WHEN "TAA" THEN 76
	WHEN "AEw" THEN 76
	WHEN "TQA" THEN 77
	WHEN "AE0" THEN 77
	WHEN "TgA" THEN 78
	WHEN "AE4" THEN 78
	WHEN "TwA" THEN 79
	WHEN "AE8" THEN 79
	WHEN "UAA" THEN 80
	WHEN "AFA" THEN 80
	WHEN "UQA" THEN 81
	WHEN "AFE" THEN 81
	WHEN "UgA" THEN 82
	WHEN "AFI" THEN 82
	WHEN "UwA" THEN 83
	WHEN "AFM" THEN 83
	WHEN "VAA" THEN 84
	WHEN "AFQ" THEN 84
	WHEN "VQA" THEN 85
	WHEN "AFU" THEN 85
	WHEN "VgA" THEN 86
	WHEN "AFY" THEN 86
	WHEN "VwA" THEN 87
	WHEN "AFc" THEN 87
	WHEN "WAA" THEN 88
	WHEN "AFg" THEN 88
	WHEN "WQA" THEN 89
	WHEN "AFk" THEN 89
	WHEN "WgA" THEN 90
	WHEN "AFo" THEN 90
	WHEN "WwA" THEN 91
	WHEN "AFs" THEN 91
	WHEN "XAA" THEN 92
	WHEN "AFw" THEN 92
	WHEN "XQA" THEN 93
	WHEN "AF0" THEN 93
	WHEN "XgA" THEN 94
	WHEN "AF4" THEN 94
	WHEN "XwA" THEN 95
	WHEN "AF8" THEN 95
	WHEN "YAA" THEN 96
	WHEN "AGA" THEN 96
	WHEN "YQA" THEN 97
	WHEN "AGE" THEN 97
	WHEN "YgA" THEN 98
	WHEN "AGI" THEN 98
	WHEN "YwA" THEN 99
	WHEN "AGM" THEN 99
	WHEN "ZAA" THEN 100
	WHEN "AGQ" THEN 100
ELSE
	TRUNC(p.rowid / 0)
END pdq_value,
COUNT(*) num_procs
FROM
	sysprocplan p, sysprocedures f
WHERE
	p.planid = -2 AND
	f.procid = p.procid
GROUP BY 1,2
ORDER BY 2 DESC
