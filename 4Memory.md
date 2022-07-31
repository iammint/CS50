# Pixels

Since an image is stored with a finite number of bytes, each perhaps representing a red, green, or blue value for each pixel, there is in turn a finite number of pixels we can see.Since this image is stored with a finite number of bytes, each perhaps representing a red, green, or blue value for each pixel, there is in turn a finite number of pixels we can see.

A simpler image of a smiley face might be represented with a single bit per pixel:

![Snipaste_2022-07-30_16-37-25.png](https://media.haochen.me/Snipaste_2022-07-30_16-37-25.png)

# Hexadecimal

RGB is made up of three hexadecimal digits, each representing a color.

With two digits, we can have a maximun value of `FF`, or 16^1 _ 15 + 16^0 _ 15 = 225.

- The values in a computer’s memory are still stored as binary, but this way of representation helps us humans represent larger numeric values with fewer digits needed.

- With 8 bits in binary, the highest value we can count to is also 255, with 11111111. So two digits in hexadecimal can conveniently represent the value of a byte in binary. (Each digit in hexadecimal, with 16 values, maps to four bits in binary.)

# Addresses, pointers

For our computer's memory, we'll see hexadecimal used to describe each address or location.

> By writing `0x` in front of a hexadecimal value, we can distinguish them from decimal values.

![Snipaste_2022-07-30_17-09-00.png](https://media.haochen.me/Snipaste_2022-07-30_17-09-00.png)

We might create a value `n = 50`, and print it out.

In our computer's memory, there are now 4 bytes somewhere that have the binary value of 50, with some value for its address, like `0x123`:

![Snipaste_2022-07-30_17-12-36.png](https://media.haochen.me/Snipaste_2022-07-30_17-12-36.png)

**A pointer is a variable that stores an address in memory, where some other variable might be stored.**

The `&` operator can be used to get the address of some variable, as with `&n`. And the `* `operator declares a variable as a pointer, as with int `*p`, indicating that we have a variable called `p` that points to an `int`. The `*` operator is also the **dereference operator**, which goes to an address to get the value stored there. So, to store the address of a variable n into a pointer p, we would write:

```c
#include <cs50.h>

int main(void)
{
    int n = 50;
    int *p = &n;
    // %p is the format code to print an address with printf.
    printf("%p\n", p);
    // Or printf("%p\n", &n); directly.
    printf("%i\n", *p);
    // Or printf("%i\n", n); directly.
}
```

We can run this program a few times, and see that the address of n in memory changes, since different addresses in memory will be available at different times.

With C, we can also go to specific addresses in memory, which might cause **segmentation faults**, where we’ve tried to read or write to memory we don’t have permission to.

In memory, we might have one variable, `p`, with the value of some address, like `0x123`, stored, and another variable, an integer with the value `50`, at that addresss:

![Snipaste_2022-07-30_18-25-39.png](https://media.haochen.me/Snipaste_2022-07-30_18-25-39.png)

Notice that p takes up 8 bytes, since in modern computer systems, 64 bits are used in order to address the billions of bytes of memory available. With 32 bits, we can only count up to about 4 billion bytes, or about 4GB of memory.

We can simply think of `p` as pointing at some value in memory.

# Strings

```c
#include <stdio.h>

int main(void)
{
    char *s = "HI!";
    // Same as `string s = "HI!;"`
    printf("%s\n", s);
}
```

- We can experiment and see the address of characters:

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    string s = "HI!";
    char c = s[0];
    char *p = &c;
    printf("%p\n", s);
    printf("%p\n", p);
}
```

```
$ make address
$ ./address
0x402004
0x7ffd4227fdd7
```

We store the first character of `s` into `c`, and print out its address with `p`. We also print out s as an address with `%p`, and we see that the values are difference since we made a copy of the first character with `char c = s[0];`.

Now we print the address of each character in `s`:

```c
#include <stdio.h>

int main(void)
{
    char *s = "HI!";
    printf("%p\n", s);
    printf("%p\n", &s[0]);
    printf("%p\n", &s[1]);
    printf("%p\n", &s[2]);
    printf("%p\n", &s[3]);
}
```

```
$ make address
$ ./address
0x402004
0x402004
0x402005
0x402006
0x402007
```

- In the CS50 Library, a string is defined with just `typedef char *string;`. With `typedef`, we’re creating a custom data type for the word `string`, making it equivalent to `char *`.

# Pointer arithmetic

We can go to addresses directly:

```c
#include <stdio.h>

int main(void)
{
    char *s = "HI!";
    printf("%c\n", *s);
    printf("%c\n", *(s + 1));
    printf("%c\n", *(s + 2));
}
```

`s[1]` is **syntactic sugar**, like an abstraction for `*(s + 1)`, equivalent in function but more human-friendly to read and write.

**Pointer arithmetic** is the process of applying mathematical operations to pointers, using them just like numbers (which they are).

We can declare an array of numbers, and access them with pointer arithmetic:

```c
#include <stdio.h>

int main(void)
{
    int numbers[] = {4, 6, 8, 2, 7, 5, 0};

    printf("%i\n", *numbers);
    printf("%i\n", *(numbers + 1));
    printf("%i\n", *(numbers + 2));
    printf("%i\n", *(numbers + 3));
    printf("%i\n", *(numbers + 4));
    printf("%i\n", *(numbers + 5));
    printf("%i\n", *(numbers + 6));
}
```

- It turns out we only need to add `1` to the address of `numbers`, instead of `4`(even though `int`s are 4 bytes in size), since the compiler already knows that the type of each value in `numbers` is 4 bytes.

- And notice that `numbers` is an array, but we can use it as a pointer with `*numbers`.

# Compare and copy

- Let’s try to compare two integers from the user:

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    int i = get_int("i: ");
    int j = get_int("j: ");

    if (i == j)
    {
        printf("Same\n");
    }
    else
    {
        printf("Different\n");
    }
}
// it works as we'd expect
```

- But what if we want to compare two strings?

```c
#include <cs50.h>
#include <stdio.h>

int main(void)
{
    char *s = get_string("s: ");
    char *t = get_string("t: ");

    if (s == t)
    {
        printf("Same\n");
    }
    else
    {
        printf("Different\n");
    }
}
```

```
$ make compare
$ ./compare
s: HI!
t: BYE!
Different
$ ./compare
s: HI!
t: HI!
Different
```

Each “string” is a pointer, `char *`, to a different location in memory, where the first character of each string is stored. So even if the characters in the string are the same, this will always print “Different”.

And `get_string`, this whole time, has been returning just a char \*, or a pointer to the first character of a string from the user. Since we called `get_string` twice, we got two different pointers back. The addresses of our two strings are indeed different.

We can fix it by using `if (strcmp(s, t) == 0)`.

Let’s visualize how this might look in our computer’s memory. Our first string might be at address 0x123, our second might be at 0x456, and `s` will have the value of `0x123`, pointing at that location, and `t` will have the value of `0x456`, pointing at another location:

![Snipaste_2022-07-30_20-41-53.png](https://media.haochen.me/Snipaste_2022-07-30_20-41-53.png)

```c
#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string s = get_string("s: ");

    string t = s;

    t[0] = toupper(t[0]);

    printf("s: %s\n", s);
    printf("t: %s\n", t);
}
```

```
$ make copy
$ ./copy
s: hi!
s: Hi!
t: Hi!
```

- Since we set s and t to the same value, or the same address, they’re both pointing to the same character, and so we capitalized the same character in memory:

![Snipaste_2022-07-30_21-20-54.png](https://media.haochen.me/Snipaste_2022-07-30_21-20-54.png)

# Memory allocation

- To actually make a copy of a string, we have to do a little more work, and copy each character in s to somewhere else in memory.
- We’ll need to use a new function, `malloc`, to allocate some number of bytes in memory. And we’ll use `free` to mark memory as usable when we’re done with it, so the operating system can do something else with it.

```c
#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *s = get_string("s: ");
    // add 1 for terminating null character'\0'.
    char *t = malloc(strlen(s) + 1);

    for (int i = 0, n = strlen(s) + 1; i < n; i++)
    {
        t[i] = s[i];
    }
    // Same as strcpy(t, s) from `#include <stdlib.h>`;
    // Still need to use `malloc()`
    t[0] = toupper(t[0]);

    printf("s: %s\n", s);
    printf("t: %s\n", t);

    free(t);
}
```

```
$ make copy
$ ./copy
s: hi!
s: hi!
t: Hi!
```

We create a new variable to point to a new srting with `char *t`. The arguments to `malloc` is the number of bytes we'd like to use.

We’ll remember to call `free` on t, since we allocated it ourselves.

- We'll add some error-checking to our program:

```C
#include <cs50.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    char *s = get_string("s: ");

    char *t = malloc(strlen(s) + 1);
    // If our computer is out of memory, `malloc` will return `NULL`, the null pointer.
    if (t == NULL)
    {
        return 1;
    }

    strcpy(t, s);
    // We should also check that `t` has a length before trying to capitalize the first character.
    if (strlen(t) > 0)
    {
        t[0] = toupper(t[0]);
    }

    printf("s: %s\n", s);
    printf("t: %s\n", t);

    free(t);
}
```

# Valgrind

> Valgrind 是一款用于内存调试、内存泄漏检测以及性能分析的软件开发工具。valgrind is a command-line tool that we can use to run our program and see if it has any memory-related issues.

- Let’s allocate memory for some integers:

```C
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    // We’ll use malloc to get enough memory for 3 times the size of an int, which we can find out with sizeof.
    int *x = malloc(3 * sizeof(int));
    x[1] = 72;
    x[2] = 73;
    x[3] = 33;
}
```

<font color="red">Mistakes</font>

1. We’ve deliberately made a mistake where we forgot arrays are 0-indexed, and started at `x[1]` instead. Then, with `x[3]`, we’re trying to access memory beyond the bounds of what we have access to.
2. We also don’t free the memory we’ve allocated.

We’ll run `valgrind ./memory` after compiling, and we’ll see a lot of output.

We can fix our code:

```C
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int *x = malloc(3 * sizeof(int));
    x[0] = 72;
    x[1] = 73;
    x[2] = 33;
    free(x);
}
```

# Garbage values

```C
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    int scores[3];
    for (int i = 0; i < 3; i++)
    {
        printf("%i\n", scores[i]);
    }
}
```

We declare an array, `scores`, but we didn’t initialize it with any values.

The values in the array are **garbage values**, or whatever unknown values that were in memory, from whatever program was running in our computer before.

# Swap

The `swap` function gets passed in copies of variables, `a` and `b`, which are **local variables** that only the surrounding function can access. Changing those values won’t change `x` and `y` in the main function:

```C
#include <stdio.h>

