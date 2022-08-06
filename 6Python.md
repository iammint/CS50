# Python syntax

- Unlike in C, where curly braces are used to indicate blocks of code, the exact indentation of each line determines the level of nesting in Python. And we don’t need parentheses around the Boolean expressions.
- And instead of `else if`, we just say `elif`.
- Both `True` and `False` are capitalized in Python.

```py
while True:
    print("hi")
```

## for loop

We can write a `for` loop, where we can do something for each value in a list:

```py
for i in [0, 1, 2]:
    print("hi")
# We can use a special function `range` to get any number of values

for i in range(3):
    print("hi")
# range(3) will give us a list up to but not including 3
```

`range()` takes other arguments as well, so we can have lists that start at different values and have different increments between values.

## Special types in Python

- `range`, sequence of numbers
- `list`, sequence of mutable values, or values we can change
- `tuple`, sequence of immutable values
- `dict`, dictionaries, collection of key/value pairs, like a hash table
- `set`, collection of unique values, or values without duplicates

## Libraries

```py
import cs50
# Supposed to use `cs50.get_int`

from cs50 import get_string
from cs50 import get_string, get_int
```

We can blur an image with:

```py
from PIL import Image, ImageFilter

before = Image.open("before.bmp")
after = before.filter(ImageFilter.BoxBlur(10))
after.save("after.bmp")
```

We can implement a dictionary with:

```py
# Create a new set called `words`
words = set()

def check(word):
    if word.lower() in words:
        return True
    else:
        return False

def load(dictionary):
  file = open(dictionary, "r")
  for line in file:
      word = line.rstrip()
      words.add(word)
  file.close()
  return True

def size():
    return len(words)

def unload():
    return True
```

We’re able to run our program with python speller.py texts/holmes.txt, but we’ll notice that it takes a few seconds longer to run than the C version. Even though it was much faster for us to write, we aren’t able to fully optimize our code by way of managing memory and implementing all of the details ourselves.

It turns out, we can cache, or save, the interpreted version of our Python program, so it runs faster after the first time. And Python is actually partially compiled too, into an intermediate step called **bytecode**, which is then run by the interpreter.

# Input, conditions

```py
from cs50 import get_string

answer = get_string("What's your name? ")
print("hello, " + answer)
# Same as
print(f"hello, {answer}")
```

We can also use a function that comes with Python, `input`:

```py
answer = input("What's your name? ")
print("hello, " + answer)
```

- If we call input ourselves, we get back strings for our values:

```py
x = input("x: ")
y = input("y: ")
print(x + y)
```

```
$ python calculator.py
x: 1
y: 2
12
```

So we need to cast:

```py
x = int(input("x: "))
y = int(input("y: "))
print(x + y)
```

# exception

```py
try:
    x = int(input("x: "))
except ValueError:
    print("This is not an int!")
    exit()
try:
    y = int(input("y: "))
except ValueError:
    print("This is not an int!")
    exit()
print(x + y)
```

# Floating point imprecision

```py
from cs50 import get_int
x = get_int("x: ")
y = get_int("y: ")
# z = x // y
# will get the 0.1 like in c
z = x / y
# We can use a format string to print out more digits after the decimal point:
print(f"{z:50f}")
```

```
$ python calculator.py
x: 1
y: 10
0.10000000000000000555111512312578270211815834045410
```

Unfortunately, we still have floating-point imprecision.

- To compare strings, we can:

```py
from cs50 import get_string
s = get_string("Do you agree? ")
if s == "Y" or s == "y":
    print("Agreed.")
elif s == "N" or s == "n":
    print("Not agreed.")

```

We can also check if our string is in a list after converting it to lowercase first:

```py
from cs50 import get_string
s = get_string("Do you agree? ").lower()
# s = s.lower()
if s in ["y", "yes"]:
    print("Agreed.")
elif s in ["n", "no"]:
    print("Not agreed.")
```

In Python, strings are also immutable, or unchangeable. When we make changes to a string, a new copy is made for us, along with all the memory management.

# No function hoisting

```py
# ❌❌❌❌❌
for i in range(3):
    meow()

def meow():
    print("meow~")

# meow() is not defined
```

```py
def main():
    for i in range(3):
        meow()

def meow():
    print("meow~")

main()
```

The important part of our code will still be at the top of our file, so it’s easy to find.

Our functions can take arguments, too:

```py
def main():
    meow(3)

def meow(n):
    for i in range(n):
        print("meow")

main()
```

# Mario

In Python, there is no do while loop, but we can achieve the same effect:

```py
from cs50 import get_int
while True:
    n = get_int("n: ")
    if n > 0:
        break

for i in range(n):
    print("#")
```

We'll write an infinite loop, so we do something at least once, and then use `break` to exit the loop if we've met some condition.

```py
from cs50 import get_int

def main():
    height = get_height()
    for i in range(height):
        print("#")

def get_height():
    while True:
        n = get_int("Height: ")
        if n > 0:
            break
    # You can still access n outside the block, cuz there is no block scope in Python.
    return n

main()
```

