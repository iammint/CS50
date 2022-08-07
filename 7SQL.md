```py
import csv

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        print(row["title"])
```

To avoid near-duplicates, since `Friends` and `friends` are indeed different strings still.

## Aviod near-duplicates

We'll want to change the current title to all uppercase, and remove whitespace around it, before we add it to our list:

```py
import csv

titles = []

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        title = row["title"].strip().upper()
        if not title in titles:
            titles.append(title)

for title in titles:
    print(title)
```

## Set

Actually Python has another data structure built-in, `set`, which ensures that all the values are unique.

```py
import csv

titles = set()

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        title = row["title"].strip().upper()
        titles.add(title)

for title in sorted(titles):
    print(title)
```

## Counting

We can use a dictionary, instead of a set, to count the number of times we’ve seen each title, with the keys being the titles and the values being an integer counting the number of times we see each of them:

```py
import csv

titles = {}

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        title = row["title"].strip().upper()
        if title in titles:
            titles[title] += 1
        else:
            titles[title] = 1

        # Or
        # if not title in titles:
        #     titles[title] = 0
        # titles[title] += 1

for title in sorted(titles):
    print(title, titles[title])
```

## Sort

We can sort by the values in the dictionary by changing our loop to:

```py
import csv

titles = {}

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        title = row["title"].strip().upper()
        if title in titles:
            titles[title] += 1
        else:
            titles[title] = 1


def get_value(title):
    return titles[title]

for title in sorted(titles, key=get_value, reverse=True):
    print(title, titles[title])
```

We define a function, which just returns the value of a title in the dictionary with `titles[title]`. The `sorted` function, in turn, will take in that function as the key to sort the dictionary. And we’ll also pass in `reverse=True` to sort from largest to smallest, instead of smallest to largest.

```
$ python favorites.py
THE OFFICE 15
FRIENDS 9
COMMUNITY 8
GAME OF THRONES 6
...
```

We can actually define our function in the same line, with this syntax:

```py
for title in sorted(titles, key=lambda title:titles[title], reverse=True):
    print(title, titles[title])
```

We can write and pass in a **lambda**, or anonymous function, which has no name but takes in some argument or arguments, and returns a value immediately.

Notice that there are no parentheses or `return` keyword, but concisely has the same effect as our `get_value` function earlier.

# Regular Expressions

> a standardized way to represent a pattern that a string must match.

- `.` for any character
- `.*` for 0 or more characters
- `.+` for 1 or more characters
- `?` for an optional character
- `^` for start of input
- `$` for end of input

We can change our program earlier to use `re`, a Python library for regular expressions:

```py
import csv
import re

counter = 0

with open("favorites.csv", "r") as file:
    reader = csv.DictReader(file)

    for row in reader:
        title = row["title"].strip().upper()
        if re.search("^(OFFICE|THE OFFICE)$", title):
            counter += 1

print(f"Number of people who like The Office: {counter}")
```

# Relational databases

**Relational databases** are programs that store data, ultimately in files, but with additional data structures and interfaces that allow us to search and store data more efficiently.

We can use relational databases to store our data in a way that is more efficient than using a flat file.

When working with data, we generally need four types of basic operations with the acronym `CRUD`:

- `CREATE`
- `READ`
- `UPDATE`
- `DELETE`

# SQL
> With another programming language, SQL, we can interact with databases with verbs like:

- `CREATE`, `INSERT`
- `SELECT`
- `UPDATE`
- `DELETE`, `DROP`

Syntax in SQL might look like:

```SQL
CREATE TABLE table (column type, ...);
```

With this statement, we can create a **table**, which is like a spreadsheet with rows and columns.

In SQL, we choose the types of data that each column will store.

We’ll use a common database program called **SQLite**, one of many available programs that support SQL. Other database programs include Oracle Database, MySQL, PostgreSQL, and Microsoft Access.

SQLite stores our data in a binary file, with 0s and 1s that represent data efficiently. We’ll interact with our tables of data through a command-line program, `sqlite3`.

We’ll run some commands in VS Code to import our CSV file into a database:
```SQL
$ sqlite3 favorites.db
SQLite version 3.36.0 2021-06-18 18:36:39
Enter ".help" for usage hints.
sqlite> .mode csv
sqlite> .import favorites.csv favorites
```

Now, we’ll see three files, including `favorites.db`:

```
$ ls
favorites.csv  favorites.db  favorites.py
```

We can open our database file again, and check the schema, or design, of our new table with `.schema`:

```SQL
$ sqlite3 favorites.db
SQLite version 3.36.0 2021-06-18 18:36:39
Enter ".help" for usage hints.
sqlite> .schema
CREATE TABLE IF NOT EXISTS "favorites"(
  "Timestamp" TEXT,
  "title" TEXT,
  "genres" TEXT
);
```

We can select, or read data, with:

```SQL
sqlite> SELECT title FROM favorites;
+------------------------------------+
|                title               |
+------------------------------------+
| How i met your mother              |
| The Sopranos                       |
| Friday Night Lights                |
...
```

SQL supports many functions that we can use to count and summarize data:
- `AVG`
- `COUNT`
- `DISTINCT`
- `LOWER`
- `MAX`
- `MIN`
- `UPPER`
…

