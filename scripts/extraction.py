import os
import json
import time

from datetime import datetime

import requests
import psycopg2

POSTGRES_CONFIG = os.environ.get('POSTGRES_CONFIG')
MUSE_API_KEY = os.environ.get('MUSE_API_KEY')

class MuseJobDownloader:
    def __init__(self, postgres_config, page_start):
        self.api_base_url = "https://www.themuse.com/api/public"
        self.muse_api_key = MUSE_API_KEY
        self.postgres_config = postgres_config
        self.page_start = page_start

    def fetch_jobs(self, company=None):
        page = 0
        while True:
            response = self.request_api_page('jobs', page, company)
            if not response:
                break

            for job in response['results']:
                self.write_to_postgres(job, page)

            page += 1
            if page >= response['page_count']:
                break

    def fetch_companies(self):
        page = 0
        while True:
            response = self.request_api_page('companies', page)
            if not response:
                break

            for company in response['results']:
                company_name = company['name']
                print(f"Getting jobs for {company_name}")
                self.fetch_jobs(company_name)

            page += 1
            if page >= response['page_count']:
                break

    def request_api_page(self, endpoint, page_num, company=None):
        params = {"api_key": self.muse_api_key, "page": page_num}
        if company:
            params["company"] = company

        url = f"{self.api_base_url}/{endpoint}"

        response = requests.get(url, params=params)

        if response.status_code == 200:
            remaining = int(response.headers['X-RateLimit-Remaining'])
            reset_time = int(response.headers['X-RateLimit-Reset'])
            if remaining == 1:
                print(f"Rate limit exhausted. Waiting for {reset_time+1} seconds.")
                time.sleep(reset_time+1)
            return json.loads(response.text)
        else:
            print(f"API request failed with status code {response.status_code}")
            print(f"Error {response.text}")
            return None

    def write_to_postgres(self, job, page_number):
        conn = psycopg2.connect(**self.postgres_config)
        cur = conn.cursor()

        try:
            current_timestamp = datetime.now().isoformat()
            job_data = json.dumps(job)
            cur.execute(
                "INSERT INTO raw_listings (created_at, job_id, job_data, page_number)"
                "VALUES (%s, %s, %s, %s)",
                (
                    current_timestamp,
                    job['id'],
                    job_data,
                    page_number,
                )
            )
            conn.commit()
        except Exception as e:
            print(f"Error inserting data into PostgreSQL: {e}")
        finally:
            cur.close()
            conn.close()

if __name__ == "__main__":
    runner = MuseJobDownloader(POSTGRES_CONFIG, 0)
    runner.fetch_companies()
