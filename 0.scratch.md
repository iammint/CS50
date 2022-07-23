# What is computer science?
> Computer science is fundamentally problem solving. We can think of problem solving as the process of taking some input (a problem we want to solve) and generate some output (the solution to our problem). To begin doing that, we’ll need a way to represent inputs and outputs, so we can store and work with information in a standardized way.

# Representing numbers
We can represent numbers in a computer as a series of bits. We can think of a bit as a single unit of information. We can think of a byte as 8 bits. We can think of a word as a series of bytes. We can think of a number as a series of words.

![Snipaste_2022-07-23_10-03-54.png](https://media.haochen.me/Snipaste_2022-07-23_10-03-54.png)

Inside modern computers, there are billions of tiny switches called **transistors** that can be turned on and off to represent values.

# Text
> We represent letters by mapping numbers to letters. The standard mapping, **ASCII**, also includes lowercase letters and punctuation. Other characters, are part of a standard called Unicode, which uses more bits than ASCII to accommodate all these characters. 

With eight bits, or one byte, we can have 28, or 256 different values (including zero). (The highest value we can count up to would be 255.)


# Images, videos, and sounds

bits => bytes => numbers => color => pixels => image => video

With bits, we can map numbers to colors as well. There are many different systems to represent colors, but a common one is **RGB**, which represents colors by indicating the amount of red, green, and blue within each color.

> The dots, or squares, on our screens are called **pixels**, and images are made up of many thousands or millions of those pixels as well. So by using three bytes to represent the color for each pixel, we can create images.

> Videos are sequences of many images, changing multiple times a second to give us the appearance of motion, as a flipbook might.

> Music can be represented with bits, too. MIDI is one such format which represents music with numbers for each of the notes and their duration and volume.

# Algorithms
> Now that we can represent inputs and outputs, we can work on problem solving. The black box that transforms inputs to outputs contains algorithms, step-by-step instructions for solving problems.

Eg:

We need to find John Smith in the phone book which is alphabetized.

- **Algorithm1**: open the book and start from the first page, looking for a name one page at a time. 
    
    This algorithm would be correct, since we will eventually find the name if it’s in the book.

- **Algorithm2**: flip through the book two pages at a time, but this algorithm will not be correct since we might skip the page with our name on it.

- **Algorithm3**: open the phone book to the middle, decide whether our name will be in the left half or right half of the book, and reduce the size of our problem by half. We can repeat this until we find our name, dividing the problem in half each time.

We can visualize the efficiency of each of those algorithms with a chart. 

![Snipaste_2022-07-23_11-05-28.png](https://media.haochen.me/Snipaste_2022-07-23_11-05-28.png)

- Our first algorithm represented by the red line: our time to solve increases linearly as the size of the problem increases. n is a number representing the size of the problem, so with n pages in our phone books, we have to take up to n steps to find a name.
- The second algorithm represented by the yellow line: our slope is less steep, but still linear. Now, we only need (roughly) n / 2 steps, since we flip two pages at a time.
- Our final algorithm represented by the green line, with a fundamentally different relationship between the size of the problem and the time to solve it. If the phone book doubled in size from 1000 to 2000 pages, we would only need one more step to find our name.

# Pseudocode
> We can write **pseudocode**, which is a representation of our algorithm in precise human language. It is a way to write out the steps we need to take to solve a problem.

![Snipaste_2022-07-23_11-23-03_mh1658547555253.jpg](https://media.haochen.me/Snipaste_2022-07-23_11-23-03_mh1658547555253.jpg)


