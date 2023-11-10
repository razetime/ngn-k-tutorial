# Dictionaries, Tables, Strings and other Miscellaneous functions

Dictionaries and strings are not highly related, just that this chapter aims to show the rest of the verbs we have not covered in K,
which happen to be mainly relating to dictionaries and strings. Think of it as a rapid-fire explanation of their quirks.

## Dictionary Trivia
Dictionaries are an *ordered collections*. This means that many primitives which work on arrays work similarly on dictionaries. This includes:

- concat `,` (values in `y` overwrite values in `x`)
- reverse `|` (reverses key array and value array separately)
- map `'` (applies on values)
- first `*` (first value from key-value pair only)
- not `~`
- at `@` preserves the structure of the dictionary when given as the second argument.
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

Some adverbs have useful string related overloads:

`x \ y` is split. Splits `y` on `x`. 
```
 " "\"string with spaces"
("string"
 "with"
 "spaces")
```

Naturally, `x / y` is join. Joins `y` on `x`.
```
 "|"/("string";"without";"spaces")
"string|without|spaces"
```

Note that these adverbs *only* work on strings and nothing else.

### The Rest

#### Random number functions

Dyadic `?` when given two integers `x` and `y` generates `x` random integers from `!y`. If `x` is negative, this will be a
random permutation.

If `y` is an array, then it will deal `x` elements from it. Both of these allow repetitions.

Negative `x` will not allow repetition, and if the absolute value of `x` is greater than the length of `y`, then K will throw a length error.

Monadic `?` when given a single integer `x` will generate an array of random floats between 0 and 1 of length `x`,

Finally, `0N?x` where `x` is an array will shuffle `x`. If `x` is a number, then `!x` is used.

#### Base Decode and Encode (`\` and `/`)

ngn/k's base conversion adverbs are generalized: this means that you can do mixed-radix conversion and other cool things.
These adverbs will be familiar to APL programmers. Remember that these are adverbs, and not verbs. Some things you do with them may not work exactly as
expected.

The simplest use, and the most often use for this, is conversion to and from base 2:

```
 2 \ 5
5
'rank
 
 ^

 2 / 5
2
```

Wait a moment: that isn't right. Both of these results are wrong, and one of them is an error!

**Print debugging and comments**
The reason for this is one of K's limitations: `\` and `/` are interpreted differently based on the whitespace before them, and hence, the space before them changes their meaning.

Hence` \ 5` is hence interpreted as "pretty print 5 to stdout, and return its value", and `/ 5` is interpreted as a K comment.

In order to fix this, just remove the space.

```
 2\5
1 0 1
 2/1 0 1
5
```

For mixed radix, we can try some time conversion: hours, minutes and seconds to seconds:

```
 24 60 60/2 46 40
10000
```

These adverbs also generalize to arrays, and can perform base conversion on multiple numbers:
```
 2\5 6 7
(1 1 1
 0 1 1
 1 0 1)
 2/(1 1 1;0 1 1;1 0 1)
5 6 7
```

#### Miscellaneous

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

Dyadic `:` is right. it returns its right argument. `:` has many special meanings, so it is required to call
`:` with an M-Expression:

```
 :[1 2; 3 4]
3 4
```

*no new vocabulary for this chapter.*

## Exercises
1. Write a function to convert seconds into hours, minutes and seconds, using `\`.
2. Write a function that takes a list of numbers `x` and a number `y`. Group the numbers in `x` into a dictionary based on whether they are multiples
  of `y`. `f[1 3 5 9;3]` -> `(0;1)!(1 5;3 9)`