We can clean up our titles as before, converting them to uppercase and printing only the unique values:

```SQL
sqlite> SELECT DISTINCT(UPPER(title)) FROM favorites;
|      (UPPER(title))       |
+---------------------------+
| HOW I MET YOUR MOTHER     |
| OFFICE                    |
| GAMES OF THRONES          |
| COMMUNITY                 |
| THE OFFICE                |
| FRIENDS                   |
| BREAKING BAD              |
| NEW GIRL                  |
| MODERN FAMILY             |
| FAMILY GUY                |
| AVATAR THE LAST AIRBENDER |
| THE GOOD PLACE            |
| WHITE COLLAR              |
+---------------------------+
```

We can also get a count of how many responses there are:

```SQL
sqlite> SELECT COUNT(title) FROM favorites;
+--------------+
| COUNT(title) |
+--------------+
| 30           |
+--------------+
```

We can also add more phrases to our command:

- `WHERE`, adding a Boolean expression to filter our data
- `LIKE`, filtering responses more loosely
- `ORDER BY`
- `LIMIT`
- `GROUP BY`
- …

## LIMIT 

We can limit the number of results:

```SQL
sqlite> SELECT title FROM favorites LIMIT 10;
+-----------------------+
|         title         |
+-----------------------+
| How I met your mother |
| Office                |
| office                |
| office                |
| Games of thrones      |
| games of thrones      |
| community             |
| how i met your mother |
| community             |
| community             |
+-----------------------+
```

## WHERE LIKE
We can also look for titles matching a string:

```SQL
sqlite> SELECT title FROM favorites WHERE title LIKE "%office%"

+------------+
|   title    |
+------------+
| Office     |
| office     |
| office     |
| The Office |
| The office |
| office     |
| the office |
| OFFICE     |
| office     |
+------------+
```

The `%` character is a placeholder for zero or more other characters, so SQL supports some pattern matching, though not it’s not as powerful as regular expressions are.


## COUNT
We can select just the count in our command:

```SQL
sqlite> LECT COUNT(title) FROM favorites WHERE title LIKE "%community%

+--------------+
| COUNT(title) |
+--------------+
| 5            |
+--------------+
```

## DELETE

If we don’t like a show, we can even delete it:

```SQL 
sqlite> SELECT COUNT(title) FROM favorites WHERE title LIKE "%friends%";
+--------------+
| COUNT(title) |
+--------------+
| 9            |
+--------------+
sqlite> DELETE FROM favorites WHERE title LIKE "%friends%";
sqlite> SELECT COUNT(title) FROM favorites WHERE title LIKE "%friends%";
+--------------+
| COUNT(title) |
+--------------+
| 0            |
+--------------+
```

<font color="red">With SQL, we can change our data more easily and quickly than with Python.</font>


## UPDATE

We can update a specific row of data:

```SQL 
sqlite> SELECT title FROM favorites WHERE title = "Thevoffice";
+------------+
|   title    |
+------------+
| Thevoffice |
+------------+
sqlite> UPDATE favorites SET title = "The Office" WHERE title = "Thevoffice";
sqlite> SELECT title FROM favorites WHERE title = "Thevoffice";
sqlite> 
```


We can change the values in multiple rows, too:

```SQL 
sqlite> SELECT genres FROM favorites WHERE title = "Game of Thrones";
+--------------------------------------------------------------------------------------------------------------+
|                                                    genres                                                    |
+--------------------------------------------------------------------------------------------------------------+
| Action, Adventure, Drama, Fantasy, Thriller, War                                                             |
| Action, Adventure, Drama                                                                                     |
| Action, Adventure, Comedy, Drama, Family, Fantasy, History, Horror, Musical, Mystery, Romance, Thriller, War |
| Action, Drama, Family, Fantasy, War                                                                          |
| Fantasy, Thriller, War                                                                                       |
+--------------------------------------------------------------------------------------------------------------+
sqlite> UPDATE favorites SET genres = "Action, Adventure, Drama, Fantasy, Thriller, War" WHERE title = "Game of Thrones";
sqlite> SELECT genres FROM favorites WHERE title = "Game of Thrones";
+--------------------------------------------------+
|                      genres                      |
+--------------------------------------------------+
| Action, Adventure, Drama, Fantasy, Thriller, War |
| Action, Adventure, Drama, Fantasy, Thriller, War |
| Action, Adventure, Drama, Fantasy, Thriller, War |
| Action, Adventure, Drama, Fantasy, Thriller, War |
| Action, Adventure, Drama, Fantasy, Thriller, War |
+--------------------------------------------------+
```


- With `DELETE` and `DROP`, we can remove rows and even entire tables as well.
- And notice that in our commands, we’ve written SQL keywords in all caps, so they stand out more.
- There also isn’t a built-in way to undo commands, so if we make a mistake we might have to build our database again!


# Tables
We’ll take a look at our schema again:

```SQL 
sqlite> .schema
CREATE TABLE IF NOT EXISTS "favorites"(
  "Timestamp" TEXT,
  "title" TEXT,
  "genres" TEXT
);
```
If we look at our values of genres, we see some redundancy:

