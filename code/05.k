/ There are not many tricks to be found here, just functional programming patterns. Hence, these exercises do not have much explanation.

/ 1. `|` when used with a single argument, reverses an array. Instead, reverse an array with the usage of a single fold.
rev:{y,x}/ 

/ 2. Write a function to sum each row of an array.
sumrow:+/'

/ 3. Convert an array of base-2 digits to a base-10 integer using a fold. `f/1 0 1` -> `5`.
b2:{y+2*x}/

/ 4. Write a function to get the prefixes of an array using an adverb: `f 1 2 3` -> `(,1;1 2;1 2 3)
pr:,\

