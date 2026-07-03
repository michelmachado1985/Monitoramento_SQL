-- XE_DB_RESIZE verifica quantas vezes o banco faz resize.
CREATE EVENT SESSION [XE_DB_RESIZE] ON SERVER 
ADD EVENT sqlserver.database_file_size_change(
    ACTION(sqlos.task_time,sqlserver.database_name,sqlserver.sql_text)) 
ADD TARGET package0.ring_buffer(SET max_memory=(1024000))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


