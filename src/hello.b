Hello world program from the esolangs dot org website on brainfuck

++++ ++++                   Outer loop counter in cell #0 set to 8
[
    >++++                   Loop counter in cell #1 set to 4
    [
        >++
        >+++
        >+++
        >+
        <<<<-               Decrement loop counter
    ]                       Will exit loop once loop counter hits zero
    >+
    >+
    >-
    >>+
    [<]                     Return to inner loop counter

    <-                      Decrement outer loop counter
]
>>.                         'H'
>---.                       'e'
++++ +++..+++.              'llo'
>>.                         ' '
<-.                         'W'
<.                          'o'
+++.---- --.---- ----.      'rld'
>>+.                        '!'
>++.                        '\n'

