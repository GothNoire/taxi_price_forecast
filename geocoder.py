from dadata import Dadata
import os
from dotenv import load_dotenv

path = os.path.join(os.path.dirname(__file__), '.env')
if os.path.exists(path):
    load_dotenv(path)

geo_token = os.getenv("GEO_TOKEN")
geo_secret = os.getenv("GEO_SECRET")

def get_coordinate_by_address(address_name: str) -> dict:
    dadata = Dadata(geo_token, geo_secret)
    response = dadata.clean("address", address_name)
    return response


def get_address_by_coordinate (lat: str, lon: str) -> dict:
    dadata = Dadata(geo_token, geo_secret)
    response = dadata.geolocate(name="address", lat=lat, lon=lon)
    return response

def get_lat(geo_data: dict):
    return float(geo_data["geo_lat"]) if "geo_lat" in geo_data else None


def get_lon(geo_data: dict):
    return float(geo_data["geo_lon"]) if "geo_lon" in geo_data else None


def get_city_district_name (geo_data: dict):
    return geo_data["city_district"] if "city_district" in geo_data else None
