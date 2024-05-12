/ 1. Write a function to convert seconds into hours, minutes and seconds, using `\`.
bs:0 60 60\ / mixed base conversion.
            / Putting a 0 in the 'hours' slot preserves the hours value as is.

/ 2. Write a function that takes a list of numbers `x` and a number `y`. Group the numbers in `x` into a dictionary based on whether they are multiples
/   of `y`. `f[1 3 5 9;3]` -> `(0;1)!(1 5;3 9)`
dct:{x@=~y!x}

