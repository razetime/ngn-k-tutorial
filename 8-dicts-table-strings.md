# Dictionaries, Tables, Strings and other Miscellaneous functions

Dictionaries and strings are not highly related, just that this chapter aims to show the rest of the verbs we have not covered in K, which happen to be mainly relating to dictionaries and strings. Think of it as a rapid-fire explanation of

## Dictionary Trivia
Dictionaries are an *ordered collection*. this means that many primitives which work on arrays work similarly on dictionaries. This includes:

- concat `,` (values in `y` overwrite values in `x`)
- reverse `|` (reverses key array and value array separately)
- map `'` (applies on values)
- first `*` (first value from key-value pair only)
- not `~`
- filter `#` and filter-out `_` (filter by value)
- where `&` (keys are repeated by values)
- grade up `<` and grade down `>` (sort keys by values)

Outside of these, the most complex of the dictionary functions is *group* (`=`), which group the indices of elements by their values.

For example, we can get the counts of the elements of an array:
```
 :a:="aaaabbbbbaaaacccc"
"abc"!(0 1 2 3 9 10 11 12;4 5 6 7 8;13 14 15 16)
 :b:#'a
"abc"!8 5 4 
```

But the result is still a dictionary. Luckily, we can separate the keys with `!`, and the values with `.`.
```
 !b
"abc"
 .b
8 5 4
```

### Tables

Tables are flipped dictionaries. A dictionary can be flipped with `+` if:
- All keys are symbols
- All values are of the same length

Tables are dictionaries which allow indexing of columns with symbols, and rows using integers.

```
 :a:+`a`b`c!3 3#!9
+`a`b`c!(0 1 2;3 4 5;6 7 8)
 a[1]
`a`b`c!1 4 7
 a[`a]
0 1 2
```

## String functions

`$` will cast any atomic value to a string. It also conforms to arrays and dictionaries:
```
 $(`symbol; 123; {x+y}; 1 2 3!4 5 6)
("symbol"
 "123"
 "{x+y}"
 1 2 3!(,"4";,"5";,"6"))
```

Dyadic `$` casts between different types:

```
 `i$"dsfdasfsd" / Character to Integer
100 115 102 100 97 115 102 115 100
```

Monadic `_` floors numbers and lowercases strings:
```
 _ (1.1;2.2;"ABC123") 
(1
 2
 "abc123")
```

Dyadic `$` is pad with spaces. Padding conforms to atoms on the left, and strings on the right. Positive integers pad on the right, and negative integers pad on the left.
```
  (3;4;(5;6))$("xy";"za";("bc";"cd"))
("xy "
 "za  "
 ("bc   "
  "cd    "))
```

### The Rest

**Random number functions**

Dyadic `?` when given two integers `x` and `y` generates `x` random integers from `!y`.

If `y` is an array, then it will deal `x` elements from it. Both of these allow repetitions.

Negative `x` will not allow repetition, and if the absolute value of `x` is greater than the length of `y`, then K will throw a length error.

Monadic `?` when given a single integer `x` will generate an array of random floats between 0 and 1 of length `x`,

---

Monadic `=` when given a single integer `x` will produce an identity matrix of side length `x`.
```
 =3
(1 0 0
 0 1 0
 0 0 1)
```

Monadic `.` when given a string is eval. This will evaluate any string as K code. Although eval is a convenient method to parse K-like strings, it is slow and dangerous. Use it sparingly.

```
 ."1+2"
3
```

Dyadic `:` is right. it returns its right argument. `:` has many special meanings , so it is better to call 
`:` with an M-Expression:

```
 :[1 2; 3 4]
3 4
```
