/ 1. *Converge* (`g/ z`) is a special case of while. Implement your own converge function using a while.
f:{*{~~/x}{(y 1;x y 1)}[x]/(y;x y)}
f[%[;2];,2] / this should converge with your version as well 

/ 2. Implement a function that converts a number to a list of digits in a given base (use while/fixpoint).
{m:-1_1_{(_(*x)%2;2!*x)}\x,0;|m[;1]} / using fixpoint
/ with while, your condition should be to check if the number is 0.

/ as you can see, we tend to need accumulators and projections in K to make traditional loops work the way we want. Use named parameters liberally if that
/ is difficult for you, and don't hesitate to use globals if you think you need them. K provides a small and easy to remember set of features for good
/ reason.
