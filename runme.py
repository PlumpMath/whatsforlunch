import os
from flask import Flask
from flask import render_template
import scrape
app = Flask(__name__)


@app.route('/')
@app.route('/index.html')
def index():
    f = scrape.get_food_for_today()
    return render_template('index.html', meals=f)

if __name__ == '__main__':
    try:
        if os.environ['TESTING'] == '1':
            app.debug = True
    except KeyError:
        pass
    app.run()
