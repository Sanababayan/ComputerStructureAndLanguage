.data
ds:
arr: .zero 800
n: .zero 4

.text
.globl asm_main
    asm_main:
    stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)

    # ---------------------------       
    # Write Your Code here
        larl    9, ds
        la      13, 0
        brasl   %r14, read_int
        chi     2, 3
        jle     END
        lr      8, 2
        st      2, n-ds(9, 0)
        OUTER_LOOP:
        xr      10, 10
        lhi     10, 2
        INNER_LOOP:
        xr      6, 6
        lr      7, 8
        dr      6, 10
        chi     6, 0
        je      INNER_END
        ahi     10, 1
        cr      10, 8
        jl      INNER_LOOP
        st      8, arr-ds(9, 13)
        la      13, 4(0, 13)
        INNER_END:
        bctr    8, 0
chi     8, 3
        jnl     OUTER_LOOP
        xr      2, 2
        lhi     2, 4
        brasl   %r14, print_int
        lhi     2, ' '
        brasl   %r14, print_char
        lhi     2, 2
        brasl   %r14, print_int
        lhi     2, ' '
        brasl   %r14, print_char
        lhi     2, 2
        brasl   %r14, print_int

        xr      10, 10
        l       10, n-ds(9, 0)

        LOOP1:
        bctr    13, 0
        bctr    13, 0
        bctr    13, 0
        bctr    13, 0
        lr      6, 13
        LOOP2:
        xr      7, 7
        xr      8, 8
        l       7, arr-ds(9, 13)
        l       8, arr-ds(9, 6)
        ar      7, 8
        cr      10, 7
        jnp     LOOP2_END
        brasl   %r14, print_nl
        lr      2, 7
        brasl   %r14, print_int
        lhi     2, ' '
        brasl   %r14, print_char
	lr      2, 8
        brasl   %r14, print_int
        lhi     2, ' '
        brasl   %r14, print_char
        sr      7, 8
        lr      2, 7
        brasl   %r14, print_int
        bctr    6, 0
        bctr    6, 0
        bctr    6, 0
        bctr    6, 0
        chi     6, 0
        jnl     LOOP2
        LOOP2_END:
        chi     13, 0
        jp      LOOP1
        END:
    # ---------------------------       

    lay     %r15, 8(%r15)
    lg      %r14, -4(%r15)
    br      %r14                                                                                           