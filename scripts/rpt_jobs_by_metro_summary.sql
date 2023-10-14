CREATE OR REPLACE VIEW rpt_jobs_by_metro_summary as

select
  metro_area,
  'year' as interval,
  publication_year as timeframe,
  'jobs published' as metric,
  count(*) as value

from int_listings_by_metro

group by
  metro_area, 2, 3, 4
  
union

select
  metro_area,
  'quarter' as interval,
  publication_qtr as timeframe,
  'jobs published' as metric,
  count(*) as value

from int_listings_by_metro

group by
  metro_area, 2, 3, 4
  
union

select
  metro_area,
  'month' as interval,
  publication_month as timeframe,
  'jobs published' as metric,
  count(*) as value

from int_listings_by_metro

group by
  metro_area, 2, 3, 4