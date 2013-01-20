import os
import datetime

from flask import Flask, render_template, url_for
import pytz

import data


app = Flask(__name__)


@app.route('/')
@app.route('/index.html')
def index():
    pacific = pytz.timezone('US/Pacific')
    today = datetime.datetime.now(tz=pacific).date()
    f = data.get_food_for_day(today)
    return render_template('index.html', meals=f)


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
