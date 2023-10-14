CREATE OR REPLACE VIEW int_listings_by_metro as 

with listings_by_metro as (
  
  select distinct
    metro_area,
    job_id
    
  from stg_metro_areas as ma
    left join stg_listing_locations as ll on ma.city = ll.location
  
  where job_id is not null
  
)

select
  *
  
from listings_by_metro
  left join stg_listings using(job_id)
