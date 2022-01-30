# Part 4: Adverbs and Looping

Any respectable programming language will have its own forms of looping. You have already seen one form of looping in K's recursive functions (`o`, function self reference). But even outside of recursion, you have seen K's looping through K's conforming operations, since they move through each element of the arrays given to them. 

Even with the power of recursion and conforming operations, you will often find yourself in predicaments where these just do not fit the task. This is where we go into K's looping Adverbs.

Each (`'`) is an adverb which takes a function or verb and applies the function on each element of an array. Yes, the symbol for each is a single quote.

---

### `f' x` Each

**Symbol:** `'`

**Args:** `function' array`

**Description:** Apply function to each element of array.

---


For example, to reverse an array, we can use the `|` verb:

```
|1 2 3
3 2 1
```

---

### `| x` Reverse

**Symbol:** `|`

**Args:** `| array`

**Description:** reverse the elements of an array.
---

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

---

### `x f' y` Each Dyad

**Symbol:** `'`

**Args:** `array/atom function' array/atom`

**Description:** Apply dyadic function to each element of both arrays. 

---

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

But the best way to do it is with eachleft('\:'):

```
 1 2 3 !\: 5 6
(0 0
 1 0
 2 0)
```

Eachleft applies a dyadic function to each element in the left array and the entire right argument. 

---

### `x f\: y` Each Left

**Symbol:** `\:`

**Args:** `array/atom function\: array/atom`

**Description:** Apply dyadic function to each element of `x` and the whole of `y`. 

---

The same applies for each right, which you can probably guess the symbol for (`/:`).
