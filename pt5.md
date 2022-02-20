# Part 5: More Looping adverbs

Most of the time, you can manage to write good K programs with neat little eaches and folds and scans. But *some* algorithms choose not to use arrays. Some algorithms insist on themselves, and that's why K has its own version of explicit loops from other languages:

When given a number `n` and a function on the left, `/` acts as a *for* loop:

```
 3 {1+x}/0
3
```

A for loop will apply a monadic function `n` times to a given value.

---

### `x f/ y` For

**Symbol:** `/`

**Args:** `int monad/ any`

**Description:** Apply function `f` `x` times to value `y`.

---


The same overload for `\` will produce the intermediate values of the *for*, like a scan:

```
 3 {1+x}\0
0 1 2 3
```

---

### `x f\ y` For (Scan)

**Symbol:** `\`

**Args:** `int monad\ any`

**Description:** Apply function `f` `x` times to value `y`. Collect intermediate values of `y` in an array.

---

When given two monadic functions on the left, `/` acts as a while:

```
 {x<5}{1+x}/0 # While x is less than 5, add 1 to x.
5
```

---

### `f g/ z` While

**Symbol:** `/`

**Args:** `monad monad/ any`

**Description:** Apply function `g` to `z` until `f[z]` is falsy. 

---

The truthy and falsy values for while are the same as it is for If(`$`). You can rehash on what they are by checking [Part 2](pt2.md#-if).

While-scan is quite self-explanatory (It provides the intermediate results of a while loop):
```
 {x<5}{1+x}\0
0 1 2 3 4 5
```



## Other looping adverbs

The following are some of the more specialized looping adverbs in K which don't exactly fit in the previous two categories.

Let's start with *converge*:

```
 {1_x}/1 2 3 4 / Drop the first element till the array no longer changes.
!0
```

Converge applies a verb to a value till the value no longer changes, and it's also called *fixpoint* due to that reason.

---

### `g/ z` Converge

**Symbol:** `/`

**Args:** `monad/ any`

**Description:** Apply function `g` to `z` until `g[z]` matches `z`.

---


---

### `x _ y` Drop

**Symbol:** `_`

**Args:** `integer _ array`

**Description:** Drop the first `x` elements of `y`. If `x` is negative, drop the last `x` elements.

---


*Converge-scan* is the scan(`\`) version of the same, and returns the intermediate results:

```
 {1_x}\1 2 3 4
(1 2 3 4
 2 3 4
 3 4
 ,4
 !0)
```

*eachprior* works like each, but instead applies a dyadic function to each element and the one before it, useful for many pairwise operations.

Since the first element of an array doesn't have anything before it, eachprior allows an optional left argument.

```
 45 ,':1 2 3 4
(1 45
 2 1
 3 2
 4 3)
 -':1 2 3 4 / deltas
1 1 1 1
 +':1 2 3 4
1 3 5 7
```

---

### `x f': y` Eachprior

**Symbol:** `':`

**Args:** `any dyad': array`

**Description:** for each element `b` in the array and the element `a` before it, calculate `f[b;a]`. If `x` is not provided, The first element is left unchanged.

---

Stencil is a more general version of what eachprior does:

```
  3_:':"ABcdE"
("abc"
 "bcd"
 "cde")
```

The main difference between stencil and eachprior is that stencil applies a function to each n-length chunk, instead of passing in elements as arguments.


---

### `x f': y` Stencil

**Symbol:** `':`

**Args:** `int monad': array`

**Description:** apply `f` to each overlapping `x`-length chunk in array `y`.

---

To simply get the chunks of the array, we can use the identity function `::`: `num ::': array`, but there is a more convenient adverb for it: `x ': array`, which is called *window*.


---

### `x ': y` Window

**Symbol:** `':`

**Args:** `int ': array`

**Description:** get each overlapping `x`-length chunk in array `y`.

---

It may be quite surprising at first that window does not take a function, but be not afraid. Window behaves like any other function, and can be stored as well.

Why isn't *window* a verb, if it doesn't take a function, then? A K interpreter has to make the distinction because it's an overload of an adverb symbol.

## More adverb overloads
Now that you have seen window, we can look at some more neat adverbs:

- *base encode* (`int(x) / int(y)`) converts a base-10 integer to an array of digits specified by the bases on the left. If `y` is an array, every number in `y` is encoded into a column.
- *base decode* (`int(x) \ int(y)`) is the inverse of base encode.
- *split* (`string(x) \ string(y)`) splits `y` on string `x`.
- *join* (`string(x) / array(y)`) joins array `y` on string `x`.
- *binary search* (`any(x) ' array(y)`) does a binary search for each element of `x` in `y`. If you do not know what a binary search is, I recommend reading [this article](https://www.khanacademy.org/computing/computer-science/algorithms/binary-search/a/binary-search).


These *can* be implemented using the help of K's primitives (and K's philosophy does support that), but having them as symbols is quite convenient, since they are very commonly used.

## Not Really Adverbs

Two important functional programming primitives: `#`(filter) and `_`(filter-out) are not adverbs, since they don't quite fit in the overloads, but they are still quite important in general code.

Generally, filtering in K is done with the help of `&`(find), which repeats the index of each element by the value of each element:

```
 &1 0 1 0 1
0 2 4
```

---

### `& x` Find

**Symbol:** `&`

**Args:** `& int_array`

**Description:** Repeat the index of each element in `x` by the value of each element in `x`.

---

this can be used in tandem with `@` to select values from an array:
```
 ("Raze"; "blah"; "ti"; "blah"; "me")@&1 0 1 0 1
("Raze"
 "ti"
 "me")
```

This can then be extended to use a condition on the array, keeping elements with length lesser than 5:

```
 {x@&(5>#:)'x}@("K"; "looong"; "is"; "blaah"; "cool")
("K"
 "is"
 "cool")
```

*Filter* and *filter-out* are shorthands for this type of filtering. They expect a monadic function (given as a noun), and apply it to the whole array.

Then, the rest is done the same way as it is with `&` and `@`. The previous example can be written as:

```
 ((5>#:)')#("K"; "looong"; "is"; "blaah"; "cool")
("K"
 "is"
 "cool")
```

Remember that filter and filter-out are verbs, and hence expect function values and not verbs. this means `~#x` will not work, but `(~:)#x` will.

## Vocabulary from this chapter
- Window: a continuous run of elements in an array.
- Binary Search: A search that can find the position an element should be inserted after in a sorted array.

## Exercises
1. *Converge* is a special case of while. Given a monadic function `g` and argument `z`, write `g/z` using a while.
2. Implement a function that converts a number to a list of digits in a given base (use while/fixpoint).

