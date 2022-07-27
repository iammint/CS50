# Compiling

`clang` is a compiler for C and C++. And we can add a **command-line argument**.

```
clang -o hello hello.c
//And we need to tell our compiler to actually link in the `cs50` machine code library.
clang -o hello hello.c -lcs50
```

Compiling source code into machine code is actually made up of four smaller steps:

- preprocessing

  Replace `#include xxx` with the contents of functions and prototypes we want to use in the file.

- compiling

  **Compiling** takes our source code, in C, and converts it to another language called **assembly language**.

- assembling

  Take the code in assembly ans translate it to binary by **assembling** it. The instructions in binary are machine code, which a computer’s CPU can run directly.

- linking

  Previously compiled version of libraries that we included earlier are actually combined with the compiled binary of our program. In other words, linking is the process of combining all the machine code.

# Debugging

You need to set breakpoints before debugging. And you can debug with `printf`.

## Step over

When you are debugging, you can step over a line of code.

## Step into

When you are debugging, you can step into a function.

# Memory

In C, we have different types of variables we can use for storing data. Each variable is stored with a fixed number of bytes, and for most computer systems each type has the following size:

- `bool`, 1 byte

  - A Boolean value can technically be represented with just a single bit, but for simplicity our computers use an entire byte.

- `char`, 1 byte

  - Recall that with ASCII, we have a maximum of 256 different possible characters, since there are 8 bits in a byte.

- `double`, 8 bytes

  - Twice as many bytes as a float.

- `float`, 4 bytes

- `int`, 4 bytes

  - Recall that a 32-bit integer can represent about 4 billion different values.

- `long`, 8 bytes

  - Twice as many bytes as an `int`.

- `string`, ? bytes
  - A `string` takes up a variable amount of space, since it could be short or long.\

Inside our computers, we have chips called RAM, random-access memory, that stores zeroes and ones. We can think of bytes stored in RAM as though they were in a grid, one after the other:

