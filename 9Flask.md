# Web programming

Last week, we used `http-server` as a web server in VS Code. This program listens for connections and requests, and responds with static content, like HTML files and images. But `http-server` can’t process other types of requests, like form inputs from the user.

Let’s write a simple web server by creating an app.py in VS Code:

```py
from flask import Flask, render_template, request
# Giving our Python file's name to the `Flask` variable
app = Flask(__name__)

# Label a function for the `/` route
@app.route("/")

# render a template, or return HTML code, from the file index.html.
def index():
    return render_template("index.html")
```

Now, we’ll need to create a templates/ directory, and create an index.html file with some content inside it.


Now, typing `flask run` will return that HTML file when we visit our server’s URL: ``` $ flask run.

We can change the URL by adding `/?name=Mint`, but our page stays the same. We’ll need to change our code in app.py:

```py 
from flask import Flask, render_template, request

app = Flask(__name__)


@app.route("/")
def index():
    name = request.args.get("name")
    return render_template("index.html", name=name)
```

We can use the `request` variable from the Flask library to get the arguments from the request. Then, we can pass in the `name` variable as an argument to the `render_template` function.

And in our HTML file, we can include that variable with two curly braces:
```html 
    <body>
        hello, {{ name }}
    </body>
```


# Form 
In `index.html`, we’ll create a form:
```html 
<!DOCTYPE html>

<html lang="en">
    <head>
        <meta name="viewport" content="initial-scale=1, width=device-width">
        <title>hello</title>
    </head>
    <body>
        <form action="/greet" method="get">
            <input autocomplete="off" autofocus name="name" placeholder="Name" type="text">
            <input type="submit">
        </form>
    </body>
</html>
```

We’ll have to create a new file in `templates` called `greet.html` and use the `name` variable as before:
```html 
<!DOCTYPE html>

<html lang="en">
    <head>
        <meta name="viewport" content="initial-scale=1, width=device-width">
        <title>hello</title>
    </head>
    <body>
        hello, {{ name }}
    </body>
</html>
```

It turns out that the get function allows for a default value, so we can write:

```py 
  @app.route("/greet")
  def greet():
      name = request.args.get("name", "world")
      return render_template("greet.html", name=name)
```

But, if someone uses our form and provides no input, the URL becomes `/greet?name=`, and `name` will actually have a value of a blank string. We can add the `required` attribute to our form in `index.html`, but we can’t rely on that safety check, since, as we saw last week, anyone can change our page on the client-side with Developer Tools in the browser.


# Layouts
In `index.html` and `greet.html`, we have some repeated HTML code. With just HTML, we aren’t able to share code between files, but with Flask templates (and other web frameworks), we can factor out such common content.

We’ll create another template, `layout.html`:

```html 
<!DOCTYPE html>

<html lang="en">
    <head>
        <title>hello</title>
    </head>
    <body>
        {% block body %}{% endblock %}
    </body>
</html>
```

With the `{% %}` syntax, we can include placeholder blocks, or other chunks of code. Here we’ve named our block `body` since it contains the HTML that should go in the `<body>` element.

In `index.html`, we’ll use the `layout.html` blueprint and only define the body block with:

```html 
{% extends "layout.html" %}

{% block body %}

    <form action="/greet" method="post">
        <input autocomplete="off" autofocus name="name" placeholder="Name" type="text">
        <input type="submit">
    </form>

{% endblock %}
```

Similarly, in `greet.html`, we define the `body` block with just the greeting:

```html 
{% extends "layout.html" %}

{% block body %}

    hello, {{ name }}

{% endblock %}
```

The templating language is actually called Jinja, and understood by Flask.


# POST 
Our form above used the GET method, which includes our form’s data in the URL.

We’ll just need to change the `method` in our HTML form: `<form action="/greet" method="post">`.

Our controller will also need to be changed to accept the POST method, and look for the input from the form:

```py 
@app.route("/greet", methods=["POST"])
def greet():
    return render_template("greet.html", name=request.form.get("name", "world"))
```

- While `request.args` is for inputs from a GET request, we have to use `request.form` in Flask for inputs from a POST request.
- Now, when we restart our application after making these changes, we can see that the form takes us to /greet, but the contents aren’t included in the URL anymore.
- Note that when we reload the `/greet` page, the browser asks us to confirm the form submission, since it’s temporarily remembering the inputs.
- GET requests are useful since they allow the browser to save the contents of the form in history, and allow links that include information as well, like `https://www.google.com/search?q=what+time+is+it`.

