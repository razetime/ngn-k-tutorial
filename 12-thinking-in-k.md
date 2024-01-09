# Thinking in an array language

*You can view the full source code for this chapter at [GitHub](code/matmul.k).*

Since you are now properly acquainted with K, let's do some programming.
Most K programming happens through the REPL, because it is very useful to iterate upon previous code. ngn/k with rlwrap has history with the up/down arrow keys, and that should be more than enough to begin developing bigger programs in K. Functions are tested in the REPL, and then moved to actual code. Note that ngn/k's prettyprinting always returns valid k data, and you can precompute some things beforehand to speed up your program.

A K script is always executed like it was typed in the repl, that is: Each line is executed, and its return value is printed *unless* it ends with a semicolon. A script also allows multiline definitions, which are convenient for readability. Oftentimes, you may save your work in a script, and want to use it in a repl. In order to use your stored data and functions, just do `\l file.k` in the repl, and your file will be executed, and its data will be loaded. You can load a file into the REPL more than once, overwriting older data. The repl help accessed with `\` lists more useful commands as well.

K programming (and array programming in general), is a continuous process of simplifying your patterns. A big, unwieldy pattern has one or more ways to condense to a smaller, more declarative, easy to read pattern. This is discussed in a lot of detail in [Patterns and Anti-patterns in APL: Escaping the Beginner's Plateau - Aaron Hsu - Dyalog '17](https://www.youtube.com/watch?v=9xCJ3BCIudI), if you'd like to understand it better.

A common problem most people have in K is the need to translate a common, well known algorithm to K, usually taken from a programming website like geeksforgeeks, or a Wikipedia article. Let us take an example: Matrix Multiplication.

From [this wikipedia article](https://en.wikipedia.org/wiki/Matrix_multiplication_algorithm), the iterative algorithm for matrix multiplication is as follows: 
```
Input: matrices A and B
Let C be a new matrix of the appropriate size
For i from 1 to n:
  For j from 1 to p:
    Let sum = 0
    For k from 1 to m:
      Set sum ← sum + Aik × Bkj
  Set Cij ← sum
Return C
```

If you want, you can try translating this to K. A direct translation would be:
```
matmul: {
  A::x
  B::y
  n::#A
  m::#*A
  p::#*B
  C::(n;p)#0
  i::0
  j::0
  k::0
  sum::0
  {
    i::x
    {
      j::x
      sum::0
      {
        k::x
        sum::sum+A[i;k]*B[k;j] 
      }'!m
      C[i;j]::sum
    }'!p
  }'!n
  C}
```
This is the worst K code I've ever written, because we are trying to write K like an imperative language, and K doesn't work well with that design. The main problems are:

- Many, many globals are assigned
- multiple nested loops
- lots of modification

Luckily, there are a lot of things we can simplify here, and we can address these problems one by one.

Let us begin at the innermost loop:
```
sum::0
{
  k::x
  sum::sum+A[i;k]*B[k;j] 
}'!m
C[i;j]::sum
```

The first and simplest fix we can make is summing using a fold (`/`).

```
C[i;j]::+/{
  k::x
  A[i;k]*B[k;j] 
}'!m
```

One global down, 9 more to go.

The next global we can remove is `C`. Since `'` (each) returns an array, C doesn't need to be modified. We can simply return the value of the nested loop.

```
  {
    i::x
    {
      j::x
      +/{
        k::x
        A[i;k]*B[k;j] }'!m }'!p }'!n}
```

Now, we have three loops with no modification, which makes our job much easier. The main variables to look at now are `i`, `j`, and `k`.

- `i` indexes each row of A.
- `j` indexes each column of B.
- `k` indexes each column of A and row of B.

Basically, `k` is responsible for pairing each row of A with each column of B, which are then multiplied. Hence, we can eliminate the middle man here, and directly match them without `k`. This also eliminates one loop, and removes the need for `m`.

```
{
  j::x
  +/A[i]*B[;j] }'!p }'!n}
```
Next, to remove `j`, we need to take each column of `B` and pair it with `A[i]`. To do this, we transpose `B` and pair each element with eachright (`/:`).

```
matmul: {
  A::x
  B::y
  n::#A
  i::0
  {
    i::x
      A[i]{+/x*y}/:+B}'!n }
```

In order to remove `i`, we do a similar thing: Use eachleft to pair each row of `A` with each column of `B`.

```
matmul: {
  A::x
  B::y
  A{+/x*y}/:\:+B }
```

We need no more globals!
```
matmul: {x{+/x*y}/:\:+y}
```

Now *that* is matrix multiplication in K. This is the most direct algorithmic conversion of matrix multiplication. Now we will look at ways to shorten it, and remove more loops.

`+` (transpose) is costly, and we can remove it. What we are currently doing is naive. Instead of multiplying each row of `x` with each column of `y`, we can conform each row of B to the whole of A, doing the same thing implicitly.

```
matmul: {x{+/x*y}\:y}
```

Now, we have a function which can be easily made tacit. With the rules from [Chapter 3](3-functions-and-variables.md#trains), we get our final result:

```
matmul: (+/*)\:
```
A matrix multiplication function you can be proud of. This process may seem like it has a lot of steps, but condensing code will become much easier and intuitive as you practice your skill in K.

Matrix multiplication is a simple procedure which works well with K's array support. We will be seeing more algorithms that don't play well with K, and how to handle them in future chapters.
