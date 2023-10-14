CREATE VIEW stg_metro_areas as 

select distinct
  cbsa as metro_code,
  cbsaname15 as metro_area,
  zipname as city

from cbsa_mapping

where cbsa <> ' '
