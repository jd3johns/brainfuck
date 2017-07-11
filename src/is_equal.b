;;;;;
; Print 'T' (true) if two input characters are equal
;
; A single whitespace character must be present between input chars
;
; Program layout:
;   msg:       {cnt; val}
;   cmpStatus: {val}
;   loopCond:  {val}
;   input1:    {val; tmp0; tmp1; isZero; tmp2; tmp3}
;   input2:    {val; tmp0; tmp1; isZero; tmp2; tmp3}
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

; load char input1 character
input1::val > ,
; zero out char if statement temps for val
input1::tmp0 > [-]
input1::tmp1 > [-]
; zero out bool indicator for input1 zeroness
input1::isZero > [-]
; zero out char if statement temps for isZero
input1::tmp2 > [-]
input1::tmp3 > [-]

; load char input2 character (ignore single whitespace in between chars)
input2::val > ,,
; zero out char if statement temps for val
input2::tmp0 > [-]
input2::tmp1 > [-]
; zero out bool indicator for input2 zeroness
input2::isZero > [-]
; zero out char if statement temps for isZero
input2::tmp2 > [-]
input2::tmp3 > [-]

; reset pointer to comparison loop condition
input2::head(val) <<<<< 
input1::head(val) <<<<< <
loopCond <

; compare input1 to input2 and set comparison status to true if equal
loopCond [
    ; reset pointer to input1
    input1::head(val) >
    ; assume input1 is now zero
    input1::isZero >>> +
    ; if input1 is zero then decrement it and reset zeroness bool
    input1::val <<< [>+ >+ <<-] input1::tmp0 > [<+ >-]
    input1::tmp1 > [
        input1::isZero > [-]
        input1::val <<< -
        input1::tmp1 >> [-]
    ]

    ; if input1 is zero then exit loop at next iteration
    input1::isZero > [>+ >+ <<-] input1::tmp2 > [<+ >-]
    input1::tmp3 > [
        loopCond <<<<< < [-]
        input1::tmp3 >>>>> > [-]
    ]

    ; reset pointer to input2
    input2::head(val) >
    ; assume input2 is now zero
    input2::isZero >>> +
    ; if input2 is zero then decrement it and reset zeroness bool
    input2::val <<< [>+ >+ <<-] input2::tmp0 > [<+ >-]
    input2::tmp1 > [
        input2::isZero > [-]
        input2::val <<< -
        input2::tmp1 >> [-]
    ]

    ; if input2 is zero then exit loop at next iteration
    input2::isZero > [>+ >+ <<-] input2::tmp2 > [<+ >-]
    input2:tmp3 > [
        input1::head(val) <<<<< <<<<< <
        loopCond < [-]

        ; if input1 is also zero then set comparison status to true
        input1::isZero >>>> [>+ >+ <<-] input1::tmp2 > [<+ >-]
        input1::tmp3 > [
            cmpStatus <<<<< << +
            input1::tmp3 >>>>> >> [-]
        ]

        input2::tmp3 >>>>> > [-]
    ]
    
    loopCond <<<<< <<<<< <<
]

; reset pointer to comparison status
cmpStatus <

; if input1 and input2 are equal print out result message
cmpStatus [
    msg::val < .
    cmpStatus > [-]
]

