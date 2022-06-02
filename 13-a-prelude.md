# Writing a Prelude
One of K's most important design constraints is the QWERTY keyboard: K keeps all the symbols,
and we get to have all the letters. Since we have all the letters, and K itself has few
symbols to work with, many people build their own K preludes, which contain things that they use
regularly. 

Apart from words, ngn/k allows unicode verbs, if you are into that:
```
(≠):~=
(≠:):   / Insert monadic ≠ here
```
The unicode symbols must always be put in parentheses, and you can omit either definition. 

Unicode verbs occupy the same class as primitive verbs i.e. thaey can be used infix in a K expression once they
are defined. However, the QWERTY keyboard is where we are working, and the QWERTY keyboard is where we will stay.

Now, we can begin on our Prelude. Go to your ngn/k folder (most people install at `$HOME/k`), 
open up a new K file `prepl.k`, and add the following line:
```
\l full/path/to/prelude.k (bash expansions like ~ do not work.)
\l full/path/to/repl.k
```
`\l` loads a K file, running the entire thing and importing its data. You have to start the REPL *after* you create
all your prelude functions, hence this is the order.

Then, we can create `prelude.k`. This prelude will cover some simple operations that work in a general manner,
taking inspiration from APL and BQN. Then, you can alter these functions, add and remove things from it as per your 
taste. I recommend having a stab at the functions presented here before you look at the possible approaches.

## Math
Absolute value makes a number positive. The easiest way is to make a conditional:
```
abs:{$[x>0;x;-x]}
```
We can remove the conditional with an array:
```
abs:((-x;x)@x>0)
```
This can be simplified further with a maximum:
```
abs:{x|-x}
```
Now, for a simple sign function. Luckily, we already have absolute value:
```
sgn:{x%abs x}
```
Ceiling is just floor + 1:
```
ceil:1+_
```
What we see here is that the name `ceil` is bigger than its definition. You can simply delete this, and remember `1+_` as ceil,
cause that removes the need for a word. 

In K, most of the time, it is better to 
a) reuse a sequence of symbols that are shorter than a name
b) Use short names for widely reused functions. Some people like to keep things within 1-2 characters max. You don't have to,
   but it's often useful to understand terse code when working with K, because you will be seeing a lot of it.

**Note:** Many sets of symbols are smaller than their names, but they can be difficult to remember. You can store these as a 
list of strings, and print them with a help function, say:

```
hstr: ("ceil 1+_"
       "not equal ~="
       "flatten ,//")
help: {`0:hstr}
```

You can then refer to your own personal snippet collection with `help[]`. A new website called 
[ngnkcart](https://secwang.github.io/ngnkcart) has been made for searching up common snippets, so it's easier to find and add
the ones that you need.

Not equal to is in the same category as ceil. `neq:(~=)` is quite redundant, so it's better to not have it.

We can use the Euclidean GCD algorithm, and LCM can be derived from GCD, so one of them comes for free.
```
gcd:{$[y>0;o[y;y!x];x]}
```
Every recursive algorithm can be converted to an algorithm using iteration. let's try that. A few things can be noted:
1. Iterate as long as y is not zero.
2. maintain y and y!x every iteration.

A simple way to get this with while would be:

```
gcd:{*({y>0}.)({y,y!x}.)/x,y}
```

Trigonometric functions can all be derived from `` `sin ``, which is a special symbol in ngn/k (see the help topic at ``\` ``).
 If `` `sin 0`` is giving you `0n`, then make sure that you reinstall ngn/k with `make k-libc`.

Using trigonometric identities, we can derive the following:
```
PI: 3.141592654
sin: `sin
cos: `sin (PI%2)- / sin(90-theta)
tan: {(sin x)%cos x}
```

Finally, the power function is quite simple:
```
pow:{*/y#x}`
```
But this function only handles power for positive integer `y`. In order to get a generalized power function, we need to use 
some math:
```
pow:{`exp y*`ln x}
```

## Strings
One thing that K and other array languages tend to struggle with are strings. A few commonly used string functions are given 
here.

To upper case can be implemented by subtracting 32 from any lowercase alphabet. So really, the first thing we need to be doing 
is finding out if a character is a lowercase alphabet or not. K allows character comparisons, so this is simple:
```
islwr:{(x>"a"-1)&x<"z"+1}
```
what's better is that this works directly on strings, since all its operations conform:
```
 islwr "ABCDabcd"
0 0 0 0 1 1 1 1 
```
If you find a function that needs to be applied to each element of an array, always check if you can make it conform without the
each. Now, the tolower function becomes much easier: just add 32 to each place with a 1.
```
tolwr:{x+32*islwr x}
```
but this yields a list of numbers:
```
 tolwr "UPPERcase123"
85 80 80 69 82 131 129 147 133 49 50 51
```
to remedy this, we need to just cast them back to characters:
```
tolwr:{`c$x+32*islwr x}
```

Basic string replacement can work using a simple split and join:
```
replace:{z/y\x}
```

## Array primitives

There's a lot of things you can do with arrays, and not all of them are convenient to type over and over, so this is a section
dedicated to primitives from other array languages, and some general ones.

K only has grades, so having some simple and convenient sorts makes more sense:
```
asc:{x@<x}
desc:{x@>x}
```

Index of is enough to find out if an element is in an array, but having a direct `in` function is more convenient.
```
in:{~^y?x}
```

Array rotation is a pretty common primitive that was even present in K3, where it used the `!` symbol. Here we define a version
with cut, but you can also find a version without splitting. Here, negative `x` rotates right, and positive rotates left.
```
rot:{,/|![#y;0,x]_y}
```

We can add our matrix multiplication from the previous chapter:
```
mmul: (+/*)\:
```

Now that we've made a nice prelude for ourselves, we can finally use it! 
```
rlwrap path/to/k prepl.k
```

## Exercises
1. What primitives would you remove from K, and which ones would you add in their place? 
   A fun thing to note about K is that even after 9 iterations, the official answer to this question
   hasn't been decided!
2. Make the `sec`, `cosec` and `cot` functions using your Prelude so far.
3. Create an `islower` function and a `tolower` function for your own.
4. Write a string replacement function using splice (`?`).