Notice that, in Python, variables are scoped to a function, meaning we can use them outside of the loop they’re created in.

```py
from cs50 import get_int
def main():
    height = get_Height()
    for i in range(height):
        print("#")

def get_Height():
    while True:
        try:
            n = int(input("Height: "))
            if n > 0:
                break
        except ValueError:
            print("This is not an integer!")
    return n
main()
```

Now we can try to print question marks on the same line:

```py
from cs50 import get_int
for i in range(4):
    print("?", end="")
print()

# print("#" * 4)
```

```
$ python mario.py
????
```

Two dementional structures:

```py
for i in range(4):
    for j in range(4):
        print("#", end="")
    print()
```

Or just:

```py
for i in range(4):
    print("#" * 4)
```

# Lists, strings

## sum(), len()

```py
scores = [72, 73, 33]
average = sum(scores) / len(scores)
print(f"Average: {average}")
# With append method, we can add new values to scores.
```

## append()

```py
from cs50 import get_int
scores = []
for i in range(3):
    score = get_int("Score: ")
    scores.append(score)
    # scores += [score]
print(scores)
```

## upper()

```py
from cs50 import get_string

before = get_string("Before: ")
print("After: ", end="")
for c in before:
    print(c.upper(), end="")
print()
```

Or we can also just write `after = before.upper()`, without having to iterate over each character ourselves.

```py
from cs50 import get_string

before = get_string("Before: ")
print("After: " + before.upper())
```

# Command-line arguments, exit codes

```py
from sys import argv

if len(argv) == 2:
    print("Hello,", argv[1])
    # print("Hello, " + argv[1])
else:
    print("Hello, world")

# We can also iterate argv
for arg in argv:
    print(arg)
```

With Python, we can start at a different index in a list:

```py
for arg in argv[1:]:
    print(arg)
```

- This lets us slice the list from 1 to the end.
- We can write `argv[:-1]` to get everything in the list except the last element.

## Exit status

> The exit status is the number that is returned when the program is terminated.
> exit(0) signifies success, and anything else signifies error.

```py
from sys import argv, exit

if len(argv) != 2:
    print("Missing command-line argument")
    exit(1)

print(f"hello, {argv[1]}")
exit(0)
```

# Algorithms

We can implement linear search by checking each element in a list:

```py
import sys

numbers = [4, 6, 8, 2, 2, 0]

if 0 in numbers:
    print("Found~")
    sys.exit(0)
print("Not found")
sys.exit(1)
```

If we have a dictionary, a set of key-value pairs, we can also check for a particular key, and look at the value stored for it:

```py
from cs50 import get_string

people = {
    "Carter": "+1-617-495-1000",
    "David": "+1-949-468-2750"
}

name = get_string("Name: ")
if name in people:
    number = people[name]
    print(f"Number: {number}")
```

# More libraries

On our own Mac or PC, we can use another library to convert text to speech:

```py
import pyttsx3

engine = pyttsx3.init()
engine.say("hello, world")
engine.runAndWait()
```

By reading the documentation, we can use a Python library called `pyttsx3` to play some string as audio.

We can use another library, face_recognition, to find faces in images with detect.py:

```py
# Find faces in picture
# https://github.com/ageitgey/face_recognition/blob/master/examples/find_faces_in_picture.py

from PIL import Image
import face_recognition

# Load the jpg file into a numpy array
image = face_recognition.load_image_file("office.jpg")

# Find all the faces in the image using the default HOG-based model.
# This method is fairly accurate, but not as accurate as the CNN model and not GPU accelerated.
# See also: find_faces_in_picture_cnn.py
face_locations = face_recognition.face_locations(image)

for face_location in face_locations:

    # Print the location of each face in this image
    top, right, bottom, left = face_location

    # You can access the actual face itself like this:
    face_image = image[top:bottom, left:right]
    pil_image = Image.fromarray(face_image)
    pil_image.show()
```

We can respond to input from the user:

```py
# Recognizes a greeting

# Get input
words = input("Say something!\n").lower()

# Respond to speech
if "hello" in words:
    print("Hello to you too!")
elif "how are you" in words:
    print("I am well, thanks!")
elif "goodbye" in words:
    print("Goodbye to you too!")
else:
    print("Huh?")
```

We can recognize audio input from a microphone and respond with:

```py
# Responds to a greeting
# https://pypi.org/project/SpeechRecognition/

import speech_recognition

# Obtain audio from the microphone
recognizer = speech_recognition.Recognizer()
with speech_recognition.Microphone() as source:
    print("Say something:")
    audio = recognizer.listen(source)

# Recognize speech using Google Speech Recognition
words = recognizer.recognize_google(audio)

# Respond to speech
if "hello" in words:
    print("Hello to you too!")
elif "how are you" in words:
    print("I am well, thanks!")
elif "goodbye" in words:
    print("Goodbye to you too!")
else:
    print("Huh?")
```

We can create a QR code, or two-dimensional barcode, with another library:

```py
import os
import qrcode

img = qrcode.make("https://youtu.be/xvFZjo5PgG0")
img.save("qr.png", "PNG")
os.system("open qr.png")
```
