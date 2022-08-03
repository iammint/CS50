# Growing arrays

Let’s say we have an array of three numbers, that we want to add another number to. But in our computer’s memory, there might already be another value right after.

So we need to `malloc` other memory.

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void)
{
    int *list = malloc(3 * sizeof(int));
    list[0] = 1;
    list[1] = 2;
    list[2] = 3;
    // Time passes
    // Wanted to store four int
    // Allocate new array of size 4
    int *temp = malloc(4 * sizeof(int));
    if (temp == NULL)
    {
        free(list);
        return 1;
    }
    // copy all numbers from old array into new array
    for (int i = 0; i < 3; i++)
    {
        temp[i] = list[i];
    }
    // Added fourth number to new array
    temp[3] = 4;
    // Need to free old array first before copying
    free(list);
    // remember new array by copying temp to list
    list = temp;
    // print new array
    for (int i = 0; i < 4; i++)
    {
        printf("%i\n", list[i]);
    }
    // Still need to free the new list
    free(list);
    return 0;
}
// This way is dynamically allocating the array using not the stack but the heap. But it too, suffers from the slowness of having to copy all those values from one to the other.
```

```c
int list[3] = {1, 2, 3};
// This way is statically allocating an array, so to speak, by just hard coding the number 3.
```

The reason why we didn't have to free the `temp` is that `list` is assigned to be identical to what `temp` was pointing to. So when we free `list`, it will free `temp` as well.

# Re-allocate

> There is a better way to resize an array.
> If there's available memory for new int, `realloc` will just do that. It will just grow the array for you in the computer's memory.
> Otherwise, `realloc` will handle the trouble of moving that whole array from 1 chunk of memory to a new chunk of memory.
> So you don't need to `free(list)` any more.

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void)
{
    int *list = malloc(3 * sizeof(int));
    list[0] = 1;
    list[1] = 2;
    list[2] = 3;
    // Time passes
    // Wanted to store four int
    // ❗Resize old array to be size 4
    int *temp = realloc(list, 4 * sizeof(int));
    if (temp == NULL)
    {
        free(list);
        return 1;
    }
    // No need to copy all numbers from old array into new array
    // Added fourth number to new array
    temp[3] = 4;
    // No need to free old array before copying
    // remember new array by copying temp to list
    list = temp;
    // print new array
    for (int i = 0; i < 4; i++)
    {
        printf("%i\n", list[i]);
    }
    // Still need to free the new list
    free(list);
    return 0;
}
```

# Data Structures

The world will become really slow if we're just constantly wasting time moving things around in memory.

# Linked lists

With a **linked list**, we can store a list of values in different parts of memory:

