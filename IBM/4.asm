text
.globl gcd
.globl lcm
gcd:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)

        # ---------------------------   
        # Write Your Code here
        lr      1, 2
        lr      13, 3
        chi     1, 0
        je      ZERO0
        chi     13, 0
        je      END

        cr      1, 13
        jl      LOW
        lr      10, 13
        j       LOOP
        LOW:
        lr      10, 1
        LOOP:
        chi     10, 0
        jnp     LOOP_END
        xr      6, 6
        lr      7, 1
        dr      6, 10
        chi     6, 0
        jne     END_IF
        xr      6, 6
        lr      7, 13
        dr      6, 10
        chi     6, 0
        jne     END_IF
        IF_COND:
	lr      2, 10
        j       END
        END_IF:
        bctr    10,0
        j       LOOP
        LOOP_END:
        ZERO0:
        lr      2, 13
        END:
        # ---------------------------   

        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14

lcm:
        stg     %r14, -4(%r15)
        lay     %r15, -8(%r15)

        # ---------------------------       
        # Write Your Code here
        lr      6, 2
        lr      9, 3
        mr      8, 6
        brasl   %r14, gcd
        dr      8, 2
        lr      2, 9
        # ---------------------------       

        lay     %r15, 8(%r15)
        lg      %r14, -4(%r15)
        br      %r14