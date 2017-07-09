;;;;;
; Print 'T' (true) if input character is a space (' ')
;
; Program layout:
;   msg:       {cnt; val}
;   cmpStatus: {val}
;   loopCond:  {val}
;   input:     {     val; tmp0; tmp1; isZero; tmp2; tmp3}
;   cmp:       {cnt; val; tmp0; tmp1; isZero; tmp2; tmp3}
;
; Author: Jonathan Johnston
; Date:   2017/7/9
;;;;;

; set char result message 'T' (84) for comparison equality
msg::cnt [-] +++++ +++
msg::cnt [
    msg::val > +++++ +++++
    msg::cnt < -
]
msg::val > ++++

; zero out bool status of comparison operation
cmpStatus > [-]

; set bool comparison loop condition
loopCond > [-] +

; load char input character
input::val > ,
; zero out char if statement temps for val
input::tmp0 > [-]
input::tmp1 > [-]
; zero out bool indicator for input zeroness
input::isZero > [-]
; zero out char if statement temps for isZero
input::tmp2 > [-]
input::tmp3 > [-]

; set char comparison character ' ' (32)
cmp::cnt > [-] +++++
cmp::cnt [
    cmp::val > +++++ +
    cmp::cnt < -
]
cmp::val > ++
; zero out char if statement temps for val
cmp::tmp0 > [-]
cmp::tmp1 > [-]
; zero out bool indicator for cmp zeroness
cmp::isZero > [-]
; zero out char if statement temps for isZero
cmp::tmp2 > [-]
cmp::tmp3 > [-]

; reset pointer to comparison loop condition
cmp::head(cnt) <<<<< < 
input::head(val) <<<<< <
loopCond <

; compare input to cmp and set comparison status to true if equal
loopCond [
    ; reset pointer to input
    input::head(val) >
    ; assume input is now zero
    input::isZero >>> +
    ; if input is zero then decrement it and reset zeroness bool
    input::val <<< [>+ >+ <<-] input::tmp0 > [<+ >-]
    input::tmp1 > [
        input::isZero > [-]
        input::val <<< -
        input::tmp1 >> [-]
    ]

    ; if input is zero then exit loop at next iteration
    input::isZero > [>+ >+ <<-] input::tmp2 > [<+ >-]
    input::tmp3 > [
        loopCond <<<<< < [-]
        input::tmp3 >>>>> > [-]
    ]

    ; reset pointer to cmp
    cmp::head(cnt) >
    cmp::val >
    ; assume cmp is now zero
    cmp::isZero >>> +
    ; if cmp is zero then decrement it and reset zeroness bool
    cmp::val <<< [>+ >+ <<-] cmp::tmp0 > [<+ >-]
    cmp::tmp1 > [
        cmp::isZero > [-]
        cmp::val <<< -
        cmp::tmp1 >> [-]
    ]

    ; if cmp is zero then exit loop at next iteration
    cmp::isZero > [>+ >+ <<-] cmp::tmp2 > [<+ >-]
    cmp:tmp3 > [
        input::head(val) <<<<< <<<<< <<
        loopCond < [-]

        ; if input is also zero then set comparison status to true
        input::isZero >>>> [>+ >+ <<-] input::tmp2 > [<+ >-]
        input::tmp3 > [
            cmpStatus <<<<< << +
            input::tmp3 >>>>> >> [-]
        ]

        cmp::tmp3 >>>>> >> [-]
    ]
    
    loopCond <<<<< <<<<< <<<
]

; reset pointer to comparison status
cmpStatus <

; if input and cmp are equal print out result message
cmpStatus [
    msg::val < .
    cmpStatus > [-]
]

