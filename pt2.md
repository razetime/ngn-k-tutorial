# Part 2: Defining Variables

To define a variable, you type its name followed by a colon:

```
one: 1
```

Assigns the number 1 to the variable `one`. You can then use `one` anywhere you like. Yay! 

You can assign any noun to a variable. For example, a dictionary can be named with:

```
dict: `a`b`c ! 1 2 3
```

Creates a dictionary `dict` with key-value pairs `` `a:1; `b:2; `c:3``


---

### `x!y` Create Dict

**Symbol:** `!`

**Args:** `array ! array`

**Description:** Create a dict with keys `x` and values `y`. `x` and `y` must be of equal length.

---


You can get values from a dict using square brackets: ``dict[`a]`` will give you `1`.

You can also assign functions to variables. The default method of defining functions in K is to create a lambda. For example:

```
{x+y}[1;2]
```

Gives the result of `1+2`.

But where do `x` and `y` come from? Every K function has three default arguments: `x`, `y` and `z`, if the arguments are not defined beforehand. To name the arguments yourself, you can do:

```
{[firstnum;secondnum] firstnum+secondnum}[1;2]
```

which also does the same thing. If you'd like to document your code, named arguments can be quite useful, but K code is generally short enough to be understood with the default arguments.

Functions can have multiple statements separated by semicolons:

```
  {x+y; x-y}[1;2]
-1
```

A function will always return its last expression, unless specifically told to with the help of `:`. Any expression which starts with a `:` will be returned, and immediately exit from a function:
```
 {:x+y; x-y}[1;2]
3
```

A function can reference itself with the special variable `o`. A recursive factorial, for example, is
```
{$[x>1; x*o[x-1]; 1]}
```

So what does the `$` do? `$` is the K equivalent of an if statement. You *must* give `$` at last 3 arguments for a conditional.

`$[condition; true; false]` or `$[condition1; true1; condition2; true2; ...; false]`

---
### `$[;;..]` If

**Symbol:** `$`

**Arguments:** Any number 

**Description:** K's If statement.

---

To group multiple statements in an if-else, you can use a progn (lisp term), which is a bunch of statements inside square brackets:

```
 {$[1;[a:x+y;a];0]}[5;6]
11
```
A progn, similar to a function, will always return its last statement unless told otherwise with the help of `:`.




