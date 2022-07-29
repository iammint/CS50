# Big O

> Computer scientists tend to describe **running time** with **big O notation**.

![Snipaste_2022-07-28_19-19-02.png](https://media.haochen.me/Snipaste_2022-07-28_19-19-02.png)

If we zoomed out and changed the units on our axes, we would see the red and yellow lines end up very close together:

![Snipaste_2022-07-28_19-19-11.png](https://media.haochen.me/Snipaste_2022-07-28_19-19-11.png)

So we would describe them both as O(n) running time. And the green line takes O(logn) steps to complete. (The base of the logarithm, 2, is also removed since it's a constant factor.)

# Big Ω(Omega)/ big Θ(Theta)

|Big O|Big Ω|Big θ|
|:-:|:-:|:-:|
|Big O describes the upper bound of number of steps(In the worst case).|Big Ω describes the lower bound of number of steps for our algorithms(In the best case).|Big θ describes running times of algorithms if the upper bound and lower bound is the same.|


# Linear search, binary search
The lower bound is Ω(1).

If we have a list of sorted elements, then we can start in the middle and find our value more efficiently since we know we can go left or right, dividing the problem in half each time.

### Pseudocode
```c
If no doors
    Return false
If number behind doors[middle]
    Return true
Else if number < doors[middle]
    Search doors[0] through doors[middle - 1]
Else if number > doors[middle]
    Search doors [middle + 1] through doors[n - 1]
```

The upper bound for binary search is O(logn).
The lower bound is Ω(1).

- Even though binary search might be much faster than linear search, it requires our array to be sorted first. If we're planning to search our data many times, it might be worth taking the time to sort it first, so we can use binary search.

- Other resources we might consider beyond the time it takes to run some code include the time it takes to write the code, or the amount of memory required for our code.


# Searching with code
```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>

int main(void)
{
    string names[] = {"Bill", "Charlie", "Fred", "George", "Ginny", "Percy", "Ron"};

    for (int i = 0; i < 7; i++)
    {
        // if (names[i] == "Ron")
        // Will trow an error to compare strings with '=='
        if(strcmp(names[i], "Ron") == 0)
        {
            printf("Found\n");
            return 0;
        }
    }
    printf("Not found\n");
    return 1;
}
```

# Structs
In C that we can define our own data type, or data structure. It would be a better design for our program to have some array with a data type person that includes both their name and phone number, so we can just say `person people[];`.
```C
typedef struct
{
    string name;
    string number;
}
person;
// `person` at the end will be the name of this data structure.
```

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>

typedef struct
{
    string name;
    string number;
}
person;

int main(void)
{
    person people[2];

    people[0].name = "Carter";
    people[0].number = "+1-617-495-1000";

    people[1].name = "David";
    people[1].number = "+1-949-468-2750";

    for (int i = 0; i < 2; i++)
    {
        if(strcmp(people[i].name, "David") == 0)
        {
            printf("Found %s\n", people[i].number);
            return 0;
        }
    }
    printf("Not found\n");
    return 1;
}
```

We can also imagine that a struct can be used to store precise decimal values or large integer values, perhaps with arrays that we can use to store large numbers of digits.


# Sorting
> Selection sort, Bubble sort, Merge sort
> 
> Recursion

## 1. Selection sort
> $O(n^2)$   $Ω(n^2)$   $Θ(n^2)$
> 
> Because in the best case, where the list is already sorted, our selection sort algorithm will still look at all the numbers and repeat the loop, so it has a lower bound for running time of $Ω(n^2)$.

### Pseu docode
```C
For i from 0 to n–1
    Find smallest number between numbers[i] and numbers[n-1]
    Swap smallest number with numbers[i]
``` 

For this algorithm, we started with looking at all $n$ elements, then only $n-1$, then $n-2$, and so on:
- n + (n - 1) + (n - 2) +... +1
- n(n + 1)/2
- O(n^2)

## 2. Bubble sort
> $O(n^2)$   $Ω(n)$ 

## Pseudocode
```c
Repeat n-1 times
    For i from 0 to n–2
        If numbers[i] and numbers[i+1] out of order
            Swap them
    If no swaps
        Quit
```
- (n - 1)(n - 1)
- n^2 - 2n + 1
- O(n^2)


## 3. Recursion
> **Recursion** is the ability for a function to call itself.

We used two for loops to get the following:
```
#
##
###
####
```
But notice that a pyramid of height 4 is actually a pyramid of height 3 with an extra row of 4 blocks added on. And a pyramid of height 3 is a pyramid of height 2 with an extra row of 3 blocks. A pyramid of height 2 is a pyramid of height 1 with an extra row of 2 blocks. And finally, a pyramid of height 1 is a pyramid of height 0 (no blocks) with a row of 1 block added.

Since a pyramid is a recursive structure, we can write a recursive function to draw a pyramid, a function that calls itself to draw a smaller pyramid before adding another row:

```C
#include <cs50.h>
#include <stdio.h>

void draw(int n);
int main(void)
{
    int height = get_int("Height: ");
    draw(height);
}

void draw(int n)
{
    if (n <= 0)
    {
        return;
    }
    draw(n - 1);
    for (int i = 0; i < n; i++)
    {
        printf("#");
    }
    printf("\n");
}
```

- If n is 0(or negative somehow) we'll stop without printing anything. And we need to make sure we stop for some **base case**, so our function doesn't go on forever. So there are base case and recursive case.

- Otherwise, we'll call `draw` agian, to print a pyramid of height n-1.

- Then, we'll print the row of blocks we need of our pyramid of height n.


We can change our conditional to **if (n == 0)**, and type in a negative number to see what happens:

```
$ make recursion
$ ./recursion
Height: -100
Segmentation fault (core dumped)
```

A segmentation fault means that we’ve touched memory in our computer that we shouldn’t have, and this happened since our function has called itself over and over so many times and ended up using too much memory.

### Recursion and non-recursion

In general, **but not always**, recursive functions replace loops in non-recursive functions.

```C
// Recursive function
int fact(int n)
{
    if (n === 1)
        return 1;
    else 
        return n * fact(n - 1);
}
```

```C
// Non-recursive function
int fact(int n)
{
    int product = 1;
    while(n > 0)
    {
        product *= n;
        n--;
    }
    return product;
}
```

- Multiple base cases:
  - eg: The Fibonacci number sequence 
- Multiple recursive cases:
  - The Collatz conjecture


### Practice

Write a recursive function `collatz(n)` that calculates how many steps it takes to get to 1 if you start from n and recurse as indicated above.

```C
#include <cs50.h>
#include <stdio.h>
#include <string.h>
// Write a recursive function `collatz(n)` that calculates how many steps it takes to get to 1
// if you start from n and recurse as indicated above.
// if n is odd, 3*n + 1; if n is even, n / 2
int collatz(int n);

int main(void)
{
    int arg = get_int("n: ");
    printf("%i\n", collatz(arg));
}
int collatz(int n)
{
    if (n == 1)
        return 0;

    else if ((n % 2) == 0)
        return 1 + collatz(n / 2);
    else
        n = 1 + collatz(3 * n + 1);
}
```

## 4. Merge sort
> $O(n log n)$   $Ω(n log n)$   $Θ(n log n)$

We can take the idea of recusion to sorting, with another algorithm called merge sort. The pseudocode might look like:

```C
If only one number
  Quit
Else
    Sort left half of number
    Sort right half of number
    Merge sorted halves
```

5 2 7 4 | 1 6 3 0
```
2 5
4 7
2 5 | 4 7
2 4 5 7
```

```
1 6
0 3
1 6 | 0 3
0 1 3 6
```

```
2 4 5 7 | 0 1 3 6
// To compare each first
0 1 2 3 4 5 6 7
```

Every time we merged two halves, we only needed to look at each each number once. And we divided our list of 8 numbers three times, or $logn$ times. We needed more memory to merge our new lists into, but the upper bound for running time for merge sort is only $O(nlogn)$. Since $logn$ is less than $n$, $O(nlogn)$ is less than $O(n^2)$.

The lower bound of our merge sort is still $Ω(n log n)$, since we have to do all the work even if the list is sorted. So merge sort also has $Ω(n log n)$.

[See Visualization!](https://www.youtube.com/watch?v=ZZuD6iUe3Pc)

# Time complexity of three sorting
|Sort Method|Selection Sort|Bubble Sort|Merge Sort|
|:-:|:-:|:-:|:-:|
|Worst case|$O((n^2+n)/2)$|$O(n^2-2n+1)$|$O(nlogn)$|
|Best case|$Ω((n^2+n)/2)$|$Ω(n)$|$θ(nlogn)$|


|Situation|Time Complexity|
|:-:|:-:|
|Worst case|Merge Sort < Selection sort < Bubble sort|
|Best case|Bubble sort < Merge Sort < Selection sort|
