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
    <meta name="viewport" content="initial-scale=1, width=device-width" />
    <title>hello</title>
  </head>
  <body>
    <form action="/greet" method="get">
      <input
        autocomplete="off"
        autofocus
        name="name"
        placeholder="Name"
        type="text"
      />
      <input type="submit" />
    </form>
  </body>
</html>
```

We’ll have to create a new file in `templates` called `greet.html` and use the `name` variable as before:

```html
<!DOCTYPE html>

<html lang="en">
  <head>
    <meta name="viewport" content="initial-scale=1, width=device-width" />
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
{% extends "layout.html" %} {% block body %}

<form action="/greet" method="post">
  <input
    autocomplete="off"
    autofocus
    name="name"
    placeholder="Name"
    type="text"
  />
  <input type="submit" />
</form>

{% endblock %}
```

Similarly, in `greet.html`, we define the `body` block with just the greeting:

```html
{% extends "layout.html" %} {% block body %} hello, {{ name }} {% endblock %}
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

# MVC

The Flask framework implements a particular **paradigm**, or way of thinking and programming. This paradigm, also implemented by other frameworks, is known as **MVC**, or Model–view–controller:

![Snipaste_2022-08-12_08-39-51.png](https://media.haochen.me/Snipaste_2022-08-12_08-39-51.png)

- The controller contains our “business logic”, code that manages our application overall, given user input. In Flask, this will be our Python code in `app.py`.
- The view includes templates and visuals for the user interface, like the HTML and CSS that the user will see and interact with.
- The model is our application’s data, such as a SQL database or CSV file, which we haven’t yet used.

# Form Validation

Let's change a form to `index.html` template:

```html
{% extends "layout.html" %} {% block body %}
<h1>Register</h1>
<form action="/register" method="post">
  <input
    autocomplete="off"
    autofocus
    name="name"
    placeholder="Name"
    type="text"
  />
  <!-- select 要写name -->
  <select name="sport">
    <option disabled selected>Sport</option>
    <option value="Basketball">Basketball</option>
    <option value="Soccer">Soccer</option>
    <option value="Ultimate Frisbee">Ultimate Frisbee</option>
  </select>
  <input type="submit" value="Register" />
</form>
{% endblock %}
```

We’ll plan to have a /register route, and have a `<select>` menu, which looks like a dropdown menu with options for each sport.

In `app.py`, we’ll allow POST for our `/register` route:

```py
@app.route("/register", methods=["POST"])
def register():

  # Validate submission
  if not request.form.get("name") or request.form.get("sport") not in ["Basketball", "Soccer", "Ultimate Frisbee"]:
      return render_template("failure.html")

  # Confirm registration
  return render_template("success.html")
```

We’ll check that our form’s values are valid, and then return a template for either failure or success depending on the results. Add "You are not registered!" to the `failure.html` and "You are registered!" to the `success.html` templates.

Notice that our application doesn’t actually save the data anywhere yet.

When we run this application, though, we see that we are not registered, even if we fill out the form.

We can improve the design of our application by having a single list of sports:

```py
from flask import Flask, render_template, request

app = Flask(__name__)

SPORTS = [
    "Basketball"
    "Soccer",
    "Ultimate Frisbee"
]


@app.route("/")
def index():
    return render_template("index.html", sports=SPORTS)

...
```

Then, we’ll pass that list into the index.html template:

```html
...
<select name="sport">
  <option disabled selected value="">Sport</option>
  {% for sport in sports %}
  <option value="{{ sport }}">{{ sport }}</option>
  {% endfor %}
</select>
...
```

The `for` and `endfor` syntax creates a loop, and now we can programmatically create an `<option>` element for each sport in our list.

Finally, we can check that the `sport` sent in the POST request is in the list `SPORTS` in `app.py`:

```py
...
@app.route("/register", methods=["POST"])
def register():

    if not request.form.get("name") or request.form.get("sport") not in SPORTS:
        return render_template("failure.html")

    return render_template("success.html")
```

We can change the select menu in our form to be checkboxes, to allow for multiple sports:

```html
{% extends "layout.html" %} {% block body %}
<h1>Register</h1>

<form action="/register" method="post">
  <input
    autocomplete="off"
    autofocus
    name="name"
    placeholder="Name"
    type="text"
  />
  {% for sport in sports %}
  <input name="sport" type="checkbox" value="{{ sport }}" /> {{ sport }} {%
  endfor %}
  <input type="submit" value="Register" />
</form>
{% endblock %}
```

- We’ll make sure that each `input` has the value of the sport, so it can be sent to the server, and also the sport printed next to it, so the user can see it.
- Back in our `register` function in `app.py`, we can use another function to get the list of checked options.

# Storing data

Let’s look at how we might store our registered students in a dictionary in the memory of our web server.

```py
# Implements a registration form, storing registrants in a dictionary, with error messages

from flask import Flask, redirect, render_template, request

app = Flask(__name__)

REGISTRANTS = {}

SPORTS = [
    "Basketball",
    "Soccer",
    "Ultimate Frisbee"
]


@app.route("/")
def index():
    return render_template("index.html", sports=SPORTS)


@app.route("/register", methods=["POST"])
def register():

    # Validate name
    name = request.form.get("name")
    if not name:
        return render_template("error.html", message="Missing name")

    # Validate sport
    sport = request.form.get("sport")
    if not sport:
        return render_template("error.html", message="Missing sport")
    if sport not in SPORTS:
        return render_template("error.html", message="Invalid sport")

    # Remember registrant
    REGISTRANTS[name] = sport

    # Confirm registration
    return redirect("/registrants")


@app.route("/registrants")
def registrants():
    return render_template("registrants.html", registrants=REGISTRANTS)
```

We’ll create a dictionary called `REGISTRANTS`, and in `register` we’ll first check the `name` and `sport`, returning a different error message in each case with `error.html`. Then, we can store the name and sport in our `REGISTRANTS` dictionary, and redirect to another route that will display registered students.

The error message template, meanwhile, will display the error message along with a fun image of a grumpy cat:

```html
{% extends "layout.html" %} {% block body %}
<h1>Error</h1>
<p>{{ message }}</p>
<img alt="Grumpy Cat" src="/static/cat.jpg" />
{% endblock %}
```

Our `registrants.html` template will print a table with the dictionary passed in as input:

```html
{% extends "layout.html" %} {% block body %}
<h1>Registrants</h1>
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Sport</th>
    </tr>
  </thead>
  <tbody>
    {% for name in registrants %}
    <tr>
      <td>{{ name }}</td>
      <td>{{ registrants[name] }}</td>
    </tr>
    {% endfor %}
  </tbody>
</table>
{% endblock %}
```

Our table has a header row, and then a row for each key and value stored in `registrants`.

## Problem

If our web server stops running, we’ll lose the data stored in memory, so we’ll use a SQLite database with the SQL library from `cs50`.

```py
# Implements a registration form, storing registrants in a SQLite database, with support for deregistration

from cs50 import SQL
from flask import Flask, redirect, render_template, request

app = Flask(__name__)

db = SQL("sqlite:///froshims.db")

SPORTS = [
    "Basketball",
    "Soccer",
    "Ultimate Frisbee"
]


@app.route("/")
def index():
    return render_template("index.html", sports=SPORTS)

...
```

In our terminal, we can run `sqlite3 froshims.db` to open the database, and use the `.schema` command to see the table with columns of `id`, `name`, and `sport`, which was created in advance:

```
src9/froshims4/ $ sqlite3 froshims.db
SQLite version 3.36.0 2021-06-18 18:36:39
Enter ".help" for usage hints.
sqlite> .schema
CREATE TABLE registrants (id INTEGER, name TEXT NOT NULL, sport TEXT NOT NULL, PRIMARY KEY(id));
```

Now, in our /register route, we’re using SQL to store our data:

```py
@app.route("/register", methods=["POST"])
def register():

    # Validate submission
    name = request.form.get("name")
    sport = request.form.get("sport")
    if not name or sport not in SPORTS:
        return render_template("failure.html")

    # Remember registrant
    db.execute("INSERT INTO registrants (name, sport) VALUES(?, ?)", name, sport)

    # Confirm registration
    return redirect("/registrants")
```

- Once we’ve validated the request, we can use `INSERT INTO` to add a row.
- Flask also includes a function, `redirect`, that we can use to redirect to another route.

Similarly, for the `/registrants` route, we can `SELECT` all rows and pass them to the template as a list of rows:

```py
@app.route("/registrants")
def registrants():
    registrants = db.execute("SELECT * FROM registrants")
    return render_template("registrants.html", registrants=registrants)
```

Our `registrants.html` template will use `registrant["name"]` and `registrant["sport"]` to access the value of each key in each row:

```html
{% extends "layout.html" %} {% block body %}
<h1>Registrants</h1>
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Sport</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    {% for registrant in registrants %}
    <tr>
      <td>{{ registrant["name"] }}</td>
      <td>{{ registrant["sport"] }}</td>
      <td>
        <form action="/deregister" method="post">
          <input name="id" type="hidden" value="{{ registrant.id }}" />
          <input type="submit" value="Deregister" />
        </form>
      </td>
    </tr>
    {% endfor %}
  </tbody>
</table>
{% endblock %}
```

Our page will include another form for deregistering a person by an `id`. When we click that button, we’ll see a request that just sends the `id` to our `/deregister` route.

We’ll register a few people, and go back into our terminal to see that our database now has a few rows:

```
$ sqlite3 froshims.db
SQLite version 3.36.0 2021-06-18 18:36:39
Enter ".help" for usage hints.
sqlite> SELECT * FROM registrants;
+----+--------+------------------+
| id |  name  |      sport       |
+----+--------+------------------+
| 1  | David  | Ultimate Frisbee |
| 2  | Carter | Basketball       |
| 3  | Emma   | Soccer           |
+----+--------+------------------+
```

Our `/deregister` route will take an id and delete that row from our database:

```py
@app.route("/deregister", methods=["POST"])
def deregister():

    # Forget registrant
    id = request.form.get("id")
    if id:
        db.execute("DELETE FROM registrants WHERE id = ?", id)
    return redirect("/registrants")
```

A URL that uses GET can also be used to trick people, since they might click on them while logged in to a website, and perform some action unintentionally, known as a `cross-site request forgery`.


# Emails
We can even email users with another library, `flask_mail`:

```py 
# Implements a registration form, confirming registration via email

import os
import re

from flask import Flask, render_template, request
from flask_mail import Mail, Message

app = Flask(__name__)

# Requires that "Less secure app access" be on
# https://support.google.com/accounts/answer/6010255
app.config["MAIL_DEFAULT_SENDER"] = os.environ["MAIL_DEFAULT_SENDER"]
app.config["MAIL_PASSWORD"] = os.environ["MAIL_PASSWORD"]
app.config["MAIL_PORT"] = 587
app.config["MAIL_SERVER"] = "smtp.gmail.com"
app.config["MAIL_USE_TLS"] = True
app.config["MAIL_USERNAME"] = os.environ["MAIL_USERNAME"]
mail = Mail(app)

...
```
It turns out that we can provide configuration details like a username and password and mail server, in this case Gmail’s, to the Mail variable, which will send mail for us.

We set the sensitive variables outside of our source code, in VS Code’s environment, so we can avoid including them in our code.

In our `register` route, we send an email to the user with the `mail.send()` function from the `flask_mail` library:

```py 
@app.route("/register", methods=["POST"])
def register():

    # Validate submission
    name = request.form.get("name")
    email = request.form.get("email")
    sport = request.form.get("sport")
    if not name or not email or sport not in SPORTS:
        return render_template("failure.html")

    # Send email
    message = Message("You are registered!", recipients=[email])
    mail.send(message)

    # Confirm registration
    return render_template("success.html")
```

To include the libraries we need, we’ll write a `requirements.txt` file with:

```
Flask
Flask-Mail
```

Now, if we restart our server and use the form to provide an email, we’ll see that we indeed get one sent to us (though it may end up in the Spam folder if we send too many to the same address)!

# Sessions
**Sessions** are how web servers remembers information about each user, which enables features like allowing users to stay logged in, and saving items to a shopping cart. These features require our server to be **stateful**, or having access to additional state, or information. HTTP on its own is **stateless**, since after we make a request and get a response, the interaction is completed.

It turns out that servers can send another header in a response, called `Set-Cookie`:

```
HTTP/1.1 200 OK
Content-Type: text/html
Set-Cookie: session=value
...
```

**Cookies** are small pieces of data from a web server that the browser saves for us. In many cases, they are large random numbers or strings used to uniquely identify and track a user between visits.

In this case, the server is asking our browser to set a cookie for that server, called `session` to a value of `value`.

Then, when the browser makes another request to the same server, it’ll send back the same cookie that the same server has set before:

```
GET / HTTP/1.1
Host: gmail.com
Cookie: session=value
```

In Flask, we can use the flask_session library to help manage this for us:

```py 
from flask import Flask, redirect, render_template, request, session
from flask_session import Session

# Configure app
app = Flask(__name__)

# Configure session
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)
```


