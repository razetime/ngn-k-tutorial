# Part 4: Looping and Conforming

Any respectable programming language will have its own forms of looping. You have already seen one form of looping in K's recursive functions (`o`, function self reference). But even outside of recursion, you have seen K's looping through K's conforming operations, since they move through each element of the arrays given to them. 

Even with the power of recursion and conforming operations, you will often find yourself in predicaments where these just do not fit the task. This is where we go into K's looping Adverbs.

## Each (map)

Each (`'`) is an adverb which takes a function or verb and applies the function on each element of an array. Yes, the symbol for each is a single quote.

---

### `f' x`

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

### `x f' y`

**Symbol:** `'`

**Args:** `array function' array`

**Description:** Apply dyadic function to each element of both arrays.

---

It is the equivalent of zipping two arrays together, creating an array fo the results.

