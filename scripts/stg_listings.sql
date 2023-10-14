CREATE VIEW stg_listings as

select 
  job_id,
  data.name as job_title,
  data.publication_date as published_at,
  date_trunc('year', data.publication_date)::date as publication_year,
  date_trunc('quarter', data.publication_date)::date as publication_qtr,
  date_trunc('month', data.publication_date)::date as publication_month,
  date_trunc('week', data.publication_date)::date as publication_week,
  company.id as company_id

from 
  raw_listings,
  jsonb_to_record(job_data) as data(id int, name text, company jsonb, publication_date timestamp),
  jsonb_to_record(company) as company(id int, short_name text, name text)
