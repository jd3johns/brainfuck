# brainfuck
[brainfuck](https://esolangs.org/wiki/brainfuck) (BF) is an esoteric, Turing complete programming language.

## Compilation
To compile BF source, first compile the BF-to-C compiler (or rather, transpiler), then compile the BF source to C, then compile that C file to an executable program.

To simplify this process, just abstract out the transpiling step:
```
gcc -o compiler/bf2c compiler/bf2c.c
ln -s $(pwd)/compiler/bfk.sh ~/bin/bfk
echo export BF_COMPILER=$(pwd)/compiler/bf2c >> ~/.bashrc
. ~/.bashrc
```

And compile with minimal pain:
```
bfk src/hello.b
./hello
```

Or:
```
bfk src/hello.b someprogramename
```

## Developer Tools

### Cell Pointer Consistency
BF is by design a tricky language for visual parsing and cell pointer tracking. Within loops it is especially important to exit on the same cell with which you entered, otherwise the branch can end up on a different cell and corrupt the expected behaviour of the program.

Use the braces tool to ensure that the number of left and right shifts balance out within loops:
```
gcc -o tools/braces tools/braces.c
./tools/braces src/foo.b
```

Example output:
```
$ ./tools/braces src/foo.b
Imbalance in loop 5 (line 96): 2 extra right shifts
```
