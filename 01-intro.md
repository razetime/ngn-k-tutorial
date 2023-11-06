# Introduction

Welcome to K!

K is an array-oriented programming language. Although this term may sound new, K comes from a family of 
programming languages which date back to APL in the 1960s. You may already know a popular object-oriented 
language such as Python or Java, so why should you learn K?

Other languages may have array programming capabilities, such as Julia or Python+NumPy, but there are few 
things which compare to the joy of thinking and using K fluently. K and the APL family of languages push the 
horizons of what a programming language should look like, and how it should be used. Using a tool that is 
designed for its job has its own profound benefits, and K proves that rule very well. If you are looking for a 
new way to look at programming and you want to have fun, you are in the right place.

Part of K's design was to improve upon some of APL's issues. At a glance, the most noticeable improvements are:

- You can type K on an ordinary QWERTY keyboard with no extra software.
- K emphasizes general purpose programming more than mathematics, which simplifies the steep learning curve of 
APL's more math oriented sides.
- K adds and removes features on every iteration of its design. This lets it refine its design better than 
languages which are forced to maintain backward compatibility, like APL, or even Python.

Each one of K's major iterations is called a *dialect*. In this tutorial, we will learn about [ngn/k](https://codeberg.org/ngn/k), an open source version of the K6 dialect. 

K takes some time and effort to learn, just like any language. However, K is designed to be simple. Most of K's 
basic concepts can be finished in an afternoon. Some parts of K will be hard to digest coming from a different 
language background, but with a little focused practice and this beautiful tutorial, I can assure you that you 
will be able to do great things with K.

To start with K, first understand how it uses "right to left" evaluation instead of operator precedence rules. 
Take this simple math expression:

`2 * 2 + 3`

You might think to do `2 * 2` first, then add 3, which equals 7. However, K does not care about primary school 
rules like PEMDAS. K evaluates from right to left:

`2 * 2 + 3` = `2 * (2 + 3)` = 10.

If you want the result to be 7, then you can add parentheses:

```
 (2 * 2) + 3
```

...or you can reorder the operations so the multiplication is performed first:

```
3 + 2 * 2
```

The easiest way to run ngn/k is to go to the online interpreter, available at https://ngn.bitbucket.io/k/.

I recommend using the online interpreter's REPL available at https://ngn.bitbucket.io/k/#r until you get 
comfortable with K. If you like running things locally, then feel free to build the interpreter from source: 
https://codeberg.org/ngn/k/.

Let's start with a Hello World:
```
"Hello, World!"
```

K will automatically display the result of every line in your program as K data. This means that you can safely 
paste the result of a K expression into your program, and use it later.

To prevent K from repeating everything you say to it, you can add a semicolon to the end of your line. For 
example,

```
"Hello, World!";
```

will do absolutely nothing!

To actually display a string without K's formatting, you can do this:
```
/ an actual hello world program
` 0:"Hello, World!"
```

In this program, <code>\` 0:</code> is the equivalent of a print statement in any other language. It will print 
a simple character array given to it with a newline at the end. You can change it to <code>\` 1:</code> if you 
want to display without a newline.

The line starting with a `/` is a comment. You can also use comments inline.

Reminder: K's "operators" have no precedence. So the interpreter reads <code>"Hello World"</code> first, then 
<code>0:</code>, then the backtick.

The other major part of our Hello World program is the character array, which brings us to the lego bricks of 
the array-based language: the arrays.

The things that you can put in an array are called **Nouns**. These can be:
- Numbers, which can be simple integers or floating point numbers.
- Characters, which are enclosed in double quotes
- Symbols, which are a series of alphanumeric or `.` characters preceded by a backtick, like `` `.symbol123``. Symbol names cannot start with a number.
- Other Arrays
- Functions and dictionaries, which we will discuss later. 

**Verbs** are primitive functions, written with a single character. When you put a verb inside an array, K 
converts it to a noun. A verb can take one or two arguments, and can have multiple meanings based on what data 
the verb is given. Verbs are equivalent to operators in other languages.

**Adverbs** are primitive higher-order functions, written with one or two characters. An adverb takes one or two verbs on the left and produces a new verb with modified functionality. Some adverbs also behave like verbs if they are not given a verb argument. Adverbs bind first, and they are always evaluated first. Before verbs are executed from right to left, adverbs must be paired with their respective arguments.

