/ Interactive Sudoku Game
/ Made for the ngn/k tutorial.
/ Adapted from many sources: Roger Hui, DiscoDoug.

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

/ Creating a Puzzle
gen: { / generate a random sudoku board.
       / https://stackoverflow.com/a/61442050/4568534
  s1: (0,1+-9?9)@sg            / shuffle the numbers around from the grid.
  s2: 2{+x@,/0 3 6+-3?'3#3}/s1 / shuffle rows in each 3x9 block, cols in each 9x3 block
  2{+x@,/(!3)+/:3*-3?3}/s2}     / shuffle 3x9 row blocks, 9x3 col blocks

/ Displaying a puzzle
fmt: { / format a given 9x9 matrix as a sudoku board.
 s: ((" "/'$x),,17#"-")@{x,9,y}/3 3#!9
 s[;5 11]:11#+2 4#"|||+"
 s}

/ Solving a puzzle (Roger Hui sudoku)
j:       (,/0 27 54+\:0 3 6)+\:,/0 9 18+\:0 1 2 / helper for c and r
r:       9#',:'(9*!9)+\:!9                      / row for each cell.
c:       ((!9)+\:9*!9)@9#,!9                    / col for each cell.
b:       j@(,/9#'!9)@j                          / block for each cell.
I:       r,''c,''b                              / all cells to check for each cell.
R:       j,((9*!9)+\:!9),(!9)+\:9*!9            / row, col, block indices.
in:      {~^y?x}                                / is x in y?

free:    {(0=x)>(1+!9)in/:/:(,/x)@I}
regions: {(,/x)@R}
eu:      {(in[x;!10])&(0=x)|{(!9)=x?x}'x}
ok:      {&/,/eu regions x}
s1u: {m:1=+/'r:regions@x          / (27x9 array) boolean array of values which
                                  /    are only free in one element of a group per group
      j:&|/'m                     / indices of groups which have at least one value which is free only once
      k:m[j]?\:1b                 / for such groups, the first value which is free only once
      i:,/(R@j)@'&:'(+:'r@j)@'k   / find the positions of the first element of each group
                                  /    which is only free once in that group
      9 9#@[&81;i;:;1+k]}         / make a matrix of these filled in
s1x:     {(+/''x*\:\:1+!9)*1=+/''x}
s1:      {x+(s1x b)|s1u b:free x}/'
s2a:     {$[~in[0;,/x]; :,x; ::]; b:free x; i:t?&/t:,/(10,1_!9)@+/''b
           d:1+&(,/b)@i; x+/:d*\:i=9 9#!81}
s2:      {,/s2a'x}
sudoku:  {{s2 (ok')#s1 x}/,x}

/ Generating a puzzle
nz:{b:,/x;9 9#@[b;y?81;:;0]}

gp:{{~1=#sudoku x}{z; nz[x;y]}[x;y]/9 9#9}

/ Playing the game:
`1:"Sudoku Puzzle\n"

zs:10/({~((10/x-"0")<65)&(&/x>"0"-1)& &/x<"9"+1}{`1:"Enter Difficulty (number of empty spaces): ";-1_1:`}/"65")-"0"

brd:gen[]
win:1
fin:{~x~brd}{
  `1:"Board:\n"
  `0:fmt x
  `1:"End Game? (y/n)"
  $["y\n"~1:0;[win::0;:brd];::]
  cd:{~0=x . y}[x]{`1:"Enter coordinates to place at: "; 10/'(" "\-1_1:0)-"0"}/0N 0N
  n:{^(1+!9)?x}{`1:"Enter number to place (1-9): ";10/(-1_1:0)-"0"}/10
  .[x;cd;:;n]}/gp[brd;zs];

`1:"Final Board:\n"
`0:fmt fin
`1:$[win;"You Win!\n";""]
`1:"Game Over\n"

/ Unit tests:
x0: (0 6 0  1 0 4  0 5 0
     0 0 8  3 0 5  6 0 0
     2 0 0  0 0 0  0 0 1
     8 0 0  4 0 7  0 0 6
     0 0 6  0 0 0  3 0 0
     7 0 0  9 0 1  0 0 4
     5 0 0  0 0 0  0 0 2
     0 0 7  2 0 6  9 0 0
     0 4 0  5 0 8  0 7 0)

x1: (0 3 0  0 0 0  0 7 0
     0 1 0  8 0 6  0 2 0
     0 0 9  1 7 5  4 0 0
     0 0 7  0 0 0  6 0 0
     2 0 0  4 0 9  0 0 3
     0 0 3  0 0 0  1 0 0
     0 0 1  5 4 8  2 0 0
     0 6 0  3 0 2  0 1 0
     0 5 0  0 0 0  0 4 0)

x2: (0 3 0  9 0 0  0 8 0
     0 0 6  2 0 3  7 9 0
     0 0 0  1 0 0  0 0 0
     0 2 0  3 0 0  0 7 0
     0 0 0  0 7 0  0 6 4
     1 0 0  0 0 0  0 0 0
     0 5 0  0 0 4  9 0 0
     0 7 2  0 0 0  0 0 0
     0 9 0  0 5 0  8 3 0)

x3: (3 0 4  6 0 0  0 0 0
     0 0 5  1 0 8  0 3 0
     8 0 0  0 0 0  1 2 4
     4 3 0  8 0 0  0 0 0
     0 0 0  0 7 0  0 0 0
     0 0 0  0 0 4  0 8 6
     5 9 6  0 0 0  0 0 1
     0 4 0  2 0 9  3 0 0
     0 0 0  0 0 1  8 0 9)

x4: (2 0 0  6 7 0  0 0 0
     0 0 6  0 0 0  2 0 1
     4 0 0  0 0 0  8 0 0
     5 0 0  0 0 9  3 0 0
     0 3 0  0 0 0  0 5 0
     0 0 2  8 0 0  0 0 7
     0 0 1  0 0 0  0 0 4
     7 0 8  0 0 0  6 0 0
     0 0 0  0 5 3  0 0 8)

x5: (8 0 3  9 0 0  0 0 0
     0 7 0  0 0 0  5 0 0
     0 0 0  0 2 8  0 9 0
     6 0 5  4 0 0  9 0 0
     0 0 0  0 0 0  0 0 0
     0 0 4  0 0 5  8 0 7
     0 6 0  1 5 0  0 0 0
     0 0 1  0 0 0  0 3 0
     0 0 0  0 0 3  4 0 9)

x6: (0 0 0  7 2 0  0 0 1
     5 0 0  0 8 1  0 7 0
     8 0 1  0 0 0  0 0 0
     0 0 0  0 0 0  4 8 5
     7 0 5  0 6 0  2 0 9
     3 9 4  0 0 0  0 0 0
     0 0 0  0 0 0  9 0 7
     0 5 0  2 3 0  0 0 4
     6 0 0  0 1 7  0 0 0)

x7: (2 0 0  0 0 0  0 0 0
     0 0 0  0 3 0  0 5 0
     4 5 0  0 9 6  7 0 0
     3 0 2  0 0 0  1 0 0
     0 0 0  3 0 7  0 0 0
     0 0 9  0 0 0  5 0 6
     0 0 1  6 5 0  0 2 7
     0 8 0  0 1 0  0 0 0
     0 0 0  0 0 0  0 0 8)

x8: (0 0 0  0 0 7  8 0 0
     0 6 3  0 0 0  9 0 0
     0 2 0  3 0 0  0 0 7
     4 0 0  7 0 8  0 6 0
     0 0 0  0 1 0  0 0 0
     0 1 0  9 0 4  0 0 3
     5 0 0  0 0 1  0 4 0
     0 0 6  0 0 0  5 2 0
     0 0 8  4 0 0  0 0 0)

x9: (8 0 0  0 0 0  7 0 9
     2 0 0  7 0 4  0 0 0 
     0 0 7  0 0 1  0 5 0 
     3 0 0  0 0 0  0 0 0
     7 0 0  2 1 6  0 0 4 
     0 0 0  0 0 0  0 0 6
     0 8 0  4 0 0  3 0 0 
     0 0 0  9 0 8  0 0 2
     4 0 5  0 0 0  0 0 7)

/ unit tests: must have exactly one correct solution each.
/ tst:sudoku'(x0;x1;x2;x3;x4;x5;x6;x7;x8;x9)

/ Hint for exercise #2:
/ A more efficient version, fewer razes (contributed): 
/ free: {x<{^x?1+!9}'x@I}
/ eu: {(~(0,10)'x)&(0=x)|{(!9)=x?x}'x}
/ s1u: {m:1=+/'r:(x)@R
/       j:&|/'m
/       k:m[j]?\:1b; 
/       i:,/(R@j)@'&:'(+:'r@j)@'k
/       @[&81;i;:;1+k]}
/ s1: {x+s1u b:free@x}/'
/ s2a: {$[&/x; :,x; ::]
/       b:free@,/x; i:t?&/t:,/(10,1_!9)@+/'b
/       d:1+&(b)@i; x+/:d*\:i=!81}
/ ok: {&/,/eu x@R}
/ sudoku: {9 9#/:{s2 t@&ok' t:s1 x}/,,/x}
