# Debugging and Errors

*much of this chapter was populated with [ngn](https://ngn.bitbucket.io)'s help.*

One thing that array languages used to be (and still are) notorious for are their terrible error messages.
APL, J and K4 try to work around this problem with their debugging tools, but the problem still remains that errors are not very descriptive.

K does not have complex debugging tools available, and it has the worst errors that I know from an array language.
This page will attempt to disambiguate all the possible errors that ngn/k can throw, and what can cause them.

A K error will generally have a) an error name and b) A message prefixed with a quote and b) a few lines pointing to the code where the error happened.
Errors will be disambiguated first on error name, then the situation it may appear in.


### `'parse`
A parse error means that the K interpreter has found malformed code. This is also called a syntax error.

**Examples:**
```
/ mismatched bracket: 
 ({
/ unclosed string:
 "fsdfsad
/ bad parameter lists:
 {[x;1]1}
/ bad hex literals:
 0xfgh
/ odd number of digits in hex:
 0x123
/ nonexistent io verbs:
 9:`
```

### `'rank`
A rank error occurs when a primitive is called with arguments it does not have
an overload for. This can be due to mismatched argument types, or a mismatched
number of arguments.

**Example:**
```
/ + takes only 1 or 2 args: 
 +[1;2;3;4]
```

### `'type`
When the type of a value is incompatible with a primitive, a type error is thrown.

**Examples:**
```
1+`a
!"a"
&`symbol
```

### `'domain`
A domain error occurs when the argument types for a primitive match, their lengths are correct,
but the values of the arguments are not supported (they are not in the right domain).

**Examples:**
```
(0;1 2)!3      / arrays cannot be keys
&-1            / cannot repeat by negaitve amount
1?-1           / negative range does not work
1 2_()         / empty array cannot be dropped from
-1 2_(1 2;3 4) / negative drop values do not work on a 2d array
```

### `'index`
An index error triggers when you assign outside the bound of an array.
This can be done by normal assignment, or with the help of *amend*.

**Example:**
```
a:1 2 3;a[-7]:0    / assigning to an index that does not exist
@[1 2 3;0 5;:;8 9] / amending an index that does not exist
```

### `'length`
A length error occurs when the lengths of two arguments do not conform to each other in an *each* (`'`) or a conforming operation.

**Example:** `1 2 3 + 1 2`

### `'value`
A value error occurs on variable names that are not declared yet.

**Example:** `a+5` will error if `a` ia not defined.

### `'nyi`
NYI means not yet implemented. It triggers on overloads which are in ngn/k's design, but are not implemented yet.
`'nyi` errors change from time to time, and if you do get one, you have to find a workaround for
the primitive you are trying to use.

### `'stack`
A stack overflow happens when a function recursively calls itself too much.

**Example:**
```
 {o}[]
{o}
 {o[]}[]
'stack
 {o[]}
    ^
 {o[]}
    ^
 {o[]}
    ^
 {o[]}
    ^
 ..
```

### `'io`
An IO error happens when there is a problem during the usage of an I/O verb. This can be:

- A file permissions problem
- file access problem
- problem with the path given to the verb

### `'compile`
ngn/k first compiles your code to bytecode. This indicates a problem in the bytecode compilation phase.

### `'limit`
All functions in ngn/k K have the following limits:

- 8 local variables (including parameters)
- max bytecode size per function - 256 bytes

If a function exceeds these limits, you will get this error. 

**Example:**

```
{[a;b;c;d;e;f;g;h;i]a} / i is the 9th variable
```

### `'eoleof`
Every K program must end with a trailing empty line. If you get this error often, you may want to ask your editor to insert one. Most popular editors have a way to do it.

### `'oom`
Out of memory. Your program seems to be gobbling up large amounts of memory.
This often happens in conditional iteration where values tend to get really big.

`oom` is a non recoverable error i.e. K will not point to the line where everything went wrong, so you'll need to check for the location yourself.


## Finding and throwing errors
Print debugging is the main method of debugging in K. The general method of printing (`` `0:``) is quite clunky in this regard, so instead you should use <code>&nbsp;\\</code> (trace, note the leading space),
which autoformats and prints the K value given to it, and then returns it. Trace is an adverb, and hence will be executed like an adverb, right to left.

You can also throw custom errors using `` `err``, which will throw an error with the name of the string given, along with the line the error was thrown on.
```
 `err@"FsdfsdfA"
'FsdfsdfA
 `err@"FsdfsdfA"
     ^
```

## Inspecting functions internal bytecode
All user defined functions in K are compiled to a bytecode. It can be inspected using `!`:

```
!{n:42; x+y+n+1}
("{n:42; x+y+n+1}"             / function code itself
 0x0268424a67694a214921502100  / bytecode
 0xff00020202000b0c090a070800  / bytecode metadata (which local variable to use, reference counting related instructions, etc)
 `x`y`n                        / list of local variables
 ::                            / constants used
 42
 1)
```

## Vocabulary from this chapter
none.

## Exercises
- Try getting a `'io` error on your machine.
- Now that you know how to debug your K functions, you may want to check out the previous exercises and figure out some of the questions you were not able to finish.
