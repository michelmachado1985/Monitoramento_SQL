create event session [XE_SORTWARNNING]
on server 
add event sqlserver.sort_warning
(action (sqlserver.database_name, sqlserver.sql_text,
sqlserver.username))
add target package0.ring_buffer