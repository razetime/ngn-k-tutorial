# Input and Output

The main way of performing input and output in K is via its I/O verbs. 

every I/O verb has a different data format. However, the destination and source can be any of the following:

- the empty symbol `` ` ``, which irepresents STDIN and STDOUT
- An absolute path like `"/path/to/file"`
- A relative path Input, Output and System functions

The main method of I/O(input/output) in K is is via its input verbs: and input verb is denoted by a single digit, followed by a `:` symbol.

The number of an input verb denotes is data format:

- `0:` takes in arrays of character arrays (lines).
- `1:` takes in arrays of bytes.

<!-- The most commonly used I/O verbs are `0:` and `1:`. -->
You have already seen `0:` used for output in the first chapter.

Every I/O verb reads input when used monadically, and writes output when used dyadically. The general form is as follows:

`destination <Output Verb> data`

and

`<input verb> source`

every I/O verb has a different data format. However, the destination and source can be any of the following:

- the empty symbol `` ` ``, which represents STDIN and STDOUT
- An absolute path like `"/path/to/file"`
- A relative path like `"../path/to/file"` (relative to the directory the K interpreter is run in)
- An IP path in the form `"host:port"` where `host` can be omitted to imply `127.0.0.1`
- A file descriptor number which can be obtained via the open verb `<`

The *open* verb(`<`) initiates a stream of input/output to and from a given location,
which can be from the first 4 types given above.

Every opened stream must then be closed with `>` (close) before the end of your K program.


Now that we know what the input numbers take, we can finally understand what the basic K Hello world program does:

```
` 0:"Hello, World!"
| |
| v
| takes a string or list of strings
v
STDOUT
```

To prompt for input, we do ``0:` ``, which will read a single line of input from STDIN as a string.

A simple program which prompts and returns output would look like this:
```
 input: -1_1:`
Razetime
 `1:"Hello ",input,", I'm Dad!"
Hello Razetime, I'm Dad!
```

We have to use a `1_` here since `1:` will read a newline as part of the input. You can see this by just checking `1:`'s output:

```
 1:`
hello
"hello\n"
```

Now, you should have all you need to write interactive programs in K!

## Command line arguments and other console values
The other general way of getting input is through command line arguments.

Command line arguments (and all special reserved values) are represented by symbols. The name used for Command line arguments is `` `argv``.

These are the command line arguments I get when running the ngn/k repl:

```
 `argv[]
("/home/razetime/Software/k/k"
 "/home/razetime/Software/k/repl.k")
```

The first argument will always be the K binary, and the second argument will be the path to your K program, so usually you would want to do `2_argv[]` and then take the arguments you need.

Here are some of the other useful console values:

- `` `t`` gives the current time in microseconds.
- `` `env`` returns a dictionary containing the names of all environment variables mapped to their values.
- `` `prng[]`` is a pseudo-random number generator.

There are a few more special symbols available in the K repl(like `` `json``) which you can find by typing ``\` `` in the REPL.

## Vocabulary from this chapter
- I/O verbs: Special verbs which perform input and output with a specific data format.
- File Descriptor: An integer bound to an I/O stream. Can be used with I/O verbs.
- Special Symbols: The reserved words of K.

## Exercises
1. Write a program that takes two numbers from STDIN and adds them.
2. Write a program that returns its odd numbered command line arguments (the first, then the third, and so on).
