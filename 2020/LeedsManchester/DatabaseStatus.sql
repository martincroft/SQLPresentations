-- DatabaseStatus.sql  #SQL
--Get version so we can run different quiries based on version
DECLARE @SQLServerInstanceVersion INT
SELECT @SQLServerInstanceVersion=FLOOR(SUBSTRING(CAST(SERVERPROPERTY('ProductVersion')AS VARCHAR(10)),1,4))

IF @SQLServerInstanceVersion <= 10
BEGIN

SELECT 
    Name,
    state_desc,
    CASE 
        WHEN mirroring_state_desc IS NULL THEN '' 
        ELSE mirroring_state_desc END AS synchronization_state_desc 
FROM sys.databases d
INNER JOIN sys.database_mirroring dm ON d.database_id = dm.database_id
END
ELSE
BEGIN

EXEC(' SELECT sd.Name,
CASE WHEN sd.is_read_only =1 THEN sd.state_desc + ''(READONLY)'' ELSE sd.state_desc END AS state_desc

, ISNULL(ag.synchronization_state_desc,'''') AS synchronization_state_desc
FROM Master.sys.databases sd
    LEFT JOIN master.sys.dm_hadr_database_replica_states ag ON sd.database_id=ag.database_id
WHERE is_local IS NULL or is_local=1
UNION
SELECT ''ManchesterUGData'', ''ONLINE'', ''SYNCHRONISING''
ORDER BY sd.Name'



)
END

