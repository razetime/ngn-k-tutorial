/ Interactive Sudoku Game
/ Made for the ngn/k tutorial.
/ By Razetime,

/ Helpers
in: {^y?x}

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

/ Roger Hui sudoku
j:       (,/0 27 54+\:0 3 6)+\:,/0 9 18+\:0 1 2 / helper for c and r
r:       9#',:'(9*!9)+\:!9                      / row for each cell.
c:       ((!9)+\:9*!9)@9#,!9                    / col for each cell.
b:       j@(,/9#'!9)@j                          / block for each cell.
I:       r,''c,''b                              / all cells to check for each cell.
R:       j,((9*!9)+\:!9),(!9)+\:9*!9            / row, col, block indices.
in:      {~^y?x}

free:    {(0=x)>(1+!9)in/:/:(,/x)@I}
regions: {(,/x)@R}
eu:      {(in[x;!10])&(0=x)|{(!9)=x?x}'x}
ok:      {&/,/eu regions x}
s1u:     {m:1=+/'(,/x)@R; j:&|/'m; k:m[j]?\:1b; i:,/(R@j)@'&:'(+:'(,/x)@R@j)@'k
           (9*!9)_@[81#0;i;:;1+k]}
s1x:     {(+/''x*\:\:1+!9)*1=+/''x}
s1:      {x+(s1x b)|s1u b:free x}/'
s2a:     {$[~in[0;,/x]; :,x; ::]; b:free x; i:t?&/t:,/(10,1_!9)@+/''b
           d:1+&(,/b)@i; x+/:d*\:i=(9*!9)_!81}
s2:      {,/s2a'x}
sudoku:  {{s2 t@&ok' t:s1 x}/,x}

x0: (0 6 0  1 0 4  0 5 0
     0 0 8  3 0 5  6 0 0
     2 0 0  0 0 0  0 0 1
     8 0 0  4 0 7  0 0 6
     0 0 6  0 0 0  3 0 0
     7 0 0  9 0 1  0 0 4
     5 0 0  0 0 0  0 0 2
     0 0 7  2 0 6  9 0 0
     0 4 0  5 0 8  0 7 0)
x9: (8 0 0  0 0 0  7 0 9
     2 0 0  7 0 4  0 0 0 
     0 0 7  0 0 1  0 5 0 
     3 0 0  0 0 0  0 0 0
     7 0 0  2 1 6  0 0 4 
     0 0 0  0 0 0  0 0 6
     0 8 0  4 0 0  3 0 0 
     0 0 0  9 0 8  0 0 2
     4 0 5  0 0 0  0 0 7)

sudoku x9


diff: { / sudoku board of given difficulty, given output of gen[]
 
 }
