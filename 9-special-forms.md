# Special Forms

A special form is a kind of verb that can perform specialized operations like control flow and global 
modification.
Special forms are generally polyadic (more than 2 arguments).

You have already seen one special form: If (`$[;;..]`). We will be covering the rest of these special forms in this chapter.

## Amend (`@`)

### 3 Arguments (`@[x;y;z]`)

Given array `x`, indices `y` and monadic function `z`, Amend will apply `z` to the elements at indices `y`.

```
 @["ABC";1 2;_:]
"Abc"
```

### 4 Arguments (`@[x;y;z;u]`)

Same as 3 argument amend, but `z` is dyadic, and `u` is the second argument provided to `z`.
```
 @[2 3;0;+;4]
6 3
```

## Drill / Deep Amend (`.`)

### 3 Arguments (`.[x;y;z]`)

Similar to amend, `x` is an array, but `y` is a single multidimensional index, and `z` is a monadic function.

### 4 Arguments (`.[x;y;z;u]`)

Similar to 3 arguments, but with `z` dyadic, and `u` as the second argument.

## Try (`.[x;y;z]`)

An error handling mechanism.

`x` is a function, `y` is an array of arguments to `x`, and `z` is the function that is applied to the error message (see ch 11), if `x.y` fails. Otherwise returns `x.y`.

```
 .[+;1 2;"E:",]
3
 .[+;1,`2;"E:",]
"E:'limit\n"
```

## Splice (`?[x;y;z]`)

Splices an array `z` between the indices given in `y` in array `x`. A very useful string function.

```
 ?["abcd";1 3;"xyz"]
"axyzd"
```