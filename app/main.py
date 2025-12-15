from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    color = os.getenv("APP_COLOR", "UNKNOWN")
    status = os.getenv("APP_STATUS", "UNKNOWN")
    version = os.getenv("APP_VERSION", "v?")

    return f"""
ENV: {color}
STATUS: {status}
VERSION: {version}
"""

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