void swap(int a, int b);

int main(void)
{
    int x = 1;
    int y = 2;

    printf("x is %i, y is %i\n", x, y);
    swap(x, y);
    printf("x is %i, y is %i\n", x, y);
}

void swap(int a, int b)
{
    printf("a is %i, b is %i\n", a, b);
    int tmp = a;
    a = b;
    b = tmp;
    printf("a is %i, b is %i\n", a, b);
}
```

```
$ make swap
$ ./swap
x is 1, y is 2
a is 1, b is 2
a is 2, b is 1
x is 1, y is 2
```

# Memory layout

Within our computer’s memory, different types of data that need to be stored for our program are organized into different sections:

![Snipaste_2022-07-31_09-22-47.png](https://media.haochen.me/Snipaste_2022-07-31_09-22-47.png)

- The **machine code** section is our compiled program’s binary code. When we run our program, that code is loaded into memory.
- Just below, or in the next part of memory, are **global variables** we declared in our program.
- The **heap** section is an empty area from where `malloc` can get free memory for our program to use. As we call `malloc`, we start allocating memory from the top down.
- The **stack** section is used by functions and local variables in our program as they are called, and grows upwards.

If we call `malloc` for too much memory, we will have a **heap overflow**, since we end up going past our heap. Or, if we call too many functions without returning from them, we will have a **stack overflow**, where our stack has too much memory allocated as well.

Our program for swapping integers might have a stack that looks like this:

```
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     | tmp       |  |  |  |  |
swap -------------------------
     | a    1    | b    2    |
     -------------------------
