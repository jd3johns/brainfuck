# brainfuck
[brainfuck](https://esolangs.org/wiki/brainfuck) is a esoteric, Turing complete programming language.

## Compilation
To compile brainfuck source, first compile the brainfuck-to-C compiler (or rather, transpiler), then compile the brainfuck source to C, then compile that C file to an executable program.

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

