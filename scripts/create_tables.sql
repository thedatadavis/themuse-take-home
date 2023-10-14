CREATE TABLE raw_listings (
  job_id integer PRIMARY KEY,
  created_at timestamp default current_timestamp,
  job_data JSONB,
  page_number integer
);

CREATE TABLE raw_cbsa_mapping (
  afact numeric,
  cbsa text,
  cbsaname15 text,
  pop16 numeric,
  zip5 text,
  zipname text
);
