from bs4 import BeautifulSoup
import requests
from requests_oauthlib import OAuth1
from werkzeug.contrib.cache import SimpleCache

cache = SimpleCache()
client_key = 'Le8K-3wO8qPi2OBZoTMfvA'
client_secret = 'L0OKV46JqVJtq8jiU_VMFjQXkcg'
token = 'a4hY3eZqlMrhHA4k8KOyETSs49V71S8O'
token_secret = '04riRyoEi3O5OWz8059-iaOY9SM'
oauth = OAuth1(client_key, client_secret=client_secret,
               resource_owner_key=token, resource_owner_secret=token_secret)

client = requests.Session()
client.auth = oauth


def closest_match_sf(name):
    soup = BeautifulSoup(name)
    try:
        name = soup.a.contents[0]
    except AttributeError:
        pass
    base_key = unicode('yelp_match')
    yelp_match = cache.get(base_key + name)
    if yelp_match is None:
        payload = {
            'term': name,
            'location': 'San Francisco',
            'limit': 1,
        }
        response = client.get('http://api.yelp.com/v2/search', params=payload)
        yelp_match = response.json()['businesses'][0]
        cache.set(base_key + name, yelp_match, timeout=60*60)
    return yelp_match
