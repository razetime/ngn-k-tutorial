# Working with Arrays

You know how to make arrays by hand. Now, it is time let the program make them for you.

The most basic and universal array creation verb is *range* (`!`):


### `!x` Range

**Symbol:** `!`

**Args:** `! number`

**Description:** Array with numbers from 0 to `x-1`.

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


### `!x` Odometer

**Symbol:** `!`

**Args:** `! numeric_array`

**Description:** Generate an array where each column denotes an index into an array which has dimensions `x`,
in row-major order.


Odometer always generates an array of the length it is given, or in K's notation, `#x`.


### `#x` Length

**Symbol:** `#`

**Args:** `# array/atom`

**Description:** Length of the given array. Returns 1 for atoms.


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

Arrays are very flexible, first class values in K, and the more you buy into that concept,
the more fun you will have. 

- Concatenation (`x,y`) joins two arrays together, or appends an atomic value to a array.
- Take (`x#y`) takes elements from the beginning or the end of a array
- Drop (`x_y`) drops elements from the beginning or the end of a array
- Cut (`x_y`) cuts an array at the indices given.
- Delete (`x_y`) removes an element at a given index.
- Except (`x^y`) removes the elements of one array from another.
- Flip (`+x`) transposes a rectangular array.
- Distinct (`?x`) gets the unique elements of an array.

*Take* is a special case of Reshape where `x` is an atom, and `x` is lesser than the length of y (`#y`). It truncates the given array to length `x`. Negative `x` takes from the end.

*Drop* (`atom _ array`) does the same thing as take, except it removes `x` elements from the beginning or end.

*Cut* (`array _ array`) has some special behaviour: it ignores all elements till the first index in `x`, and then performs the cutting operation:

```
 0 4_"feedface"
("feed";"face")

 3 5_"adfdsfsdfa"
("ds"
 "fsdfa")
```

*Delete* is `array _ index` and it is quite self explanatory.

*Except* (`array ^ array`) works like multiset difference: it removes the elements of `y` from `x`.

*Flip* (`+ array`) will error on non-rectangular arrays. However, a simple list consisting only of atoms will be enlisted.
```
 +!4
,0 1 2 3
```


## Exercises
1. Convert `23 34 45 56` to `(,45; ,56)` using a single primitive.
2. Take the first five elements of `!9`, multiply them by 2, and put them back in the same place in !9.
3. Create the array `(6 8 10; 12 14 16)` using the primitives from this chapter.