import requests
from werkzeug.contrib.cache import SimpleCache
cache = SimpleCache()


def get_json_timeline():
    cached_timeline = cache.get('timeline')
    if cached_timeline is None:
        r = requests.get(
            'http://cater2.me/VeriteCo-TimelineJS/calendar/Mopub.json')
        cached_timeline = r.json()
        cache.set('timeline', cached_timeline, timeout=10 * 60)
    return cached_timeline


def day_format(date=None):
    return date.strftime('%Y,%m,%d')


def find_date(li, formatted_date):
    ret = []
    for x in li:
        if x['startDate'][:10] == formatted_date:
            ret.append(x)
    return ret


def replace_cater2me_text(menu_list):
    """Replaces text in menu_list"""
    for item in menu_list:
        item['headline'] = item['headline'].replace('src="/', 'src="http://cater2.me/')
        item['headline'] = item['headline'].replace('href="/', 'href="http://cater2.me/')
        item['text'] = item['text'].replace('**', ' (Vegan)')
        item['text'] = item['text'].replace('*', ' (Vegetarian)')
        item['text'] = item['text'].replace('(G)', ' (Gluten Safe)')
        item['text'] = item['text'].replace('(E)', ' (Egg Safe)')
        item['text'] = item['text'].replace('(S)', ' (Soy Safe)')
        item['text'] = item['text'].replace('(N)', ' (Nut Safe)')
        item['text'] = item['text'].replace('(D)', ' (Dairy Safe)')
    return menu_list


def get_food_for_day(date=None):
    timeline = get_json_timeline()
    menu_list = timeline['timeline']['date']
    date_formatted = day_format(date)
    foods = find_date(menu_list, date_formatted)
    foods = replace_cater2me_text(foods)
    return foods
