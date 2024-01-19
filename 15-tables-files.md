# Tables and Libraries

ngn/k has a hidden, somewhat secret data structure: the table. Tables are a
prominent presence in k7 and k9, the latest versions of K, so ngn/k supports
them for that reason.

## Tables
A table uses symbols to mark columns, and integer indices to mark rows.
Making a table is simple. The first method is flipping a dictionary<sup>[1](#one)</sup>:
```
 :t:+`a`b!(1 2;3 4)
+![ `a `b
 +(( 1; 3)
   ( 2; 4))]
```
The display is a bit strange because ngn/k as described earlier, always returns
valid K data. However, as long as you have more than one column in your table,
the columns will be aligned correctly.


The other way to make a table is with a list of dictionaries:
```
 :t:(`a`b!1 2;`a`b!3 4)
+![ `a `b
 +(( 1; 2)
   ( 3; 4))]
```
The key names of every element must be the same, and they must be in
the same order. This form is good if you are constructing tables
programmatically, so ``(,`a`b!1 2),`a`b!3 4`` would be a different way to come
up with the same table.

Creating a K table requires rectangular data: all rows must be of the same
length, and all columns must be of the same length.

Tables can be indexed into in the same ways as other datatypes, described in
Chapter 4. However, tables are special in that you can index into them using
column labels *and* row labels, without the need of a projection. Using `t`
from the previous example:

```
 t[1]
!/+((`a;3)
    (`b;4))
 t[`b]
2 4
```

Here, retrieving a single row returns a dictionary, and a single column is a
simple list. Retrieving multiple rows and columns results in a table.

ngn/k does not come with a query language for tables, but there are
equivalent ways to access data. Usually a single SQL query breaks down into
multiple K primitives, abstracting away all the dirty work. In the Kx Systems
implementation, the Q language has such syntax if you'd like to try it out.

`#` (filter) filters rows, like an SQL `SELECT ... WHERE` query.
The same goes for `_`.
```
 / SELECT * FROM t WHERE a < 2;
 {x[`a]<2}#t
+`a`b!(,1;,3)
```

<!--
Updates to a table have to be done with indexing. An SQL group by query had to
be done with `=`, which returns a dictionary that has to be reconstituted into
a table.

```
 t:+`a`b!(!10;10?10)
 ,/t@=2!t@`a
```
-->

## File Model
ngn/k's file I/O is based on the UNIX model of file management. It is best to
read up on the mechanics of the model using the UNIX manual pages or other
reliable document before using K for file I/O.

As you may remember from Chapter 10, we can use `0:`(line-oriented) and `1:`
(byte-oriented) to read from and
write to files. This is easy with a string denoting a file name, but you can
also open a file descriptor to a file with `<`.

### `<x` Open

**Symbol:** `<`

**Args:** `< symbol`

**Description:** Return a file descriptor that points to the file at location
`x`.

### `>x` Close

**Symbol:** `>`

**Args:** `> integer`

**Description:** Close the file descriptor with id `x`.

File descriptors can be used in place of file names for `0:`. You can also use
file descriptors that were not opene by your program. A simple example is
opening stdin on linux, which is usually open at file descriptor 0. So this is
another way to prompt for input:
```
 0:0
123
,"123"
```

## Libraries and Namespaces
A somewhat common approach in a language like K is to store some forms of
processed data in a file for later analysis (similar to prolog/datalog, the
data format is consistent and easy to read). In any K file or the REPL you can
do `\l data.k` to reuse the data from a file, or simply use the file like a library.

Sometimes however, your code and your data files may have some naming conflicts,
and this is where `\d` comes in. One easy way to use `\d` is as an easy way to
make large namespaces. Once `\d ns` is used for example, all global variables
defined after that are prefixed with `ns.`.
```
 \d ns
 a:1
 ns
'value
 ns
 ^

 ns.a
1
```

Note that `ns` is not a variable you can inspect, it is just a prefix for
variables in your namespace. You can freely use any variables defined in `ns`
as long as you don't navigate to a different one with `\d`, like `\d .`,
which goes back to the global namespace.

```
 \d .
  a
'value
 a
 ^
i
 ns.a
1
```

A common pattern for importing libraries is hence:
```
\d l
\l lib.k
\d .
```
You can load as many libraries as you like into a namespace, allowing some
useful grouping strategies.

Finally, to "index" into namespaces, you can use `.`. This builtin is mostly
for convenience.

### `.x` Get

**Symbol:** `.`

**Args:** `. list_of_symbols`

**Description:** Index into the given namespaces. ``.`a`b`c`` will return the
value of `a.b.c`. Invalid routes will throw an error.

## Serialization
The other way of serializing K data, apart from the default prettyprinter `` `k``
is in the JSON format. K's data model generally maps well to JSON. You can convert any
object to JSON with the help of `` `j``.
```
 `j@`a`b`cd!(1;"a";`sym)
"{\"a\":1,\"b\":\"a\",\"cd\":\"sym\"}"
```

These special functions like `` `j`` and `` `k`` are symbols that behave
specially when called on data, and are special to the ngn/k implementation.

<sup id="one">1</sup>: Internally this is not a full transposition of a
dictionary. It just changes how the data is seen by the ngn/k interpreter.