main | x    1    | y    2    |
     -------------------------
```

- Our `main` function has two local variables, `x` and `y`. Our `swap` function is created on top of `main` when it’s called, and has three local variables, `a`, `b`, and `tmp`.
- Once `swap` returns, its memory is freed and its values are now garbage values, and the variables in `main` haven’t been changed.

By passing in the address of `x` and `y`, our `swap` function will be able to change the original values:

```C
#include <stdio.h>

void swap(int *a, int *b);

int main(void)
{
    int x = 1;
    int y = 2;

    printf("x is %i, y is %i\n", x, y);
    swap(&x, &y);
    printf("x is %i, y is %i\n", x, y);
}

void swap(int *a, int *b)
{
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
```

```
$ make swap
$ ./swap
x is 1, y is 2
x is 2, y is 1
```

The addresses of `x` and `y` are passed in from `main` to `swap` with `&x` and `&y`, and we use the `int *a` syntax to declare that our `swap` function takes in pointers.

Our stack might look like this:

```
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     |  |  |  |  |  |  |  |  |
     -------------------------
     | tmp  1     |  |  |  |  |
swap -------------------------
     | a  0x123  | b  0x127  |
     -------------------------
main | x    1    | y    2    |
     -------------------------
```

# scanf

We can get an integer from the user with a C library function, `scanf`:

```C
#include <stdio.h>

int main(void)
{
    int x;
    printf("x: ");
    scanf("%i", &x);
    printf("x: %i\n", x);
}
```

```
$ make scanf
$ ./scanf
x: 50
x: 50
```

`scanf` takes a format, `%i`, so the input is “scanned” for that format. We also pass in the address in memory where we want that input to go with `&x`.

We can try to get a string the same way:

```C
#include <stdio.h>

int main(void)
{
    char *s;
    printf("s: ");
    scanf("%s", s);
    printf("s: %s\n", s);
}
```

```
$ clang -o scanf scanf.c
$ ./scanf
s: HI!
s: (null)
```

We haven’t actually allocated any memory for `s`, so `scanf` is writing our string to an unknown address in memory.

We can call `malloc` to allocate memory:

```C
#include <stdio.h>

int main(void)
{
    char *s = malloc(4);
    printf("s: ");
    scanf("%s", s);
    printf("s: %s\n", s);
}
```

Now, if the user types in a string of length 3 or less, our program will work safely. But if the user types in a longer string, `scanf` might be trying to write past the end of our array into unknown memory, causing our program to crash.

`get_string` from the CS50 library continuously allocates more memory as `scanf` reads in more characters, so it doesn’t have this issue.
