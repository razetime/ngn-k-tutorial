# Part 5: Explicit Loops and Other Neat Adverbs

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

```
 {1_x}/1 2 3 4 / Drop the first element till the array no longer changes.
!0
```

---

### `g/ z` Converge

**Symbol:** `/`

**Args:** `monad/ any`

**Description:** Apply function `g` to `z` until `g[z]` matches `z`.

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

## The "other neat adverbs"
It would be quite blasphemous if I did not keep up on my promise from the chapter's title. The following adverbs don't take in functions, but they instead provide a very useful operation:

### Encode and Decode
Similar to their APL equivalents, encode and decode take a list of bases (or a single base) and peform base conversion on their argument.




## Multiple arguments

## Vocabulary from this chapter

## Exercises
1. *Converge* is a special case of while. Given a monadic function `g` and argument `z`, write `g/z` using a while.

