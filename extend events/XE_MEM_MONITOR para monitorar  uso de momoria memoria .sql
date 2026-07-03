--XE_MEM_MONITOR para monitorar  uso de momoria memoria 
create event session [XE_MEM_MONITOR] on server
add event sqlserver.server_memory_change(
 action (sqlserver.database_name, sqlserver.sql_text)),
 add event sqlserver.sql_statement_completed(
 action (sqlserver.database_name, sqlserver.sql_text))
 add target package0.ring_buffer