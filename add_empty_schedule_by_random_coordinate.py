import datetime
import geocoder
from dotenv import load_dotenv
import os
import psycopg2
import add_empty_schedule
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


def get_random_address_coordinates():
    cursor.callproc('get_random_address_coordinates')
    conn.commit()
    random_coordinates = cursor.fetchall()
    return random_coordinates


def set_empty_schedule_by_random_coordinate(coordinate):
    for rec in coordinate:
        lat_from = rec[0].replace(' ', '')
        lon_from = rec[1].replace(' ', '')
        lat_to = rec[2].replace(' ', '')
        lon_to = rec[3].replace(' ', '')

        add_empty_schedule.add_empty_schedule(geocoder.get_address_by_coordinate(lat_from, lon_from)[1]["value"],
                                              geocoder.get_address_by_coordinate(lat_to, lon_to)[1]["value"],
                                              60)


set_empty_schedule_by_random_coordinate(get_random_address_coordinates())
