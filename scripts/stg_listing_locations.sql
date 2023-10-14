CREATE VIEW stg_listing_locations as 

select 
  job_id, 
  location.name as location

from 
  raw_listings,
  jsonb_to_record(job_data) as data(id int, name text, locations jsonb),
  jsonb_to_recordset(locations) as location(name text)