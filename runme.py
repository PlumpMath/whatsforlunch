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
    if os.environ.get('TESTING', '0') == '1':
        app.debug = True
        app.run()
    else:
        port = int(os.environ.get('PORT', 5000))
        app.run(host='0.0.0.0', port=port)
