import os
import datetime

from flask import Flask, render_template, url_for, redirect
import pytz

import data


app = Flask(__name__)


def today_offset(offset=0):
    pacific = pytz.timezone('US/Pacific')
    dt = datetime.datetime.now(tz=pacific) + datetime.timedelta(days=offset)
    return dt.date()


def url_for_offset(offset=0):
    date = today_offset(offset)
    url = url_for('food_for_date', year=date.year, month=date.month, day=date.day)
    return url


@app.route('/')
@app.route('/today/')
def index():
    return redirect(url_for_offset(0))


@app.route('/yesterday/')
def yesterday():
    return redirect(url_for_offset(-1))


@app.route('/tomorrow/')
def tomorrow():
    return redirect(url_for_offset(1))


@app.route('/<int:year>-<int:month>-<int:day>/')
def food_for_date(year, month, day):
    date_string = '{}-{}-{}'.format(year, month, day)
    date = datetime.datetime.strptime(date_string, '%Y-%m-%d').date()
    f = data.get_food_for_day(date)
    return render_template('index.html', meals=f)

# Initialize server with optional debug mode
if __name__ == '__main__':
    if os.environ.get('TESTING', '0') == '1':
        app.debug = True
        app.run()
    else:
        port = int(os.environ.get('PORT', 5000))
        app.run(host='0.0.0.0', port=port)
