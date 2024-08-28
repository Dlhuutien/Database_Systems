exec sp_addtype Mavung, 'char(10)',
exec sp_addtype STT, 'int',
exec sp_addtype SoDienThoai, 'char(13)', NULL
exec sp_addtype Shortsring, 'nchar(15)'

SELECT domain_name, data_type, character_maximum_length
FROM information_schema.domains
ORDER BY domain_name

