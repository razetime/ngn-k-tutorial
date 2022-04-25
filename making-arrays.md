# Working with Arrays

You know how to make arrays by hand. Now, it is time let the program make them for you.

The most basic and universal array creation verb is *range* (`!`):

---

### `!x` Range

**Symbol:** `!`

**Args:** `! number`

**Description:** Array with numbers from 0 to `x-1`.

---

Providing range with a single number gives an expected result:

```
 !5
0 1 2 3 4
 !3 3
(0 0 0 1 1 1 2 2 2
 0 1 2 0 1 2 0 1 2)
```

But what does that second result mean? `!` generalizes to arrays of numbers, and this is called odometer.
What this does is generate all indices to index into an array that has the dimensions described in `x`.
Each column denotes one element.

---

### `!x` Odometer

**Symbol:** `!`

**Args:** `! numeric array`

**Description:** Generate an array where each column denotes an index into an array which has dimensions `x`,
in row-major order.

---

Odometer always generates an array of the length it is given, or in K's notation, `#x`.

---

### `#x` Length

**Symbol:** `#`

**Args:** `# array/atom`

**Description:** Length of the given array. Returns 1 for atoms.

---

`#` when called dyadically is one of the most important verbs in K, called *reshape*.
Reshape lets you construct arrays with any number of dimensions:

```
 3 3 3#4
((4 4 4;4 4 4;4 4 4)
 (4 4 4;4 4 4;4 4 4)
 (4 4 4;4 4 4;4 4 4))
 3 3 2#!9
((0 1;2 3;4 5)
 (6 7;8 0;1 2)
 (3 4;5 6;7 8))
 3 3#4
(4 4 4
 4 4 4
 4 4 4)
```

When there are not enough elements to fill all dimensions, `#` will repeat the elements of `y` till it is filled.

You can also omit dimensions in reshape:
```
 3 0N#!9
(0 1 2
 3 4 5
 6 7 8)
```

Here, 0N (integer null) denotes the missing dimension. 
K will try to fit all elements of the array in the smallest shape possible using the rest of the
dimensions. You can only omit one dimension in reshape.

If we specify an atom `x` that is smaller than the length of the array,
reshape will take the first `x` elements of `y`.

```
 4#!9
0 1 2 3
```
Arrays are very flexible, first class values in K, and the more you buy into that concept,
the more fun you will have. 
