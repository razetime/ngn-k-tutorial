/ 1. Convert `23 34 45 56` to `(,45; ,56)` using a single primitive.
2 3_23 34 45 56 / Using cut `_`

/ 2. Take the first five elements of `!9`, multiply them by 2, and put them back in the same place in !9.
/ The required result is 0 2 4 6 8 5 6 7 8.
(2*5#!9),5_!9  / I assumed the most literal interpretation would lead to this.
(2*5#!9),-4#!9 / Also perfectly fine.  
((5#2),4#1)*!9 / This doesn't satisfy the "put them back in the same place" part, but it uses the primitives well. 

/ 3. Create the array `(6 8 10; 12 14 16)` using the primitives from this chapter. Try to find more than one way to do it.
/ Let us condense the easiest way to do this into many solutions.
2 3#6 8 10 12 14 16 / perfectly valid.
2 3#6+0 2 4 6 8 10  / take the 6 out
2 3#6+2*0 1 2 3 4 5 / factor the 2 out
2 3#6+2*!6          / make that a range
/ Finding patterns in K code is often very rewarding. In K, patterns that make your code shorter almost always makes it better.
