# Part 2: Functions and Defining Variables

To define a variable, you type its name followed by a colon:

```
one: 1
```

Assigns the number 1 to the variable `one`. You can then use `one` anywhere you like. Yay! 

To define multiple variables, you can put the variable names and their values in arrays:

```
 (one; two; three): 1 2 3
1 2 3
 one
```

If you have already defined a variable, you can then modify its value in the same way with the help of reassignment:
```
 one: 2
 one
2
```

Or modified assignment:
```
 one +: 3
 one
5 
```
Modified assignment happens when a verb is given before the `:` symbol. The above statement is the same as `one: one + 3`.

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
 plus:{x+y}
 plus[1;2]
3
```

creates a function `plus` and passes the arguments 1 and 2 to it.

Function call syntax applies to Verbs as well, so `+[1;2]` is perfectly valid K (and a better way to put this).

But where do `x` and `y` come from? Every K function has three default arguments: `x`, `y` and `z`, if the arguments are not defined beforehand. To name the arguments yourself, you can put them in square brackets:

```
{[firstnum;secondnum] firstnum+secondnum}[1;2]
```

which also does the same thing. If you'd like to document your code, named arguments can be quite useful, but K functions are generally short enough to be understood with the default arguments.

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

Here, `>` is greater than. `<` is lesser than, and `=` is equal to.

So what does the `$` do? `$` is the K equivalent of an if statement. You *must* give `$` at least 3 arguments for a conditional.

effectively, this translates to the following pseudocode:

```
function(int x) {
    if (x > 1) {
        return x * o(x - 1);
    } else {
        return 1;
    }
}
```


---
### `$[;;..]` If

**Symbol:** `$`

**Arguments:** Any number 

**Description:** K's If statement. `$[condition; true; false]` or `$[condition1; true1; condition2; true2; ...; false]`.

---

So what is truth, and what is a falsehood?

The following table lists *all* falsy values in K. The rest are truthy.

| Type             |  Falsy
| ---------------- |  -----
| Number           |  `0`
| Character        |  `"\0"`, `0x00`
| Symbol           |  `` ` `` (Empty symbol)
| Function         |  `(::)` 
| Array            |  `()`
| Dictionary       |  `()!()` (Empty dictionary)

To group multiple statements in an if-else, you can use a progn (lisp term), which is a bunch of statements inside square brackets:

```
 {$[1;[a:x+y;a];0]}[5;6]
11
```
A progn, similar to a function, will always return its last statement unless told otherwise with the help of `:`.

## Scoping

You can define variables *within* functions as well, and you can use them within the function only. This means that
```
{a:5; {a}[]}
```

will give you an error. Instead, you can define a global variable using `::`:
```
{a::5; {a}[]}
```

However, this means that the entire program will have access to variable `a`. Global variables are best kept to a minimum in K, and we will see more ways to write our programs without them.

## Trains

A *train* is a way of representing simple function composition.

There are some important things to remember when writing trains:
- A train is a list of verbs, and their left arguments if applicable.
- A verb with a `:` after it will only be called with one argument. Without the colon, it is always called with two arguments. This applies to all places where you use verbs, but is especially useful in trains.
- A verb which does not have a `:` after it *must* have a left argument specified i.e `(+-)` is not a valid train but `(1+-)` is, since `+` is given left argument `1` and `+:-` is, since `+` only takes a single argument.
- Every primitive in train must have its *arity* specified with the help of `:`.
- The arity of the last verb of a train determines its arity. eg: `(f g h)` translates to `{f[g[h[x;y]]]}`, and `(f g h:)` translates to `{f[g[h[x]]]}`.

Trains are a way of representing really simple functions, where a list of functions is applied to one or two values. For example, here is a function that displays the first `x` odd numbers:

```
odds:{1+2*!x}
```

What this is doing is:
a) Generating a range 0..x-1 - `!x`
b) multiplying it by 2 (conforming) - `2*`
c) adding 1 to it (conforming) - `1+`

to convert this to a train, we have to specify arities:
- `!` is called monadically: `!:`
- `*` is called dyadically: `2*`
- `+` is called dyadically: `1+`

So what we finally get is:

```
odds: 1+2*!:
```

## Vocabulary from this lesson
- Variable: a name that is assigned a value.
- Lambda: General curly brace syntax for defining a function.
- progn: A block of statements which returns the value of its last statement, unless specified otherwise with `:`.
- Global variable: A variable that is avaiable to the entire program, assigned with `::`.
- Dictionary: A noun that maps keys to values.
- Train: A sequence of composed verbs and their left arguments.

## Exercises
1. Define a lambda function that takes two numbers and subtracts 1 from them.
2. Define a train which has the same function as the one from Question 1.
3. Create a dictionary with keys 1,2,3 and values 4,5,6.