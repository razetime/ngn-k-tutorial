# Numbers and Logic

K does not like branching, but it likes logic very much. What this means is that you will be doing a lot of interesting things with integers in order to
avoid a branch.

The basic logical verbs of K are:
- `>` greater than
- `<` lesser than
- `=` equal to
- `~` exact match
- `~:` not
- `^` is null?
- `&` minimum / and
- `|` maximum / or

The other comparison related verbs outside of these are Grade Up (`<`) and Grade Down (`>`). These 
functions are the sorting functions of K.

Grade Up and Down both return the indices of the values of the array in their final locations. Some would say that they generate a *permutation vector*.
The function`{x@<x}` sorts an array in ascending order, for example. Effectively, `<` and `>` allows you to sort an array using any other array
as "weights", making it much more flexible.

All of the simple logical verbs, with the exception of *exact match* support conforming operations, and return `1` for true, and `0` for false. Since
booleans are also numbers in K, this lets us do some interesting things with them.

For example, let's say we want to increment all multiples of 2 in an array. Usually, one would check each number one at a time, and double it
if it were even.

To check if a number is even, we can use *mod* (`atom ! array`):

```
 {2!x}2 3 4
0 1 0
```

We can then negate this to put 1s at the spots where even numbers are:
```
 {~2!x}2 3 4
1 0 1
```

And then, add it to the array:
```
 {x+~2!x}2 3 4
3 3 5
```

An important function that works on boolean arrays is *where* (`&`). Where takes a list of integers and 
repeats their indices by their values:

```
 & 1 2 3
0 1 1 2 2 2
```

What makes `&` interesting is that it can also repeat an index 0 times, thereby discarding it.

`&` can be used to filter elements based on a condition, like `{y@&x'y}`, which keep elements in `y` that satisfy predicate `x`.

If you want the index of the first element that holds true under a condition, you can use `*&`. But a simpler and more efficient alternative is `?` (find).

### `x?y` Find

**Symbol:** `?`

**Args:** `array ? array`

**Description:** Index of each element of `x` in `y`. If not found, return `0N`.

`0N` is a null value, as described in *Arrays, Functions and Dictionaries*. A null value is generally used to 
signify the absence of a value, and generally denote a special value in a given type. The most usual place 
where null values are found are in indexing, where an out of bounds index returns a null value, and in find.

**Null Values for each data type**
| Type | Null |
| ---- | ---- |
|Integer | `0N` |
| Float | `0n` |
| Character | `" "` (Space) |
| Symbol | `` ` `` (no characters after backtick) |
| Function | `(::)` (identity function) |

`::` (monadic `:`) has been used in earlier chapters. It is used to force returns, and it always returns its argument without modification.

Sometimes, there is confusion between `0N` and `0n`, so you can use `@` (type) to distinguish between them:

```
 @'(0N; 0n; " "; `; ::)
`i`d`c`s`u
```

`i` for integer, `d` for double, `c` for character, `s` for symbol, `f` for function and so on. If given an 
array that is of a single type, these are capitalized. More info on ngn/k's types can be read about on the 
[K Wiki](https://k.miraheze.org/wiki/Type).

Since these null values are not very easy to keep track of in an array, there are two primitives that are made specifically for dealing with them:

- Null? (`^`) which tells you which atoms in an array are null values (1 for null, 0 for not null).
```
 ^(1;0N;" ")
0 1 1
```
- Fill (`^`) which substitutes an element in places where there are null values.
```
 "A"^(1;0N;" ")
(1
 "A"
 "A")
```

## Vocabulary from this lesson
- Grade Up/Down: A special type of sorting function that provides indices of the final sorted values in the array.
- Null Value: In K, every type has its own null value. Null values are placeholders, and all types of nulls can be detected with `^`.

## Exercises
1. Given an array `x` and a 'mask' array `y` consisting of zeroes and ones only, get the elements in `x` that are at the same positions
   as the ones in `y`. `f[2 7 89 92 -123;0 1 0 1 1]` -> `7 92 -123`.
2. Create a dictionary from an array where they keys are the types of the elements in the array, and the values are the elements of the array.
3. Create a function with two arguments `x` and `y`, which takes the sum of `x[y]` without nulls.
