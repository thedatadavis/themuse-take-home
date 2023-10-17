### Sr. Data Engineering Take Home for The Muse
Prepared by: Chris Davis on Oct 12 2023


> How many jobs with the location "New York City Metro Area" were published from July 1st to 31 2023?

> _**Answer: 378**_

The answer was obtained by:
  * Pulling up to 100 pages of job listings for 600 companies via the Muse API
  * Pushing those records to a Postgres database
    - I tried out [Neon's](https://neon.tech) serverless offering
  * Sourcing and importing an external dataset to allow mapping city names to metro areas
    - See: [/seeds](/seeds)
  * Transforming the raw data through a series of steps in a dbt-esque DAG
    - In production, I'd want to leverage materialized views and incremental models (in addition to indexes) to improve query performance and processing runtimes
  * Filtering the final [view/model](/scripts/rpt_jobs_by_metro_summary.sql) by the given timeframe for the NY metro area
    - The model is representative of a pre-aggregated roll up that could support self-service analytics

Visualizations:
  * [Data Pipeline](/docs/DataPipeline.md)
  * [Database Schema](/docs/DbSchema.md)
