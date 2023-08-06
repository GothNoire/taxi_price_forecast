import requests
import psycopg2
from dotenv import load_dotenv
import os
import geocoder
import openweather
from datetime import datetime, timedelta

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


class EmptyParameters(Exception):
    pass


def get_road_info(latitude_from, longitude_from, latintude_to, longitude_to, class_name):
    url = 'https://taxi-routeinfo.taxi.yandex.net/taxi_info'
    params = {
        'clid': clid,
        'apikey': apikey,
        'rll': str(longitude_from) + ',' + str(latitude_from) + '~' + str(longitude_to) + ',' + str(latintude_to),
        'lang': 'ru',
        'class': class_name
    }
    response = requests.get(url=url, params=params)
    return response.json()


def get_planned_taxi_road_price(address_from=None, address_to=None, lat_from=None, lon_from=None,
                                lat_to=None, lon_to=None, class_name='econom', forecast_road_date=datetime.now()):
    try:
        if address_from is not None and address_to is not None:
            address_from = geocoder.get_coordinate_by_address(address_from)
            lat_from = geocoder.get_lat(address_from)
            lon_from = geocoder.get_lon(address_from)
            address_to = geocoder.get_coordinate_by_address(address_to)
            lat_to = geocoder.get_lat(address_to)
            lon_to = geocoder.get_lon(address_to)
        elif lat_from is not None and lon_from is not None and lat_to is not None and lon_to is not None:
            address_from = geocoder.get_address_by_coordinate(lat=lat_from, lon=lon_from)[1]["value"]
            address_to = geocoder.get_address_by_coordinate(lat=lat_to, lon=lon_to)[1]['value']
        else:
            raise EmptyParameters
    except EmptyParameters:
        print('Не заполнены обязательные параметры')

    city_district_name_from = geocoder.get_city_district_name(address_from)
    city_district_name_to = geocoder.get_city_district_name(address_to)

    data = get_road_info(latitude_from=lat_from,
                         longitude_from=lon_from,
                         latintude_to=lat_to,
                         longitude_to=lon_to,
                         class_name=class_name)

    distance = data['distance']
    days = forecast_road_date - datetime.now()
    days = days.days + 1
    hour = int(datetime.strftime(forecast_road_date, '%H'))
    minute = datetime.strftime(forecast_road_date, '%M')

    forecast_weather_data = openweather.get_forecast_weather_data(lat=lat_from, lon=lon_from, days=days)
    days -= 1
    days = 2 if days > 2 else days
    is_rainy = openweather.get_forecast_weather_by_date(forecast_weather_data=forecast_weather_data,
                                                        weather_param='will_it_rain', day=days, hour=hour)
    temp = openweather.get_forecast_weather_by_date(forecast_weather_data=forecast_weather_data, weather_param='temp_c',
                                                    day=days, hour=hour)
    is_snowy = openweather.get_forecast_weather_by_date(forecast_weather_data=forecast_weather_data,
                                                        weather_param='will_it_snow', day=days, hour=hour)

    cursor.callproc('get_plan_road_taxi_cost', [distance,
                                                hour,
                                                minute,
                                                is_rainy,
                                                is_snowy,
                                                temp,
                                                city_district_name_from,
                                                city_district_name_to])
    conn.commit()

    taxi_road_price = round(cursor.fetchone()[0])
    return taxi_road_price