The default way of defining multi-element arrays is as follows:
```
(noun1; noun2; noun3)
```
In scripts, you can also use a newline and a space instead of semicolons to separate array elements, so:
```
(noun1
 noun2
 noun3)
```
is also valid array syntax.

A single element array of any type can be defined with the verb `enlist`, which is `,`.
```
,1
,"a"
,`symbol
```

It's important to understand that just `"a"` is a character, not a string. `,"a"`, however, is an array contraining the character `"a"`. Now to officially introduce you to your first K verb: enlist.

### `,x` Enlist

**Symbol:** `,`

**Args:** `, any_value`

**Description:** Create an array containing `x`.


Strings/character arrays can be made by putting multiple characters in double quotes, as you saw in the Hello World example. A single character string cannot be made with double quotes, since a single character in quotes is considered a character, as shown earlier.

```
"Hello, world!"
"This is a K string"
```

You can escape a double quote inside a character array with a backlash. K supports C style escape sequences in its strings, and you can refer to this table for the basic escapes:

| Escape | Character 
| ------ | --------- 
| `\\`   | `\`
| `\n`   | newline
| `\"`   | `"`
| `\t`   | tab

Arrays of symbols are created by juxtaposing the symbols together, with no spaces between them.
```
`a`b`c
`symbol`list
```

A list of numbers separated by spaces is a numeric array. All of the following are numeric arrays:
```
45 56 67
420 69
1 2 3
```
Numbers (and **only** numbers) separated by spaces will be treated as numeric arrays. This behaviour in K is called *stranding*.

One special thing about K's arrays is that some operations vectorize by default. Consider this:
```
1 2 3 + 4 5 6
```

gives `5 7 9`. This is also called a *conforming* operation. Conforming "penetrates" to the deepest subarrays in an array(atoms), so these:
```
1 + 2 3 4 -> 3 4 5
1 2 3 4 + (1;2 3;4;(5;6 7)) -> (2;4 5;7;(9;10 11))
```

are also valid K expressions. All basic arithmetic operators support conforming operations: 

| Verb      | What it does
| --------- | --------
| `+`       | Add
| `-`       | Subtract
| `*`       | Multiply
| `%`       | Divide

Some primitives in K conform only to one side. The ones that conform to the left are called left atomic, because they penetrate to the atoms of the left argument. The same goes for right atomic primitives.


Every verb in K can take 1 or two arguments. K programmers often call the 2-argument verbs *dyadic* and 1-argument verbs *monadic*. For example, these same tokens do very different things when they are given one argument on their right side:

| Verb      | What it does
| --------- | --------
| `+`       | Flip (Transpose)
| `-`       | Negate
| `*`       | First element of an array
| `%`       | Square root

You can append a colon `:` after a verb to make sure that it executes with only one argument (monadic).


K has 22 primitive verbs and 6 primitive adverbs. They do different things depending on both the **type** and **number** of arguments given, leading to more than 70 unique functions the K programmer can use. Every primitive has an important usecase, and remembering these can be a challenge when you're starting out.

The overloads of each primitive verb are usually inter-related and are easy to understand. Once you get the hang of them, you will have the tools to create any program you like. We will cover the functionality of K's primitives, their overloads, and their basic usecases in this tutorial. 


## Vocabulary from this lesson

- Noun: Any defined value in K.
- Verb: A primitive function that can be used infix, and operates on nouns.
- Adverb: A primitive higher order function that creates a new function from a given verb, or function noun.
  Adverbs are part of K's syntax itself.
- Atom: Any value that is not an array (function, symbol, character, integer, float).
- Monad/Monadic Function: Single argument function.
- Dyad/Dyadic Function: Two argument function.
- Conforming Operation: An operation that works on the lowest level of nesting it can work with.
  Most of K's verbs perform conforming operations.

## Exercises
1. Guess the result of `1 2 3 + 4`, Try it in the REPL. Then try `1 2 3 + 4 5`. What does K say, and why?
2. ngn/k has inbuilt documentation, available with `\` in the REPL. Try leafing through each help topic, and don't worry if you don't understand some things.
   The inbuilt documentation is the most complete and up-to-date cheatsheet on ngn/k, which will be very useful in the coming chapters.
3. Define an array with one integer, one character and one symbol.
