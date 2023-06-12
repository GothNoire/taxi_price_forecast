from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.operators.python import PythonOperator
import requests
import psycopg2
from dotenv import load_dotenv
import openweather
import os

path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)
clid = os.getenv("CLID")
apikey = os.getenv("APIKEY")
dbname = os.getenv("DBNAME")
user = os.getenv("DBUSER")
password = os.getenv("PASSWORD")
host = os.getenv("HOST")
port = os.getenv("PORT")


conn = psycopg2.connect(dbname=dbname, user=user, password=password, host=host, port=port)
cursor = conn.cursor()


def get_road_info(latitude_from, longitude_from, latintude_to, longitude_to, class_name):
    url = 'https://taxi-routeinfo.taxi.yandex.net/taxi_info'
    params = {
        'clid': clid,
        'apikey': apikey,
        'rll': longitude_from + ',' + latitude_from + '~' + longitude_to + ',' + latintude_to,
        'lang': 'ru',
        'class': class_name
    }
    response = requests.get(url=url, params=params)
    return response.json()


def get_current_coordinate() -> list:
    cursor.callproc('get_current_coordinate')
    conn.commit()
    current_coordinate = cursor.fetchall()
    return current_coordinate


def set_info_taxi_roads_facts(current_coordinate) -> int:
    is_update = 0
    if current_coordinate:
        for rec in current_coordinate:
            latitude_from = rec[0].replace(' ', '')
            longitude_from = rec[1].replace(' ', '')
            latitude_to = rec[2].replace(' ', '')
            longitude_to = rec[3].replace(' ', '')
            taxi_roads_info_id = rec[4]
            class_name = rec[5].replace(' ', '')

            weather_data = openweather.get_weather_data(latitude=latitude_from, longitude=longitude_from)

            data = get_road_info(latitude_from=latitude_from,
                                 longitude_from=longitude_from,
                                 latintude_to=latitude_to,
                                 longitude_to=longitude_to,
                                 class_name=class_name)

            price = data['options'][0]['price']
            waiting_time = data['options'][0]['waiting_time'] if data['options'][0]['waiting_time'] else None
            distance = data['distance']
            travel_time = data['time']

            cursor.callproc('set_info_taxi_roads_facts', [taxi_roads_info_id,
                                                          price,
                                                          waiting_time,
                                                          distance,
                                                          travel_time,
                                                          openweather.is_rainy(weather_data),
                                                          openweather.is_snowy(weather_data),
                                                          openweather.get_current_temp(weather_data),
                                                          openweather.get_cloud_percent(weather_data),
                                                          openweather.get_wind_speed(weather_data)])
            conn.commit()
            is_update = cursor.fetchone()

    return is_update


def start_python_operator():
    return set_info_taxi_roads_facts(get_current_coordinate())


dag = DAG(dag_id='road_taxi',
          schedule_interval='*/15 * * * *',
          start_date=days_ago(1)
          )

set_road_info = PythonOperator(
    task_id='set_road_info',
    python_callable=start_python_operator,
    dag=dag
)


set_road_info