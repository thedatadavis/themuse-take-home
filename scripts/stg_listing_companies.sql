CREATE VIEW stg_listing_companies as

with companies as (
  select 
    job_id, 
    company.id as company_id,
    company.name as name
  
  from 
    raw_listings,
    jsonb_to_record(job_data) as data(id int, name text, company jsonb),
    jsonb_to_record(company) as company(id int, short_name text, name text)
)

select distinct
  name
from companies