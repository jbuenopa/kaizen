from flask import Flask, render_template, request, redirect
from markupsafe import escape
import requests
import json

app = Flask(__name__)

@app.get("/")
def hello():
    data = requests.get("http://localhost:8001/posts")
    jsonRes = data.json()
    return render_template("index.html", data=jsonRes)

@app.get("/add")
def getPost():
    return render_template("add.html")

@app.post("/add")
def addPost():
    title = request.form.get("title")
    author = request.form.get("author")
    content = request.form.get("content")
    link1 = request.form.get("link1")
    link2 = request.form.get("link2")
    link3 = request.form.get("link3")
    link4 = request.form.get("link4")
    link5 = request.form.get("link5")

    # Create an array with the links that are not empty
    refs_links = []
    if link1 != "":
        refs_links.append(link1)
    if link2 != "":
        refs_links.append(link2)
    if link3 != "":
        refs_links.append(link3)
    if link4 != "":
        refs_links.append(link4)
    if link5 != "":
        refs_links.append(link5)

    data = requests.post("http://localhost:8001/posts", json={
        "author": author,
        "title": title,
        "content": content,
        "refs_links": refs_links}
    )
    return redirect("/")

@app.get("/edit/<id>")
def getEditPost(id):
    req = requests.get(f"http://localhost:8001/posts/{id}")
    data = req.json()
    print(data)
    return render_template("edit.html", data=data)

@app.post("/edit/<id>")
def editPost(id):
    title = request.form.get("title")
    author = request.form.get("author")
    content = request.form.get("content")
    link1 = request.form.get("link1")
    link2 = request.form.get("link2")
    link3 = request.form.get("link3")
    link4 = request.form.get("link4")
    link5 = request.form.get("link5")

    # Create an array with the links that are not empty
    refs_links = []
    if link1 != "":
        refs_links.append(link1)
    if link2 != "":
        refs_links.append(link2)
    if link3 != "":
        refs_links.append(link3)
    if link4 != "":
        refs_links.append(link4)
    if link5 != "":
        refs_links.append(link5)

    data = requests.put(f"http://localhost:8001/posts/{id}", json={
        "author": author,
        "title": title,
        "content": content,
        "refs_links": refs_links}
    )
    return redirect("/")

@app.get("/delete/<id>")
def deletePost(id):
    data = requests.delete(f"http://localhost:8001/posts/{id}")
    return redirect("/")
