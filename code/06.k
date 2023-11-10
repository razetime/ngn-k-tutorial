/ 1. Given an array `x` and a 'mask' array `y` consisting of zeroes and ones only, get the elements in `x` that are at the same positions
/    as the ones in `y`. `f[2 7 89 92 -123;0 1 0 1 1]` -> `7 92 -123`.
{x@&y} / If you need some simple filtering, `&` (where) is perfect.

/ 2. Create a dictionary from an array where the keys are the types of the elements in the array, and the values are the elements of the array.
{(@'x)!x} / `@` is not atomic

/ 3. Create a function with two arguments `x` and `y`, which takes the sum of `x[y]` without nulls.
{+/0^x[y]} / using fill
{t:x[y];+/t@&~^t} / using where (filters out all the nulls)

