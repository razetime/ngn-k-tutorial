/ Get the third column of the array `4 4#!16` using a projection. Then do it without a projection.
b:4 4#!16
b[;2]   / using projection
b[!4;2] / without projection

/ What happens when you project outside the domain of a noun? What are the differences in arrays, functions and dictionaries?
/
Interestingly enough, arrays do not complain, but dictionaries and functions generally will.
This is because when you do something like `(3 3#!9)[;3]` array automatically do 'outdexing' and return null.
Dictionaries and functions don't have that feature.
\

/ Write a function to add the first two elements of an array, but do it without indexing.
{(+).2#x} / remember that `.` takes a noun
((+).2#)  / bonus if you constructed a train
(.[+;]2#) / even better: using `.` and ` projection
