import requests
from bs4 import BeautifulSoup
import datetime
import pytz


def get_json_timeline():
    r = requests.get(
        'http://cater2.me/VeriteCo-TimelineJS/calendar/Mopub.json'
        )
    return r.json()


def today_format():
    pacific = pytz.timezone('US/Pacific')
    return datetime.datetime.now(tz=pacific).strftime('%Y,%m,%d')


def find_date(li, formatted_date):
    ret = []
    for x in li:
        if x['startDate'][:10] == formatted_date:
            ret.append(x)
    return ret


def replace_cater2me_links(menu_list):
    """Replaces relative links in cater2me 'headline's"""
    for item in menu_list:
        item['headline'] = item['headline'].replace('src="/', 'src="http://cater2.me/')
        item['headline'] = item['headline'].replace('href="/', 'href="http://cater2.me/')
    return menu_list


def get_food_for_today():
    timeline = get_json_timeline()
    menu_list = timeline['timeline']['date']
    today_formatted = today_format()
    foods = find_date(menu_list, today_formatted)
    foods = replace_cater2me_links(foods)
    return foods
