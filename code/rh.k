// roger hui

/ free x applies to grid x and returns a 9 9 9 boolean array y 
/ such that  y . i,j,k  is 1 iff 1+k can be assigned to cell i,j 
/ of x.

/ rcs x computes a 27 9 matrix of the 27 regions of grid x.  
/ eu applies to a matrix of regions and returns a 1 for each 
/ valid element.  ok x is 1 iff x is a valid grid.

/ s1x and s1u apply to the free list for a grid.  s1x 
/ assigns numbers to cells that have only one candidate.  
/ s1u looks for a number which occurs exactly once in 
/ the candidates for a row or a column, and assigns that
/ to the cell for which it is a candidate.  s1 repeatedly 
/ applies s1x and s1u to one or more grids until there are 
/ no more changes.

/ s2a x applies to to grid x and returns one or more grids 
/ with cell i,j filled in with all possible candidates, 
/ for cell i,j that has the smallest set of candidates.  
/ s2 applies s2a to one or more grids and returns all the 
/ grids generated thereby.

/ sudoku x finds all solutions for grid x.

j:       (,/0 27 54+\:0 3 6)+\:,/0 9 18+\:0 1 2 / helper for c and r
r:       9#',:'(9*!9)+\:!9                      / row for each cell.
c:       ((!9)+\:9*!9)@9#,!9                    / col for each cell.
b:       j@(,/9#'!9)@j                          / block for each cell.
I:       r,''c,''b                              / all cells to check for each cell.
R:       j,((9*!9)+\:!9),(!9)+\:9*!9            / row, col, block indices.

free:    {(0=x)>(1+!9)in/:/:(,/x)@I}
regions: {(,/x)@R}
eu:      {(x in !10)&(0=x)|{(!9)=x?x}'x}
ok:      {&/,/eu regions x}
s1u:     {m:1=+/'(,/x)@R; j:&|/'m; k:m[j]?\:1b; i:,/(R@j)@'&:'(+:'(,/x)@R@j)@'k
           (9*!9)_@[81#0;i;:;1+k]}
s1x:     {(+/''x*\:\:1+!9)*1=+/''x}
s1:      {x+(s1x b)|s1u b:free x}/'
s2a:     {if[~0 in,/x; :,x]; b:free x; i:t?&/t:,/(10,1_!9)@+/''b
           d:1+&(,/b)@i; x+/:d*\:i=(9*!9)_!81}
s2:      {,/s2a'x}
sudoku:  {{s2 t@&ok' t:s1 x}/,x}

/ grid examples

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
\

Function sudoku in the appended script finds all solutions to a grid.

  x4
(2 0 0 6 7 0 0 0 0;0 0 6 0 0 0 2 0 1;4 0 0 0 0 0 8 0 0; ...

  .q.show x4
2 0 0 6 7 0 0 0 0
0 0 6 0 0 0 2 0 1
4 0 0 0 0 0 8 0 0
5 0 0 0 0 9 3 0 0
0 3 0 0 0 0 0 5 0
0 0 2 8 0 0 0 0 7
0 0 1 0 0 0 0 0 4
7 0 8 0 0 0 6 0 0
0 0 0 0 5 3 0 0 8

  \t t: sudoku x4   / 500 MHz Pentium 3
60
  # t
1
  .q.show t@0
2 8 3 6 7 1 9 4 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 6 7 4 1 9 3 8 2
8 3 4 2 6 7 1 5 9
1 9 2 8 3 5 4 6 7
3 2 1 7 8 6 5 9 4
7 5 8 9 2 4 6 1 3
6 4 9 1 5 3 7 2 8

  / knock out the 8 in the lower right corner of x4
  / there are 5 solutions 
  # t: sudoku .[x4;8 8;:;0]
5
  {.q.show x;1 " \n";}' t
2 8 3 6 7 1 4 9 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 4 7 2 1 9 3 6 8
8 3 9 4 6 7 1 5 2
1 6 2 8 3 5 9 4 7
3 9 1 7 8 6 5 2 4
7 5 8 9 2 4 6 1 3
6 2 4 1 5 3 7 8 9

2 8 3 6 7 1 4 9 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 6 7 2 1 9 3 4 8
8 3 9 4 6 7 1 5 2
1 4 2 8 3 5 9 6 7
3 9 1 7 8 6 5 2 4
7 5 8 9 2 4 6 1 3
6 2 4 1 5 3 7 8 9

2 8 3 6 7 1 9 4 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 4 7 2 1 9 3 6 8
8 3 9 4 6 7 1 5 2
1 6 2 8 3 5 4 9 7
3 9 1 7 8 6 5 2 4
7 5 8 9 2 4 6 1 3
6 2 4 1 5 3 7 8 9

2 8 3 6 7 1 9 4 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 6 7 4 1 9 3 2 8
8 3 4 2 6 7 1 5 9
1 9 2 8 3 5 4 6 7
3 2 1 7 8 6 5 9 4
7 5 8 9 2 4 6 1 3
6 4 9 1 5 3 7 8 2

2 8 3 6 7 1 9 4 5
9 7 6 5 4 8 2 3 1
4 1 5 3 9 2 8 7 6
5 6 7 4 1 9 3 8 2
8 3 4 2 6 7 1 5 9
1 9 2 8 3 5 4 6 7
3 2 1 7 8 6 5 9 4
7 5 8 9 2 4 6 1 3
6 4 9 1 5 3 7 2 8

(;;;;)

/ sudoku.k script ------------------------------------------

/
www.sudoku.com

A grid is a 9 9 matrix of cells of the integers from !10.  
A box is a 9-element subset of a grid, the ravel of one
of the 3 3 regions illustrated below. 
  +-----+-----+-----+
  |2 0 0|6 7 0|0 0 0|
  |0 0 6|0 0 0|2 0 1|
  |4 0 0|0 0 0|8 0 0|
  +-----+-----+-----+
  |5 0 0|0 0 9|3 0 0|
  |0 3 0|0 0 0|0 5 0|
  |0 0 2|8 0 0|0 0 7|
  +-----+-----+-----+
  |0 0 1|0 0 0|0 0 4|
  |7 0 8|0 0 0|6 0 0|
  |0 0 0|0 5 3|0 0 8|
  +-----+-----+-----+

A region is a row, column, or box.  The object of Sudoku is 
to fill the cells of a grid x while leaving unchanged the 
non-zero cells, so that each region has exactly 1+!9.

free x applies to grid x and returns a 9 9 9 boolean array y 
such that  y . i,j,k  is 1 iff 1+k can be assigned to cell i,j 
of x.

rcs x computes a 27 9 matrix of the 27 regions of grid x.  
eu applies to a matrix of regions and returns a 1 for each 
valid element.  ok x is 1 iff x is a valid grid.

s1x and s1u apply to the free list for a grid.  s1x 
assigns numbers to cells that have only one candidate.  
s1u looks for a number which occurs exactly once in 
the candidates for a row or a column, and assigns that
to the cell for which it is a candidate.  s1 repeatedly 
applies s1x and s1u to one or more grids until there are 
no more changes.

s2a x applies to to grid x and returns one or more grids 
with cell i,j filled in with all possible candidates, 
for cell i,j that has the smallest set of candidates.  
s2 applies s2a to one or more grids and returns all the 
grids generated thereby.

sudoku x finds all solutions for grid x.

j:       (,/0 27 54+\:0 3 6)+\:,/0 9 18+\:0 1 2 / helper for c and r
r:       9#',:'(9*!9)+\:!9                      / row for each cell.
c:       ((!9)+\:9*!9)@9#,!9                    / col for each cell.
b:       j@(,/9#'!9)@j                          / block for each cell.
I:       r,''c,''b                              / all cells to check for each cell.
R:       j,((9*!9)+\:!9),(!9)+\:9*!9            / row, col, block indices.
in:      {~^y?x}

free:    {(0=x)>(1+!9)in/:/:(,/x)@I}
regions: {(,/x)@R}
eu:      {(x in !10)&(0=x)|{(!9)=x?x}'x}
ok:      {&/,/eu regions x}
s1u:     {m:1=+/'(,/x)@R; j:&|/'m; k:m[j]?\:1b; i:,/(R@j)@'&:'(+:'(,/x)@R@j)@'k
           (9*!9)_@[81#0;i;:;1+k]}
s1x:     {(+/''x*\:\:1+!9)*1=+/''x}
s1:      {x+(s1x b)|s1u b:free x}/'
s2a:     {if[~0 in,/x; :,x]; b:free x; i:t?&/t:,/(10,1_!9)@+/''b
           d:1+&(,/b)@i; x+/:d*\:i=(9*!9)_!81}
s2:      {,/s2a'x}
sudoku:  {{s2 t@&ok' t:s1 x}/,x}

/ grid examples

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


-------
To unsubscribe, change your address, or temporarily deactivate your subscription, 
please go to http://v2.listbox.com/member/?listname=kdb@v2.listbox.com
