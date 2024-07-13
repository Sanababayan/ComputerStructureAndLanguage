.text
.globl asm_main
    asm_main:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)

        # ---------------------------   
        # Write Your Code here
        LOOP:
                brasl   %r14, read_char

                lr      7, 2

                chi     7, 113
                je      END

                xr      8, 8
                lhi     8, -1
                brasl   %r14, read_int
                lr      9, 2
                chi     9, 0
                jl      DOVOMI
                xr      8, 8

                DOVOMI:
                brasl   %r14, read_int

                lr      10, 2

		chi     7, 43
                je      POS

                chi     7, 45
                je      NEG

                chi     7, 42
                je      MUL

                chi     7, 47
                je      DEV

        POS:
                ar      9, 10
                lr      2, 9
                j       PRINT
        NEG:
                sr      9, 10
                lr      2, 9
                j       PRINT
        MUL:
                mr      8, 10
                lr      2, 9
                j       PRINT
        DEV:
                dr      8, 10
                lr      2, 9
                j       PRINT
        PRINT:
                brasl   %r14, print_int
                brasl   %r14, print_nl
                brasl   %r14, read_char
                j       LOOP
        END:
        # ---------------------------   

        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14
