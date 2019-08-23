import json

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'This is website started by Helen.'
    # return json.dumps({'status': 200})

@app.route('/late/')
def hello_world():
    return 'Time for bed.'
    # return json.dumps({'status': 200})
