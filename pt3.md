# Part 3: Arrays, Dictionaries and Functions

K is 0-indexed, which means arrays start at 0.

Indexing into an array takes the element at the given index and returns it.

Indexing into a dictionary takes the value that corresponds to a given key, and returns it.

Passing values to a function will return its corresponding result.

So why Arrays, dictionaries and functions together? Because they all do one single thing: They take a set of values, and return a single value. K hence treats them as the same thing: application.

The first method of application is called **at**. 

---

### `f@x` At

**Symbol:** `@`

**Args:** `(func/array/dict) @ (array/atom)`

**Description:** Applies a noun `f` given on its left to a single argument `x` given on its right.

---

For a function, `@` treats `x` like it is a single value, and provides it to `f`.

`- @ 1` gives `-1`.

For a dictionary or an array, `@` can take a single index:

``(`a`b`c!1 2 3) @ `a`` -> `1`
`67 78 89 @ 1` -> `78`

or an array of indices:
``(`a`b`c!1 2 3) @ `a`c`b`` -> `1 3 2`
`67 78 89 @ 0 2` -> `67 89`

all forms of application behave in this manner i.e. they will always index into atomic values and preserve the shape of the indices.

If you index outside of an array's length, you will get a null value corresponding to the type of the array:

`67 78 89 @ 56` -> `0N`

The second form of application is called the M-expression, which may be familiar to people coming from the Lisp language. The M-expression is the most general form of application, and it assumes the form of `noun[args]`.

for a function call, you can do `f[a;b;c]`. Remember that function calls include semicolons.

this means that `+[1;2]` is the same as `1+2`, and you can effectively translate most K programs to use M-expressions only.

For an array, each argument indexes into a different dimension:

taking an array  like the following:
```
 :a:3 3#!9
(0 1 2
 3 4 5
 6 7 8)
 ```
you can do `a[1;2]` to get 5, and `a[0;0]` to get 1.

Like with @, you can also use arrays to index into any dimension: `a[0 1;2]` will give you `2 5`.

The final form of application is dot (`.`).

---

### `f.x` Dot

**Symbol:** `.`

**Args:** `(func/array/dict) . (array)`

**Description:** Applies a noun `f` given on the arguments given in array `x`.

---

Dot application takes a noun on the left, and an array on the right. Each array element is taken as an argument.

`+ . 1 2` is the same as `1 + 2`.

from the previous example, `a[1;2]` can be rewritten as `a . 1 2`, and `a[0;0]` is `a . 0 0`.

## Projections

K lets you omit arguments in application. 

For functions, omitting arguments implies *partial application*:

`-[1]` or `-[;1]` is a function that does `1-x` given an `x`.

`-[;1]` is a function that does `x-1` given an x. Basically, Projections will fill in values that you have left empty. 

Projections are often used to pass in outside data to a functions, since variables in ngn/k are limited to being local only. 

For example, this snippet should return a function that adds `a` to its argument.

```
 f:{a:x;{a+x}}[1]
 a[1]
'value
 a[1]
```

here, `{a+x}` can't see the value of a, since `a` is outside of its block, and `a` is not global.

To fix this, we should instead pass `a` via projection:

```
 f:{a:x;{[x+y}[a]}[1]
 f[3]
4
```