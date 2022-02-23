/ Interactive Sudoku Game
/ Made for the ngn/k tutorial.
/ By Razetime.

sg: (1 2 3 4 5 6 7 8 9  / a pre-solved grid.
     4 5 6 7 8 9 1 2 3
     7 8 9 1 2 3 4 5 6
     2 3 1 5 6 4 8 9 7
     5 6 4 8 9 7 2 3 1
     8 9 7 2 3 1 5 6 4
     3 1 2 6 4 5 9 7 8
     6 4 5 9 7 8 3 1 2
     9 7 8 3 1 2 6 4 5)

gen: { / generate a random sudoku board.
 / https://stackoverflow.com/a/61442050/4568534
 s1: (0,1+-9?9)@sg / shuffle the numbers around from the grid.
 s2: 2{+x@,/0 3 6+-3?'3#3}/s1 / shuffle rows in each 3x9 block, cols in each 9x3 block
 2{x@,/(!3)+/:3*-3?3}/s2} / shuffle 3x9 row blocks, 9x3 col blocks


disp: { / display a given 9x9 matrix as a sudoku board.
 s: ((" "/'$x),,17#"-")@{x,9,y}/0 3 6_!9
 s[;5 11]: "|"
 s .[;;:;"+"]/(3 5;7 5;3 11;7 11)}

aw: {x(,/{@[x;y;]'(!10)^x*|/p[;y]=p,:,3/:-3!p:!9 9}')/&~*x}
diff: { / sudoku board of given difficulty, given output of gen[]
 
 }
