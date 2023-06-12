import os
import requests

from dotenv import load_dotenv

path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)
appid = os.getenv("WEATHER_KEY_API")


def get_weather_data(latitude: float, longitude: float) -> dict:
    url = 'https://api.openweathermap.org/data/2.5/weather'
    params = {
        'lat': latitude,
        'lon': longitude,
        'units': 'metric',
        'lang': 'ru',
        'appid': appid
    }
    response = requests.get(url=url, params=params)
    return response.json()


def is_rainy(data: dict) -> int:
    return int('rain' in data)


def is_snowy(data: dict) -> int:
    return int('snow' in data)


def get_current_temp(data: dict) -> float:
    return data['main']['temp']


def get_cloud_percent(data: dict) -> int:
    return data['clouds']['all']


def get_wind_speed(data: dict) -> float:
    return data['wind']['speed']

