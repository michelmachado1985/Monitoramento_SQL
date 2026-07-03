-- [XE_TRAN_MONITOR] para monitorar as transações que estão sendo abertas e fechadas
CREATE EVENT SESSION [XE_TRAN_MONITOR] ON SERVER 
ADD EVENT sqlserver.database_transaction_begin(
    ACTION(sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text)),
ADD EVENT sqlserver.database_transaction_end(
    ACTION(sqlserver.database_name,sqlserver.session_id,sqlserver.sql_text)) 
ADD TARGET package0.pair_matching(SET begin_event=N'sqlserver.database_transaction_begin',begin_matching_actions=N'sqlserver.session_id',end_event=N'sqlserver.database_transaction_end',end_matching_actions=N'sqlserver.session_id')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


