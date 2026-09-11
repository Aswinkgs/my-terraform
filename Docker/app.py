from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return f"""
    <p>Application deployed!</p>
    <p>Hostname: {socket.gethostname()}</p>
    """

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
