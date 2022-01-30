# K tutorial part 1: Introduction and nomenclature

Welcome to K. K is an array-based programming language. Although this term may sound new to many programmers, K comes from a lineage of programming languages which date back to the 1960s.

K is inspired from APL, which has its roots in math notation. K is hence in turn, an APL-style programming language which gears math notation more strongly toward practical programming than APL does.

Array languages to this day are still relatively underused, since they are very unlike what people are taught as beginner programmers. There are a few languages which support array programming constructs, like Julia and Python using numpy, but there are few things which compare to the joy of thinking and using K fluently. K and the APL family of languages push the horizons of what a programming language should look like, and how it should be used. Using a tool that is designed for its job has its own profound benefits, and K proves that rule very well. If you are looking for a new way to look at programming and you want to have fun, look no further.

As said earlier, K is an APL-style array language which aims to eliminate many of APL's problems in programming. At a glance, the most noticeable improvements are:

- You can type K on an ordinary QWERTY keyboard with no extra software.
- K is built more toward programming than math, and hence simplifies the steep learning curve of APLs more math oriented sides.
- K adds and removes features on every iteration of its design. This lets it refine its design better than languages which are forced to maintain backward compatibility, like APL, or even Python.

Each one of K's *major* iterations is called a dialect. In this tutorial, we will be learning about ngn/k, an open source version of the K6 dialect. 

K takes some time and effort to learn, just like any language. Some parts of K will be hard to digest coming from a different language background, but with a little focused practice and this beautiful tutorial, I can assure you that you will be able to do great things with K.

To start with K, you have to first understand right to left evaluation. Take this simple math expression:

`2 * 2 + 3`

Generally, you would do `2 * 2` first, then add 3, which equals 7. However, K does not care about primary school rules like PEMDAS. K always read from right to left. Parentheses group things to make them execute first. So,

`2 * 2 + 3` = `2 * (2 + 3)` = 10.

If you want the result to be 7, then you have to use parentheses:

```
 (2 * 2) + 3

```

Where most languages have keywords, K has single characters. These characters are called primitives, and these primitives are the lifeblood of K. K has exactly 23 significant symbols that you can create programs with, called primitive verbs. Using these 23 primitive symbols and their many overloads, you can create any program you like.

The easiest way to run ngn/k is to go to the online interpreter, available at https://ngn.bitbucket.io/k/.

I recommend using the online interpreter's REPL available at https://ngn.bitbucket.io/k/#r until you get comfortable with K. If you like running things locally, then feel free to build the interpreter from source: https://codeberg.org/ngn/k/.

Let's start with a Hello World:
```
"Hello, World!"
```
                                                                                                                                                                                                                                                                                                                                                                                                                                 
K will automatically display the result of every line in your program as K data. This means that you can safely paste the result of a K expression into your program, and use it later.

To actually display a string without K's formatting, you can do this:
```
` 0:"Hello, World!"
```

In this program, <code>\` 0:</code> is the equivalent of a print statement in any other language. It will print a simple character array given to it with a newline at the end. You can change it to <code>\` 1:</code> if you want to display without a newline.

Reminder: K is right to left language. This means that it has no precendence rules other than executing everything from right to left. So, Hello World is read first, then 0:, then the backtick.

The other major part of our Hello world program is the character array, which brings us to the lego bricks of the array-based language: the arrays.

The things that you can put in an array are called Nouns. These can be:
- Numbers, which can be simple integers or floating point numbers.
- Characters, which are enclosed in double quotes
- Symbols, which are a series of alphanumeric or `.` characters preceded by a backtick, like `` `.symbol123``. Symbol names cannot start with a number.
- Other Arrays
- Functions and dictionaries, which we will discuss later. 

Verbs are primitive functions. K has 19 primitive verbs, each identified by a single character. When you put a primitive verb inside an array, it will automatically be converted to a noun. A verb can take one or two arguments, and can have multiple meanings based on what data the verb is given.

Adverbs are primitive higher order functions. Adverbs can take a verb on the left and create a new verb with modified functionality. Some adverbs also behave like verbs if they are not given a verb argument.

The default way of defining multi-element arrays is as follows:
```
(<noun1>; <noun2>; <noun3>)
```
You can also use a newline and a space instead of semicolons to separate array elements, so:
```
(<noun1>
 <noun2>
 <noun3>)
```
is also valid array syntax.

A single element array of any type can be defined with `enlist`, which is `,`.
```
,1
,"a"
,`symbol
```

It's important to understand that just `"a"` is a character, not a string. `,"a"`, however, is an array contraining the character `"a"`. I'd like to introduce you to your first K verb: enlist.

---

### `,x` Enlist

**Symbol:** `,`

**Args:** `, any_value`

**Description:** Create a single element array containing `x`.

---


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

Arrays of symbols are defined by simply listing the symbols together, with no spaces between them.
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
Numbers and only numbers separated by spaces will be considered as numeric arrays. This behaviour in K is called stranding.

One special thing about K's arrays is that some operations vectorize by default. Consider this:
```
1 2 3 + 4 5 6
```

gives `5 7 9`. This is also called a conforming operation. Conforming always "penetrates" to the deepest subarrays in an array(atoms), so these:
```
1 + 2 3 4 -> 3 4 5
1 2 3 4 + (1;2 3;4;(5;6 7)) -> (2;4 5;7;(9;10 11))
```

Are also valid K expressions. All basic arithmetic operators support conforming operations: 

| Verb      | What it does
| --------- | --------
| `+`       | Add
| `-`       | Subtract
| `*`       | Multiply
| `%`       | Divide

Some primitives in K conform only to one side. The ones that conform to the left are called left atomic, because they penetrate to the atoms of the left argument. The same goes for right atomic primitives.


Every verb in K can take 1 or two arguments of often varying types. For example, the above arithmetic primitives perform very different things whaen they are given one argument:

| Verb      | What it does
| --------- | --------
| `+`       | Flip (Transpose)
| `-`       | Negate
| `*`       | First (element of an array)
| `%`       | Square root

You can append a colon `:` after a verb to make sure that it executes with only one argument (monadic).


K has 32 primitive symbols, including digraphs(2 symbol combinations). Each of these symbols has type and arity(argument number) overloads, leading to over 70+ primitive verbs and adverbs for the K programmer to use. Every primitive has an important usecase, and remembering these is often hard for beginners. However, once you get the hang of them, you will have the tools to create any program you like. We will be covering the functionality of K's primitives and their basic usecases in this tutorial. 


## Vocabulary from this lesson

- Noun: any defined value.
- Verb: is a primitive function that can be used infix, and operates on nouns.
- Adverb: is a primitive higher order function that creates a new function from a given verb, or function noun.
- Atom: is any value that is not an array (symbol, character, integer, float).
- Monad(ic): Single argument function.
- Dyad(ic): Two argument function.
- Conforming: an operation that works on the atoms of its arguments.

## Exercises
- Guess the result of `1 2 3 + 4`, Then try it in the REPL.
- ngn/k has inbuilt documentation, available with `\` in the REPL. Try leafing through each help topic, and don't worry if you don't understand some things. The inbuilt documentation is the most complete and up-to-date cheatsheet on ngn/k, which will be very useful in the coming chapters.
- Define an array with one integer, one character and one symbol.