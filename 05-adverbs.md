# Adverbs

Any respectable programming language will have its own forms of looping. You have already seen one form of looping in K's recursive functions
(`o`, function self reference). But even outside of recursion, you have seen K's looping through K's conforming operations, since they
move through each element of the arrays given to them.

Even with the power of recursion and branching, you will often find yourself in predicaments where these just 
do not fit the task.
K's general design lends itself strongly towards some aspects of functional programming, and many of its adverbs help omit
loops and branching to solve tasks concisely and quickly.

If you are acquainted with functional programming already, `'` is map, `'` (dyadic) is zip, `/` is foldl, and `\` is scanl.

Hence, you will most likely never need recursion and branching in most situations.

Each (`'`) is an adverb which takes a function or verb and applies the function on each element of an array. Yes, the symbol for each is a single quote.

### `f' x` Each

**Symbol:** `'`

**Args:** `function' array`

**Description:** Apply function to each element of array.

For example, to reverse an array, we can use the `|` verb:

```
 |'(1 2 3; 4 5 6)
(3 2 1
 6 5 4)
```



### `| x` Reverse

**Symbol:** `|`

**Args:** `| array`

**Description:** reverse the elements of an array.



and to reverse each row of a 2D array, we can do `|'`:

```
 a:3 3#!9
(0 1 2
 3 4 5
 6 7 8)
 |'a
(2 1 0
 5 4 3
 8 7 6)
```

Each can also be used dyadically, and this form is called eachboth:



### `x f' y` Each Dyad

**Symbol:** `'`

**Args:** `array/atom function' array/atom`

**Description:** Apply dyadic function to each element of both arrays. 



Each dyad zips two arrays together with a dyadic function, creating an array of the results. Both `x` and `y` must have the same length, unless either of them are atoms. When an atom is given, it is repeated to the length of the other argument (`5 f' 1 2 3` is the same as `5 5 5 f' 1 2 3`).

Each dyad and each are useful with functions that don't fully support conforming operations. For example, `!` (modulus) only penetrates to the atoms in its right argument, meaning `2 ! 3 4 5` will work, but `1 2 3 ! 3 4 5` will not. This is where `!'` comes in handy:

```
 1 2 3 ! 3 4 5
1 2 3!3 4 5         
 1 2 3 !' 3 4 5
0 0 2
 1 2 3 !' 5
0 1 2   
```

Each dyad will repeat atoms to the length of the other argument, but sometimes you need an array to behave like an atom. Say, something like this:

```
 1 2 3 !' (5 6; 5 6; 5 6) / not very ideal
(0 0
 1 0
 2 0)
```

One way to solve it is using a projection:
```
 ![;5 6]' 1 2 3
(0 0
 1 0
 2 0)
```

But the best way to do it is with eachleft(`\:`):

```
 1 2 3 !\: 5 6
(0 0
 1 0
 2 0)
```

Eachleft applies a dyadic function to each element in the left array and the entire right argument. 



### `x f\: y` Each Left

**Symbol:** `\:`

**Args:** `array/atom function\: array/atom`

**Description:** Apply dyadic function to each element of `x` and the whole of `y`. 

For example, in `(a; b; c) f\: d` , we will get  `(f[a;d]; f[b;d]; f[c;d])`.

The same applies for each right, which you can probably guess the symbol for (`/:`).

## Folds and Scans

Folds and scans are used to combine values from an array to produce one or many results.



### `x f/ y` Over (Fold from left)

**Symbol:** `/`

**Args:** `any dyad/ array`

**Description:** Fold array `y` from left with a dyadic function. `x` is optional. 



There are many, many useful applications of folds, some of which are:

Fold | Verb        | What it Does                       | Example
---- | ----------- | ---------------------------------- | ----------------
`+/` | Add         | Sum                                | `+/1 2 3` -> `6`
`*/` | Multiply    | Product                            | `*/3 4 5` -> `60`
`\|/`| Maximum     | Maximum                            | `\|/3 5 1` -> `5`, `\|/1 0 0` -> `1`
`&/` | Minimum     | Minimum                            | `&/3 5 1` -> `1`, `&/1 0 1 1` -> `0`
`,/` | Concatenate | Join all elements together (Raze)  | `,/(1 2 3; 4 5 6)` -> `1 2 3 4 5 6`

These folds can also be used with an initial element, providing a fallback value:

```
 0+/1 2 3
6
 0+/()
