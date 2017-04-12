-----------------------------------------------------------------------------------------------------------------
--
-- Copyright (c) 2010-2017 Fernando Nunes - domusonline@gmail.com
-- $Author: Fernando Nunes - domusonline@gmail.com $
-- $Revision: 2.0.3 $
-- $Date 2016-04-12 16:11:06$
-- Disclaimer: This software is provided AS IS, without any kind of guarantee. Use at your own risk.
--             Although the author is/was an IBM employee, this software was created outside his job engagements.
--             As such, all credits are due to the author.
-----------------------------------------------------------------------------------------------------------------

SELECT
	t.dbsname[1,20], t.tabname[1,32], p.nkeys, p.nrows
FROM
	systabnames t, sysptnhdr p
WHERE
	p.partnum = t.partnum
	AND p.nkeys > 0 AND p.nrows > 0
	AND t.tabname NOT IN
	(
'systables',
'syscolumns',
'sysindices',
'systabauth',
'syscolauth',
'sysviews',
'sysusers',
'sysdepend',
'syssynonyms',
'syssyntable',
'sysconstraints',
'sysreferences',
'syschecks',
'sysdefaults',
'syscoldepend',
'sysprocedures',
'sysprocbody',
'sysprocplan',
'sysprocauth',
'sysblobs',
'sysopclstr',
'systriggers',
'systrigbody',
'sysdistrib',
'sysfragments',
'sysobjstate',
'sysviolations',
'sysfragauth',
'sysroleauth',
'sysxtdtypes',
'sysattrtypes',
'sysxtddesc',
'sysinherits',
'syscolattribs',
'syslogmap',
'syscasts',
'sysxtdtypeauth',
'sysroutinelangs',
'syslangauth',
'sysams',
'systabamdata',
'sysopclasses',
'syserrors',
'systraceclasses',
'systracemsgs',
'sysaggregates',
'syssequences',
'sysdirectives',
'sysxasourcetypes',
'sysxadatasources',
'sysseclabelcomponents',
'sysseclabelcomponentelements',
'syssecpolicies',
'syssecpolicycomponents',
'syssecpolicyexemptions',
'sysseclabels',
'sysseclabelnames',
'sysseclabelauth',
'syssurrogateauth',
'sysproccolumns',
'sysexternal',
'sysextdfiles',
'sysextcols',
'sysautolocate',
'sysfragdist',
'sysdomains',
'sysindexes',
'GL_COLLATE',
'GL_CTYPE',
'SMIVERSION',
'VERSION'
)