```SQL
sqlite> SELECT genres FROM favorites;
+-----------------------------------------------------------+
|                          genres                           |
+-----------------------------------------------------------+
| Comedy                                                    |
| Comedy, Crime, Drama, Horror, Sci-Fi, Talk-Show, Thriller |
| Drama, Family, Sport                                      |
| Animation, Comedy                                         |
| Comedy, Drama                                             |
...
```

If we want to search for shows that are comedies, we can use `LIKE` keyword again but two genres “Music” and “Musical”, are similar enough for that to be problematic.

We can actually write our own Python program that will use SQL to import our CSV data into two tables:

```py 
# Imports titles and genres from CSV into a SQLite database

import cs50
import csv

# Create database
open("favorites8.db", "w").close()
db = cs50.SQL("sqlite:///favorites8.db")
  
# Create tables
db.execute("CREATE TABLE shows (id INTEGER, title TEXT NOT NULL, PRIMARY KEY(id))")
db.execute("CREATE TABLE genres (show_id INTEGER, genre TEXT NOT NULL, FOREIGN KEY(show_id) REFERENCES shows(id))")
  
# Open CSV file
with open("favorites.csv", "r") as file:
  
    # Create DictReader
    reader = csv.DictReader(file)
  
    # Iterate over CSV file
    for row in reader:
  
        # Canoncalize title
        title = row["title"].strip().upper()
  
        # Insert title
        show_id = db.execute("INSERT INTO shows (title) VALUES(?)", title)
  
        # Insert genres
        for genre in row["genres"].split(", "):

            db.execute("INSERT INTO genres (show_id, genre) VALUES(?, ?)", show_id, genre)
```

Now, our database will have this design:

```SQL 
$ sqlite3 favorites8.db
SQLite version 3.36.0 2021-06-18 18:36:39
Enter ".help" for usage hints.
sqlite> .schema
CREATE TABLE shows (id INTEGER, title TEXT NOT NULL, PRIMARY KEY(id));
CREATE TABLE genres (show_id INTEGER, genre TEXT NOT NULL, FOREIGN KEY(show_id) REFERENCES shows(id));
```

- We have one table, `shows`, with an `id` column and a `title` column. We can specify that a `title` isn’t null, and that id is the column we want to use as a primary key.

- Then, we’ll have a table called `genres`, where we have a `show_id` column that references our `shows` table, along with a genre column.

- This is an example of a **relation**, like a link, between rows in different tables in our database.

In our `shows` table, we’ll see each show with an `id` number:

```SQL 
sqlite> SELECT * FROM shows;
+-----+------------------------------------+
| id  |               title                |
+-----+------------------------------------+
| 1   | HOW I MET YOUR MOTHER              |
| 2   | THE SOPRANOS                       |
| 3   | FRIDAY NIGHT LIGHTS                |
| 4   | FAMILY GUY                         |
| 5   | NEW GIRL                           |
| 6   | FRIENDS                            |
| 7   | OFFICE                             |
...
```

And we can see that the `genres` table has one or more rows for each `show_id`:

```SQL 
sqlite> SELECT * FROM genres;
+---------+-------------+
| show_id |    genre    |
+---------+-------------+
| 1       | Comedy      |
| 2       | Comedy      |
| 2       | Crime       |
| 2       | Drama       |
| 2       | Horror      |
| 2       | Sci-Fi      |
| 2       | Talk-Show   |
| 2       | Thriller    |
| 3       | Drama       |
| 3       | Family      |
| 3       | Sport       |
| 4       | Animation   |
| 4       | Comedy      |
| 5       | Comedy      |
| 6       | Comedy      |
| 7       | Comedy      |
...
```

Since each show may have more than one genre, we can have more than one row per show in our `genres` table, known as a one-to-many relationship.

Furthermore, the data is now cleaner, since each genre name is in its own row.

We can select all the shows are that comedies by selecting from the genres table first, and then looking for those ids in the shows table:

```SQL
sqlite> SELECT title FROM shows WHERE id IN (SELECT show_id FROM genres WHERE genre = "Comedy");
+------------------------------------+
|               title                |
+------------------------------------+
| HOW I MET YOUR MOTHER              |
| THE SOPRANOS                       |
| FAMILY GUY                         |
| NEW GIRL                           |
| FRIENDS                            |
| OFFICE                             |
| MODERN FAMILY                      |
...
```

Now we can sort and show just the unique titles by adding to our command:

```SQL 
sqlite> SELECT DISTINCT(title) FROM shows WHERE id IN (SELECT show_id FROM genres WHERE genre = "Comedy") ORDER BY title;
+------------------------------------+
|               title                |
+------------------------------------+
| ARCHER                             |
| ARRESTED DEVELOPMENT               |
| AVATAR THE LAST AIRBENDER          |
| B99                                |
| BILLIONS                           |
| BLACK MIRROR                       |
...
```

And we can add new data to each table, in order to add another show. First, we’ll add a new row to the `shows` table for Seinfeld:

```SQL 
sqlite> INSERT INTO shows (title) VALUES("Seinfeld");
```