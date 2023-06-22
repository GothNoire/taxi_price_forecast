import datetime
import geocoder
from dotenv import load_dotenv
import os
import psycopg2
from datetime import datetime, timedelta
from sys import argv

path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)
dbname = os.getenv("DBNAME")
user = os.getenv("DBUSER")
password = os.getenv("PASSWORD")
host = os.getenv("HOST")
port = os.getenv("PORT")

conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
cursor = conn.cursor()


def add_empty_schedule(address_from: str, address_to: str):
    geo_data_from = geocoder.get_coordinate_by_address(address_from)
    geo_lat_from = geocoder.get_lat(geo_data_from)
    geo_lon_from = geocoder.get_lon(geo_data_from)
    geo_data_to = geocoder.get_coordinate_by_address(address_to)
    geo_lat_to = geocoder.get_lat(geo_data_to)
    geo_lon_to = geocoder.get_lon(geo_data_to)
    print(geo_data_from)
    print(geo_data_to)

    cursor.callproc('add_empty_schedule_from_coordinate',
                    [datetime.strptime(datetime.now().strftime('%y.%m.%d 00:00:00'), '%y.%m.%d %H:%M:%S'),
                     datetime.strptime(datetime.strftime(datetime.now() + timedelta(days=+int(argv[3])), '%y.%m.%d %H:%M:%S'),
                                       '%y.%m.%d %H:%M:%S'),
                     geo_lon_from,
                     geo_lat_from,
                     geo_lon_to,
                     geo_lat_to
                     ]
                    )
    conn.commit()

add_empty_schedule(argv[1], argv[2])
