/ 1. Guess the result of `1 2 3 + 4`, Try it in the REPL. Then try `1 2 3 + 4 5`. What does K say, and why?
5 6 7 / answer
/ `1 2 3 + 4 5` will throw a `'length` error, as conforming operations on two arrays require equal length.

/ 2. ngn/k has inbuilt documentation, available with `\` in the REPL. Try leafing through each help topic, and don't worry if you don't
/ understand some things. The inbuilt documentation is the most complete and up-to-date cheatsheet on ngn/k, which will be very
/ useful in the coming chapters.
/ This question simply introduces you to the in-repl help. The help is designed to generally fit within one terminal screen, and provide
/ terse examples on how to use K primitives. This is very useful in a pinch if you forget overloads, or argument order of a K primitive.

/ 3. Define an array with one integer, one character and one symbol.
(1;"a";`sym) / One of hundreds of ways to do this.
