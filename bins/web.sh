#!/bin/bash

# Make folder (Templates, static)
mkdir -p templates
mkdir -p static/css
mkdir -p static/js
mkdir -p static/img
mkdir -p static/fonts

# Create a sample CSS and JS file
touch static/css/style.css
touch static/js/script.js

# Create a basic index.html
cat > templates/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Web Project</title>
    <link rel="stylesheet" href="/static/css/style.css">
    <script src="/static/js/script.js"></script>
</head>
<body>
    <h1>Hello, World!</h1>
    <p>This is a simple project structure.</p>

    <img src="/static/img/sample.jpg" alt="Sample Image" />

    <script src="/static/js/script.js"></script>
</body>
</html>
EOF

cat > app.py <<EOF
from flask import Flask, redirect, render_template, request, url_for

app = Flask(__name__)


@app.route("/")
def index():
    return render_template("index.html")


if __name__ == "__main__":
    app.run(debug=True)
EOF

