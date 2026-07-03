CREATE EVENT SESSION [XE_CXPACKAGE] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.sql_text)
    WHERE ([wait_type]=(191))),
ADD EVENT sqlserver.degree_of_parallelism(
    ACTION(sqlserver.database_name,sqlserver.plan_handle,sqlserver.sql_text)) 
ADD TARGET package0.event_file(SET filename=N'XE_CXPACKAGE')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


