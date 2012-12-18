import requests
from bs4 import BeautifulSoup
import datetime


def get_json_timeline():
    r = requests.get(
        'http://cater2.me/VeriteCo-TimelineJS/calendar/Mopub.json'
        )
    return r.json()


def today_format():
    return datetime.date.today().strftime('%Y,%m,%d')


def find_date(li, formatted_date):
    ret = []
    for x in li:
        if x['startDate'][:10] == formatted_date:
            ret.append(x)
    return ret


def get_food_for_today():
    timeline = get_json_timeline()
    menu_list = timeline['timeline']['date']
    today_formatted = today_format()
    foods = find_date(menu_list, today_formatted)
    return foods