![Snipaste_2022-07-27_11-44-22.png](https://media.haochen.me/Snipaste_2022-07-27_11-44-22.png)

One byte takes up one of those squares in RAM.

# Arrays

Arrays are a way to store multiple values in a single variable.

```C
#include <stdio.h>

int main(void)
{
    int score1 = 72;
    int score2 = 73;
    int score3 = 33;

    printf("Average: %f\n", (score1 + score2 + score3) / 3);
}
```

The design of our program isn’t ideal, since we have just three variables, and we’d have to define more and more variables. While our program is running, the three int variables are stored in memory:

![Snipaste_2022-07-27_11-48-10.png](https://media.haochen.me/Snipaste_2022-07-27_11-48-10.png)

It turns out we can refer to multiple variables with one name with another type called an array. With an array, we can store values of the same type, back-to-back, or contiguously.

```c
#include <stdio.h>
#include <cs50.h>

int main(void)
{
    int n = get_int("How many scores? ");
    int scores[n];
    for( int i = 0; i < n; i++)
    {
        scores[i] = get_int("Score: ");
    }
}
```

# Characters

We can print different types:

```C
#include <stdio.h>
int main(void)
{
    char c1 = 'H';
    char c2 = 'I';
    char c3 = '!';

    // printf("%c%c%c\n", c1, c2, c3);
    printf("%i %i %i\n", c1, c2, c3);
}
```

```
$ make hi
$ ./hi
72 73 33
```

We can explicitly convert chars to ints as well with:

```c
printf("%i %i %i\n", (int) c1, (int) c2, (int) c3);
```

# Strings

We can see the same output as above by using a string variable. It turns out that strings are actually just arrays of characters, and defined not in C but by the CS50 library.

```C
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    string s = "HI!";
    printf("%i %i %i\n", s[0], s[1], s[2]);
}
//72 73 33
```

- In memory, our three char variables might have been stored like this:

![Snipaste_2022-07-27_12-01-27.png](https://media.haochen.me/Snipaste_2022-07-27_12-01-27.png)

- Each character in our string is stored in a byte of memory as well:

![Snipaste_2022-07-27_12-02-24.png](https://media.haochen.me/Snipaste_2022-07-27_12-02-24.png)

In C, strings end with a special character, `'\0'`, or a byte with all eight bits set to 0, so our programs have a way of knowing where the string ends. This character is called the **null character**, or NUL. So, we actually need four bytes to store our string with three characters.

We can even print the last byte in our string to see that its value is indeed 0:

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    string s = "HI!";
    printf("%i %i %i %i\n", s[0], s[1], s[2], s[3]);
}
//72 73 33 0
```

We can create a function to calculate the length of a string:

```C
#include <cs50.h>
#include <stdio.h>

int string_length(string s);
int main(void)
{
    string name = get_string("Name: ");
    int length = string_length(name);
    printf("%i\n", length);
}
// Our function, string_length, will take in a string as an argument, and return an int.
int string_length(string s)
{
    int i = 0;
    while(s[i] != '\0')
    {
        i++;
    }
    return i;
}
```

We can use a function that comes with C’s string library, `strlen`, to get the length of the string:

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string name = get_string("Name: ");
    int length = strlen(name);
    printf("%i\n", length);
}
```

Now we can use `strlen` and try to print each characters of our string with a loop.

```C
#include <cs50.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string s = get_string("Input:  ");
    printf("Output: \n");
    for (int i = 0, n = strlen(s); i < n; i++)
    {
        printf("%c\n", s[i]);
    }
}
```

## tolowerCase

```C
#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string s = get_string("Before: ");
    printf("After:  ");
    for (int i = 0, n = strlen(s); i < n; i++)
    {
        // printf("%c", toupper(s[i]));
        if (islower(s[i]))
        {
            printf("%c", s[i] - 32);
        }
        else
        {
            printf("%c", s[i]);
        }
    }
    printf("\n");
}
```

# Command-line arguments

`argc` and `argv` are two variables that our main function will now get automatically when our program is run from the command line.

```C
#include <cs50.h>
#include <stdio.h>

int main(int argc, string argv[])
{
    printf("hello, %s\n", argv[0]);
}
```

The first argument, `argv[0]`, is the name of our program (the first word typed, like `./hello)`. And the second argument, `argv[1`, is the first argument that the user typed after the name of our program.

We should make sure that we have the right number of arguments before we try to print something that isn’t there:

```C
#include <cs50.h>
#include <stdio.h>

int main(int argc, string argv[])
{
    if (argc == 2)
    {
        printf("hello, %s\n", argv[1]);
    }
    else
    {
        printf("hello, world\n");
    }
}
```

```
$ make argv
$ ./argv
hello, world
$ ./argv David
hello, David
$ ./argv David Malan
hello, world
```

## Exit status

Our main function also returns an integer value called an **exit status**. By default, our main function returns 0 to indicate nothing went wrong, but we can write a program to return a different value:

```C
#include <cs50.h>
#include <stdio.h>

int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("missing command-line argument\n");
        return 1;
    }
    printf("hello, %s\n", argv[1]);
    return 0;
}
```

A non-zero exit status indicates some error to the system that runs our program. Once we run return 1; our program will exit early with an exit status of 1. We might have seen error codes in the past when programs we used encountered errors as well.

# Applications

**Cryptography** is the art of scrambling information to hide its contents. If we wanted to send a message to someone, we might want to **encrypt**, or somehow scramble that message so that it would be hard for others to read. The original message, or input to our algorithm, is called **plaintext**, and the encrypted message, or output, is called **ciphertext**. And the algorithm that does the scrambling is called a **cipher**. A cipher generally requires another input in addition to the plaintext. A **key**, like a number, is some other input that is kept secret:

![Snipaste_2022-07-27_14-39-21.png](https://media.haochen.me/Snipaste_2022-07-27_14-39-21.png)