![Snipaste_2022-08-02_17-27-21.png](https://media.haochen.me/Snipaste_2022-08-02_17-27-21.png)

This is different than an array since our values are no longer next to one another in memory. We can use whatever locations in memory that are free.

Every node has two things: value and pointer to the next node. For last node in the list, the pointer will be `NULL`.

With a linked list, we have the tradeoff of needing to allocate more memory for each value and pointer, in order to spend less time adding values.

- We can implement a node with a struct:

```c
// We start this struct with `typedef struct node` so that we can refer to a `struct node` inside our struct.
typedef struct node
{
    int number;
    struct node *next;
}
node;
```

We can build a linked list with a `node` struct.

```c
typedef struct node
{
    int number;
    struct node *next;
}
node;

// Remember an empty list, so we can use the null pointer:
node *list = NULL;

// To add a node, we'll first nee to allocate some memory:
node *n = malloc(sizeof(node));
// If there is no memory to use
if (n == NULL)
{
    return 1;
}
// If we were able to get memory back from `malloc`, then we'll set the value of `number`:
// (*n).number = 1;
n ->number = 1;
n ->next = NULL;
// Finally, our list needs to point to the node:
list = n;

```

![Snipaste_2022-08-02_17-57-50.png](https://media.haochen.me/Snipaste_2022-08-02_17-57-50.png)

# Growing linked lists

- To add to the list, we'll create new node the same way by allocating more memoy:

```c
n = malloc(sizeof(node));
// If there is no memory to use
if (n == NULL)
{
    // free the list
    free(list);
    return 1;
}
n ->number = 2;
n ->next = NULL;

```

`n` is a temporary variable we use to point to this new node:

![Snipaste_2022-08-02_18-22-29.png](https://media.haochen.me/Snipaste_2022-08-02_18-22-29.png)

And now we need to update the pointer in our first node to point to our new `n`, since we want to maintain a sorted list:

```c
list ->next = n
```

This follows the pointer `list`, and sets the `next` field to point to the same node as `n`, since `n` is also pointer:

![Snipaste_2022-08-02_18-25-02.png](https://media.haochen.me/Snipaste_2022-08-02_18-25-02.png)

- To add a third node, we’ll allocate more memory again:

```c
n = malloc(sizeof(node));
if (n == NULL)
{
    // free the second node first
    // Cuz if we free the first node, we'll lose the list, and we won't be able to access `list ->next`
    free(list ->next);
    free(list);
    return 1;
}
n->number = 3;
n->next = NULL;
list->next->next = n;
```

![Snipaste_2022-08-02_18-45-18.png](https://media.haochen.me/Snipaste_2022-08-02_18-45-18.png)

Even though we’re using more memory, and taking multiple steps to insert new nodes in this case (since we’re adding to the end of the list), we’re able to use small amounts of free space in memory, instead of having to look for a large chunk of contiguous memory.

Finally, we can print our list, and free it with a loop:

```c
for (node *tmp = list; tmp != NULL; tmp = tmp ->next)
{
    printf("%i\n", tmp->number);
}
```

- Finally, we can print our list, and free it with a loop:

```c
// Print numbers
for (node *tmp = list; tmp != NULL; tmp = tmp->next)
{
    printf("%i\n", tmp->number);
}

// Free list
while (list != NULL)
{
    node *tmp = list->next;
    free(list);
    list = tmp;
}
return 0;
```

We’ll use a loop to free our list, by using another `tmp` pointer to remember the next node before we free the current node. Then, `free(list)` will free the memory for the node that list points to. After we do that, we can set list to tmp, the next node. Our loop will repeat until list is `null`, when no more nodes are left.

# Time complexity of linked lists

With a linked list, we have running time of $O(n)$ for search, since we need to follow each node, once at a time. We won’t be able to use binary search, since we can’t calculate where all of our nodes are. Inserting a node into a sorted list will have running time of $O(n)$ as well, since we might need to insert our node at the end. But if we didn’t want to maintain a sorted list, the running time will be $O(1)$, since we can insert at the beginning with just one step.

The best case running times for insert and search both have $Ω(1)$, since we might get lucky and find our value immediately, or be able to insert at the beginning of our list for even a sorted list. The worst case running times for insert and search both have $O(n)$.

# Trees

Recall that with a sorted array, we can use binary search to find an element, starting at the middle (yellow), then the middle of either half (red), and finally left or right (green) as needed:

![Snipaste_2022-08-02_21-17-50.png](https://media.haochen.me/Snipaste_2022-08-02_21-17-50.png)

With an array, we can randomly access elements in $O(1)$ time, since we can use arithmetic to go to an element at any index.

A **tree** is another data structure where each node points to other nodes. We might have a tree where each node points to one to the left (with a smaller value) and one to the right (with a larger value):

![Snipaste_2022-08-02_21-19-41.png](https://media.haochen.me/Snipaste_2022-08-02_21-19-41.png)

- Notice that we now visualize this data structure in two dimensions (even though the nodes in memory can be at any location).
- Each node has not one but two pointers to other nodes. All the values to the left of a node are smaller, and all the values of nodes to the right are greater, which allows this to be used as a **binary search tree**.
- And like a linked list, we’ll want to keep a pointer to just the beginning of the list, but in this case we want to point to the **root**, or topmost node of the tree (the 4).
- To search for a number, we’ll start at the root node, and be able to recursively search the left or right subtree.
- The height of this tree is 3, or log2n, since each **parent** node has up to two children.

We can define a node with not one but two pointers:

```c
typedef struct node
{
    int number;
    struct node *left;
    struct node *right;
}
node;
```

## Build a tree

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct node
{
    int number;
    struct node *left;
    struct node *right;
} node;

void print_tree(node *root);
void free_tree(node *root);
int main(void)
{
    // Tree of size 0
    node *tree = NULL;

    // Add a number to list
    node *n = malloc(sizeof(node));
    if (n == NULL)
    {
        free(n);
        return 1;
    }

    n->number = 2;
    n->left = NULL;
    n->right = NULL;
    tree = n;

    // Add number to list
    n = malloc(sizeof(node));
    if (n == NULL)
    {
        free(n);
        return 1;
    }

    n->number = 1;
    n->left = NULL;
    n->right = NULL;
    tree->left = n;

    // Add number to list
    n = malloc(sizeof(node));
    if (n == NULL)
    {
        free(n);
        return 1;
    }

    n->number = 3;
    n->left = NULL;
    n->right = NULL;
    tree->right = n;
    print_tree(tree);
    free_tree(tree);
    return 0;
}
// The `print_tree` function will start at the root node, and recursively print the tree.
void print_tree(node *root)
{
    if (root == NULL)
    {
        return;
    }
    print_tree(root->left);
    printf("%i\n", root->number);
    print_tree(root->right);
}

void free_tree(node *root)
{
    if (root == NULL)
    {
        return;
    }
    free_tree(root->left);
    free_tree(root->right);
    free(root);
}
```

# Searching a binary tree

```c
#include <cs50.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
bool search(node *tree, int number)
{
    if (tree == NULL)
    {
        return false;
    }
    else if (number < tree->number)
    {
        return search(tree->left, number);
    }
    else if (number > tree->number)
    {
        return search(tree->right, number);
    }
    else
    {
        return true;
    }
}
```

## Time complexity of tree

With a balanced binary search tree, the running time for search and insert will be $O(logn)$. But if our tree isn't balanced, it can devolve into a linked list, with running time for search and insert of $O(n)$.

# More Data Structures

# Hash tables

A **hash table** is a data structure that allows us to associate keys with values. It looks like an array, where we can jump to each location by its index.

If we have multiple names with the same first letter, we can add them with a linked list:

![Snipaste_2022-08-03_09-48-31.png](https://media.haochen.me/Snipaste_2022-08-03_09-48-31.png)

```c
// We can describe each node in code with:
typedef struct node
{
    char word[LONGEST_WORD + 1];
    struct node *next;
}
node;
// And to create the hash table, we might write:
node *hash_table[NUMBER_OF_BUCKETS];
```

- To decide which bucket, or location in the array, that a value should be placed in, we use a **hash function**, which takes some input and produces an index, or location. In our example, the hash function just returns an index corresponding to the first letter of the name, such as “0” for “Albus” and “25” for “Zacharias”.
- We might start sorting a shuffled deck of cards by dividing them into four buckets, each labeled by suit, and then sort each of the suits.

It turns out that the worst case running time for searching a hash table is $O(n)$, since all of our values might be in the same bucket, and we have to traverse the linked list to find the value.

# Trie

> short for “retrieval”, a data structure that allows us to search for words in a dictionary.

For each word, the first letter will point to an array, where the next valid letter will point to another array, and so on, until we reach a boolean value indicating the end of a valid word, marked in green:

![Snipaste_2022-08-03_10-17-03.png](https://media.haochen.me/Snipaste_2022-08-03_10-17-03.png)

```c
typedef struct node
{
    bool is_word;
    struct node *children[SIZE_OF_ALPHABET];
}
node;
```

- Now, the height of our tree is the length of the longest word we want to store.
- And even if our data structure has lots of words, the maximum lookup time will be just the length of the word we’re looking for. This might be a fixed maximum, so we have a constant time, $O(1)$ , for searching and insertion.
