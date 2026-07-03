CREATE EVENT SESSION [XE_QUERYERRORS] ON SERVER 
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.database_id,sqlserver.sql_text,sqlserver.tsql_stack,sqlserver.username)
    WHERE ([severity]>(10))) 
ADD TARGET package0.event_file(SET filename=N'c:\xe\queryerrors.xel',max_file_size=(5),max_rollover_files=(5),metadatafile=N'c:\xe\queryerrors.xem')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