0
 1*/7 8 9
504
 1*/()
1
```

With an initial element, these are fine. But what should happen *without* one?

```
 +/()
0
 */()
1
 |/()
-9223372036854775807
 &/()
9223372036854775807
 ,/()
()
```

Sum and Product seem OK, but `|/` and `&/` have two meanings, since max and min mean different things for integers and booleans: the highest integer is what K returns by default, but the max and min booleans are 1 and 0. Hence, adding an initial element does the trick on booleans:

```
 0|/()
0
 1&/()
1
```



### `x f\ y` Scan (Scan from left)

**Symbol:** `\`

**Args:** `any dyad\ array`

**Description:** Fold array `y` from left with a dyadic function, producing intermediate results in an array. `x` is optional. 



Scan is the same as fold, *except* it will also give you the intermediate values of the fold. 


```
+\1 2 3 4 5       = 1 3 6 10 15
  1               = 1 
  1+2             = 3
    3+3           = 6
      6+4         = 10
       10+5       = 15
```

They are useful all by themselves, but they are also *very* useful for debugging fold functions and finding out what's going wrong midway.
```
 */7#1000
3875820019684212736

 *\7#1000
1000 1000000 1000000000 1000000000000 1000000000000000 1000000000000000000 3875820019684212736
```
In the above example, we can see that integer overflow resulted in an "incorrect" result.

Scans are often useful with boolean functions (i.e. `<`, `=`, `>`, `&`, `|`). For example, to "turn off" all `1`s that appear after the first `0`, we can use:
```
 &\1 1 1 0 0 1 1 1 0 1 0 1
1 1 1 0 0 0 0 0 0 0 0 0
```

Scans are also one of the main ways that K lets you access intermediate values from loops, making it widely useful. For example, to count or number runs of `1`s in some boolean input:
```
 {y+x*y}\1 1 1 0 0 1 1 1 0 1 0 1
1 2 3 0 0 1 2 3 0 1 0 1
```

*Fold* and *scan* both use the first argument as initial value, and the rest of the arguments as input arrays. Note that scans of empty inputs return the (empty) input unchanged.

```
 4+\1 2 3
5 7 10
 0+\()
()
 2*\7 8 9
14 112 1008
 1*\()
()
```

## Iterated Fold and Scan

Fold and Scan both have overloads for more than two arguments. We will
be looking at examples of iterated scan only, since fold returns the
last result of scan anyway.

### `f\[x;...y]` Iterated Scan

**Symbol:** `\`

**Args:** `n-ad\[int;...arrays]`

**Description:** The length of `arrays` and the argument count of `n-ad` must
be the same.
- Do the following steps `x` times:
- Take the last `x` elements of `arrays`, call this `last`
- Add the result of `f.last` to the end of `arrays`
- Return the first `x+1` elements of `arrays`.

A simple use of this is to construct the fibonacci sequence:
```
 +\[10;0;1]
0 1 1 2 3 5 8 13 21 34 55
```

There is another overload for this scan, where `x` is a list. In that case,
`x` is treated as an initial value of sorts, and the `arrays` are iterated
through. The first value is `f.(,x),arrays[;0]`, then `x` is set to that value.
The next iteration we use `arrays[;1]`, and so on.
You can see the difference with this example:

```
 {x+y*z}\[3; 1 2 3; 4 5 6;7 8 9]
(1 2 3
 4 5 6
 7 8 9
 29 42 57)
 {x+y*z}\[1 2 3; 4 5 6;7 8 9]
(29 30 31
 69 70 71
 123 124 125)
```

Similar to ordinary fold/scan, the iterated versions simplify stateful
computation. However, these overloads tend to be more niche in their use.

## Vocabulary from this lesson
- Adverb: A syntactic form which acts like a higher order function on both nouns and verbs.
- Each: Zap each element with function
- EachBoth: Zip elements of two arrays with a function
- Eachleft and Eachright: Zip each element in one argument with the whole other argument with a function.
- Fold: Condense an array into a single value using a function.
- Scan: fold but outputs intermediate values as an array.

## Exercises
1. `|` when used with a single argument, reverses an array. Instead, reverse an array with the usage of a single fold.
2. Write a function to sum each row of an array.
3. Convert an array of base-2 digits to a base-10 integer using a fold. `f/1 0 1` -> `5`.
4. Write a function to get the prefixes of an array using an adverb: `f 1 2 3` -> `(,1;1 2;1 2 3)`

