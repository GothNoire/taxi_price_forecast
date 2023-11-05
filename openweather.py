import requests
from dotenv import load_dotenv
import os
from datetime import timedelta, datetime

path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)
appid = os.getenv("WEATHER_KEY_API")
rapid_id = os.getenv("WEATHER_KEY_RAPID")


def get_forecast_weather_data(lat, lon, days):
    url = "https://weatherapi-com.p.rapidapi.com/forecast.json"
    params = {"q": f"{lat},{lon}", "days": days}

    headers = {
        "X-RapidAPI-Key": rapid_id,
        "X-RapidAPI-Host": "weatherapi-com.p.rapidapi.com"
    }
    response = requests.get(url, headers=headers, params=params)
    return response.json()


def get_forecast_weather_by_date(forecast_weather_data, weather_param, day, hour):
    #hour = datetime.strftime(forecast_weather_data, '%H')
    return forecast_weather_data['forecast']['forecastday'][day]['hour'][hour][weather_param] if weather_param in forecast_weather_data['forecast']['forecastday'][day]['hour'][hour] else None


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
