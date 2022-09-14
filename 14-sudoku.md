# A Sudoku program

Sudoku is great array task for K since it deals with small 2D arrays and it can be solved very nicely with array based methods.
In this chapter, we will make a fully featured Sudoku game in K.

If you do not know what Sudoku is, I suggest reading [these articles](http://pi.math.cornell.edu/~mec/Summer2009/Mahmood/Intro.html).

## Generating a random board
One way to generate a puzzle is placing random digits in valid locations. The array-oriented method which we will be using, 
is generating a puzzle from a solved board. Let's begin with a simple definition:

```
sg: (1 2 3 4 5 6 7 8 9  / a pre-solved grid.
     4 5 6 7 8 9 1 2 3
     7 8 9 1 2 3 4 5 6
     2 3 1 5 6 4 8 9 7
     5 6 4 8 9 7 2 3 1
     8 9 7 2 3 1 5 6 4
     3 1 2 6 4 5 9 7 8
     6 4 5 9 7 8 3 1 2
     9 7 8 3 1 2 6 4 5)
```

You can use any grid you want as long as it's a valid, completely solved sudoku grid. The algorithm for the board is as follows:
1. Switch the numbers in the grid around. Example: 1 becomes 9, 9 becomes 3, so on.
2. Shuffle the rows in each 3x9 block, and the columns in each 9x3 block.
3. Shuffle the 3x9 row blocks and the 9x3 column blocks.

Let us name this function `gen`.

Before doing any random number generation, we must seed the randomizer with `` `prng``:
```
`prng@0
```

This initializes it with the current time.

For the first step, we generate a random permutation of the numbers 1 to 9, and index into them (see chapter 8 for the random
function `?`):
```
s1:(0,1+0N?9)@sg 
```
Since we have to exclude 0, we prepend it to make sure it is never used.

A possible value of `s1` would be:
```
4 7 2 3 8 1 5 9 6
3 8 1 5 9 6 4 7 2
5 9 6 4 7 2 3 8 1
7 2 4 8 1 3 9 6 5
8 1 3 9 6 5 7 2 4
9 6 5 7 2 4 8 1 3
2 4 7 1 3 8 6 5 9
1 3 8 6 5 9 2 4 7
6 5 9 2 4 7 1 3 8
```

For the second step, we have to shuffle individual 3-row and 3-column blocks.


```
4 7 2 | 3 8 1 | 5 9 6
3 8 1 | 5 9 6 | 4 7 2
5 9 6 | 4 7 2 | 3 8 1
7 2 4 | 8 1 3 | 9 6 5
8 1 3 | 9 6 5 | 7 2 4
9 6 5 | 7 2 4 | 8 1 3
2 4 7 | 1 3 8 | 6 5 9
1 3 8 | 6 5 9 | 2 4 7
6 5 9 | 2 4 7 | 1 3 8
```

```
4 7 2 3 8 1 5 9 6
3 8 1 5 9 6 4 7 2
5 9 6 4 7 2 3 8 1
-----------------
7 2 4 8 1 3 9 6 5
8 1 3 9 6 5 7 2 4
9 6 5 7 2 4 8 1 3
-----------------
2 4 7 1 3 8 6 5 9
1 3 8 6 5 9 2 4 7
6 5 9 2 4 7 1 3 8
```

The following line does both the shuffles at once, transposing the array twice.
```
s2: 2{+x@,/0N?'3 3#!9}/s1
```

You can try deriving the third step from the above snippet. If you're having trouble, you can reveal the spoiler here:

<details>
  <summary>Last step</summary>

```
2{+x@,/(!3)+/:3*-3?3}/s2
```

The final function looks like this:
```
gen: { / generate a random sudoku board.
       / https://stackoverflow.com/a/61442050/4568534
  s1: (0,1+-9?9)@sg            / shuffle the numbers around from the grid.
  s2: 2{+x@,/0 3 6+-3?'3#3}/s1 / shuffle rows in each 3x9 block, cols in each 9x3 block
  2{+x@,/(!3)+/:3*-3?3}/s2}     / shuffle 3x9 row blocks, 9x3 col blocks
```
</details>

## Displaying a Sudoku puzzle

A sudoku puzzle has lines akin to a tic tac toe puzzle. The default K prettyprint is nice, but having the lines like in the
newspaper is nicer.

There are many different approaches you can use to make this. Here, I will be modifying a character array to get the desired
result. First, we add the horizontal lines using the splice form `?`:

```
s:(" "/'$x)?[;;,17#"-"]/6 3
```

This may be confusing, but it is simpler if you realize that this is just a fold with a 2-element projection. In `x f/y`,
```
x: " "/'$x
f: ?[;;,17#"-"]
y: 6 3
```


Then, we add some vertical lines (and their intersections) with the help of a column projection:
```
s[;5 11]:2#'11#"|||+"
```
neat and concise, and a good place to use modification.

## Solving a Sudoku puzzle
A beginner programming course would usually use a recursive algorithm to solve a sudoku puzzle. Even though there are multiple
ways to recursively solve sudoku in K, we will be looking at an iterative method.

The solver we will write now is a translation of Roger Hui's Sudoku solver, originally written in J, then translated to K. The basic algorithm behind Roger Hui's sudoku solver is to
1. Take each board given.
2. Take an empty spot on the board and place all possible valid numbers.
3. If there are no more moves possible, remove it. If it is solved or has possible moves, keep it.

There are some test puzzles in `code/sudoku.k` that you can use to understand the result of the steps below.

First, we define a few simple helpers:
```
j:       (,/0 27 54+\:0 3 6)+\:,/0 9 18+\:0 1 2 / helper for c and r
r:       9#',:'(9*!9)+\:!9                      / row for each cell.
c:       ((!9)+\:9*!9)@9#,!9                    / col for each cell.
b:       j@(,/9#'!9)@j                          / block for each cell.
I:       r,''c,''b                              / all cells to check for each cell.
R:       j,((9*!9)+\:!9),(!9)+\:9*!9            / row, col, block indices.
in:      {~^y?x}                                / is x in y?
```

You can try peeking at their values to understand what they mean.

### Finding valid moves
First, we need a function to find valid moves for each cell of a board. We will call this `free`.

```
free:    {(0=x)>(1+!9)in/:/:(,/x)@I}
```

What `free` does is take a board and mark which numbers can be placed at which positions.

`(1+!9)in/:/:(,/x)@I` checks if each of 1-9 are present in the row, column, block for each cell.

The check `(0=x)>` makes sure that numbers can never be placed at non-empty positions. What it finally returns is a 9x9x9
boolean array where  the result at `[i;j;k]` is 1 if `1+k` can be placed at `[i;j]`. If we do `1+&:''` on the resultant array, we can find out which numbers we can place at each location.

### Validating a board

To validate a board, we need to check each region and make sure that all is

getting the regions is simple: we just use the helper `R`:


```
regions:{(,/x)@R}
```

This returns a list of 9-element lists which contain each region. Next we can check each region with a cool idiom: `x?x`. What `x?x` helps with is checking for duplicates.
If all elements in `x` are unique, `(x?x)~!#x`. Hence, we can check each row with `!#x` (which is `!9` in this case) to find out which elements are out of place.

For each row we now do
```
{(!9)=x?x}'
```

This expression however will mark empty spots as wrong, so we need to rectify that:

```
{(0=x)|{(!9)=x?x}'x}
```

Then we need to make sure that all numbers are in 0-9 and we have a function that checks individual cells:

```
chk: {(x in !10)&(0=x)|{(!9)=x?x}'x}
```

Finally, we can use it to validate an entire board:
```
ok: {&/,/chk regions x}
```

### Step 1: Filling in the right places

The simplest case in sudoku is when a single cell has a single candidate number. The other case is multiple candidates. We will handle these separately. To handle these cases, we don't need the entire grid, but the numbers that can be placed in its cells, the result of applying `free` to the grid.


#### For a single candidate number
First, we find free cells which sum to 1:

```
{1=+/''x}
```

Then we mark each cell by its respective number:

```
(+/''x*\:\:1+!9)
```

`+/''` here can also be replaced with `|/`. What matters is that we are only handling single numbers, so summing cells with multiple possibilities will be zeroed out in the next step, where we multiply the two:

```
s1x: {(+/''x*\:\:1+!9)*1=+/''x}
```

#### For multiple candidate numbers
Here, what we will look at is whether a candidate number occurs exactly once in a row or column, and assign that number to its respective cell.

First, among all groups, we find the ones that have one element free. We can do this as follows:
```
m:1=+/'(,/x)@R; j:&|/'m
```

Once we have the groups, we can then find the groups that have only one free value (indices).
```
j:&|/'m
```

This can then be immediately used to locate the first `1` in those respective groups.
```
k:m[j]?\:1b
```
Using these locations, we can now find them in the actual grid:
```
i:,/(R@j)@'&:'(+:'(,/x)@R@j)@'k
```
Finally, we fill these new elements into the grid and return it.
```
9 9#@[&81;i;:;1+k]
```

```
s1u: {m:1=+/'r:regions@x          / (27x9 array) boolean array of values which
                                  /    are only free in one element of a group per group
      j:&|/'m                     / indices of groups which have at least one value which is free only once
      k:m[j]?\:1b                 / for such groups, the first value which is free only once
      i:,/(R@j)@'&:'(+:'r@j)@'k   / find the positions of the first element of each group
                                  /    which is only free once in that group
      9 9#@[&81;i;:;1+k]}         / make a matrix of these filled in
```

### Step 2: Filling all possible candidates
The previous step tries to input "forced" moves, where there's only one possibility to fill a single cell. Now we have to fill
other cells with all possible outcomes.

First, if there are no zeroes in the grid, we can just return it as is.
```
$[~in[0;,/x]; :,x; ::]
```
Here, we use `::` because `$` always requires two branches. `::` is a null and equivalent to an empty statement, so you can
use it to mark empty statements.

Now, operating on the free list of the puzzle, we can find a single cell with a minimum number of possibilities.
```
b:free x; i:t?&/t:,/(10,1_!9)@+/''b
```

Then, each possibility for that minimum cell is taken and inserted into the grid.
```
d:1+&(,/b)@i; x+/:d*\:i=9 9#!81
```

Here's the filling function. Since we have multiple possible grids that can approach the answer, `s2` is defined below.
```
s2a:{$[~in[0;,/x]; :,x; ::]; b:free x; i:t?&/t:,/(10,1_!9)@+/''b
     d:1+&(,/b)@i; x+/:d*\:i=9 9#!81}
s2: {,/s2a'x}
```

### Combining all the steps
Our final step is to apply all the above steps till we reach a solution. This is easy with fixpoint (`/`).
The solution is simple: Apply step 1, filter out invalids, apply step 2.
```
sudoku:{{s2 (ok')#s1 x}/,x}
```

## Creating a valid puzzle

A sudoku puzzle needs to satisfy the following requirements:
1. A puzzle may have only one valid solution.
2. A puzzle must have digits placed in valid squares.

We can add `n` empty spaces to a board like so:
```
nz:{b:,/x;9 9#@[b;y?&~0=b;:;0]}
```

To check whether a puzzle is valid, all we need to check is if `1=#sudoku x`. 

To generate a random board and test this, you can use `gen[]`. 
```
gp:{{~1=#sudoku x}{z;nz[x;y]}[x;y]/9 9#9}
```
Note that the least possible number of hints a sudoku puzzle can have is 17, and many sudoku puzzles are not reducible to 17 hints. Use `gp` very carefully.

## Playing the game
Now that we have all the important parts done, we can play the game.
```
`1:"Sudoku Puzzle\n"
```

First, we ask the player for a number of empty spaces (for difficulty). If it is not numeric or not less than or equal to 64, we should prompt again.
```
zs:{~((10/x-"0")<65)&(&/x>"0"-1)& &/x<"9"+1}{`1:"Enter number of empty spaces:";-1_1:`}/"65"
```
`1:` returns a trailing newline with its input, so we remove that.
We use `"65"` to start the loop because while is entry controlled.

Finally, we can set up a game loop:
- The while condition checks if the game is won.
- The user can end the game at any time, and a flag is set to check for a win or a loss.
- Coordinates are validated using *outdexing* i.e. if an array is indexed out of bounds, it returns a null value.
- Finally, the puzzle is amended at the given coordinates using the special form for Deep Amend.
```
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
```

Enjoy your sudoku game!

## Exercises
- We can place numbers on the board just fine, but we can't modify the numbers we have previously placed. You can try:
  - An undo button
  - Input that allows you to modify any square that was previously empty
- Currently, this solver uses some flattening (`,/`) and reshaping `a#x` in order to solve a puzzle. These idioms are convenient, but flat arrays are much more efficient. Try to optimize the program to account for flat arrays.
