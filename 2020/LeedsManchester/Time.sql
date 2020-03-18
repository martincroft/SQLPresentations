DECLARE @Loop int =0
DECLARE @msg VARCHAR(20)

while @loop <> 2
BEGIN

    SELECT @msg = CAST(getdate() AS TIME)
RAISERROR(@msg, 0, 1) WITH NOWAIT

WAITFOR Delay '00:00:05'
SET @Loop=@Loop+1

END
