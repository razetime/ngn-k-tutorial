# The ngn/k C API

This chapter will require a working knowledge of C, and it will make use of C
macros that are aimed at writing very terse code.

It is often the case that you will find a gap in one of you favourite languages
that K fills (and vice versa). This has led to porgrammers like [phantomics](https://github.com/phantomics)
reimplementing APL for use as an embeddable language. Commercial K
implementations also include a number of methods to do so. 

ngn/k uses a [unified C API](https://github.com/ktye/i/blob/master/%2B/README.md#c-api-kh)
that was defined in ktye's K implementation. The ngn/k specification of the API
header file is here: [`k.h`](https://codeberg.org/ngn/k/src/branch/master/k.h).
ktye's API is well documented, and if you are experienced with C interfaces,
it is recommended that you skip this chapter and
use the time to simply read the docs. You can also see
[onikuruma](https://github.com/x86y/onikuruma/tree/main) for an example of a
C binding to a popular library. This chapter simply describes in a more
linear, friendly manner how to use the API.

## Extending ngn/k with the C Foreign Function Interface

To use C functions in K, you need to do the follwing:
- Modify the ngn/k makefile and build `libk.so`
- Write glue code for your K program using k.h
- Compile the glue code into a dynamic linked library (in this case, a `.so`
  file)
- Import the functions you require from the library using the `2:` I/O verb,
  and use them!
- Pray to your favourite deity that there are no segmentation faults (optional)

A simple example for this is given with the implementation at
[`x/extend`](https://codeberg.org/ngn/k/src/branch/master/x/extend).

## Building `libk.so`

First, run `make c` in your ngn/k installation to avoid any strange build
errors. You need to modify the [ngn/k makefile](https://codeberg.org/ngn/k/src/branch/master/makefile)
on line 4, changing the `L` variable to `L='-lm -ldl -Wl,-E'`
(ignore the comment).

Then, run `CC=clang make k libk.so` (using clang is important). This should
give you a `libk.so` file.

## C API Datatypes
ngn/k data is represented by the type `K` in C (which is secretly a
[`long long`](https://codeberg.org/ngn/k/src/branch/master/k.h).). All
function arguments must be of type `K`.

Assuming you know what is contained in a variable of type `K`, you can convert
it to C data of the appropriate form. `cK(K)` for example, converts a K value into
a C `char`.

`sK(K)` does not exist however, so you have to use the K execution function
`Kx(char*,args)` which lets you execute an arbitrary K function on the required
arguments. `Kx("$",x)` will cast a symbol of type K to a character list of type
`K`, which you can then read with the functions in the next section.

For converting a list, you have to first query:
- `NK(K)` to query length of the list
- `TK(K)` to get type of the list
you need to allocate the required amount of memory using these values, and then
use a conversion function, like `CK(char*,K)`, which reads a K
value into a C character array.

A basic rule is that functions that start with a lowercase letter convert
atoms, uppercase converts arrays.

Once you have processed the converted C data, you have to then return a K
value from your function. This is done with functions like `Kc(char)`,
`KC(char*, size_t)` and so on. They have a similar naming scheme. These
functions return a value of type `K` and need no special preparation.

## Using functions from libgmp

We are using libgmp, since it provides a utility that most K implementations
do not. Make sure to get your installation files from https://gmplib.org/#DOWNLOAD
and follow the instructions given with the download. Make sure you have it on
your C include and library paths.

The base C file will just contain a couple of functions and include the two
main headers: `gmp.h` and `k.h`. We will first write a makefile to compile it
correctly:

__File:__ `Makefile`
```makefile
K_PATH=/home/razetime/code/k
run: libadd.so
	LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(K_PATH) $(K_PATH)/k add.k
libadd.so: add.c
	$(CC) -I$(K_PATH) -L$(K_PATH) -shared -fPIC $^ -o $@ -lk -lgmp
```

make sure to change the `K_PATH` variable on line 1 to the correct location on
your device.

In C we will take large integers as strings and add them together. We are using
the macros from `k.h` here for the sake of consistency. First,
we will start by converting K strings into C strings, and return the first
argument for now.

__File:__ `add.c` 
```c
#include <stdio.h>
#include <stdlib.h>
#include <gmp.h>
#include <k.h>
K add(K a,K b){
  N al=NK(a),bl=NK(b);
  C* ac=calloc(al+1,sizeof(C));C* bc=calloc(bl+1,sizeof(C));
  CK(ac,a);CK(bc,b);
  printf("a: '%s'\nb: '%s'\n",ac,bc);
	return KC(ac,al);
}
```

In K, we will simply import the function, specifying number of args,
and call it.

__File:__ `add.k`
```
add:`"./libadd.so"2:(`add;2)
add["123";"345"]
```

Running `make run` now should show the correct values of `a` and `b`.

Using the extracted data in GMP is simple.We initialize our operands and result
variables, and then use the [Integer Functions](https://gmplib.org/manual/Integer-Functions)
as per the documentation. The result will be an `mpz_t`. This can be converted
to a C string, then converted to a K string. So the last few lines of `add()` become:

```
  mpz_t big_a,big_b,r;
  mpz_init_set_str(big_a,ac,10);mpz_init_set_str(big_b,bc,10);mpz_init(r);
  mpz_add(r,big_a,big_b);
	return KC(mpz_get_str(NULL,10,r),al);
```

`make run` will now give you the correct sum: `"468"`. Feel free to experiment
with bigger numbers, and enjoy your new K powers!
