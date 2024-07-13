.data
ds:
arr: .zero 4000
.text
.globl asm_main
    asm_main:
    stg     %r14, -4(%r15)
    lay     %r15, -8(%r15)

    # ---------------------------       
    # Write Your Code here
        larl    6, ds
        brasl   %r14, read_int
        lr      7, 2
        xr      9, 9
        la      8, 0
        LOOP1:
        brasl   %r14, read_int
        st      2, arr-ds(6, 8)
        la      8, 4(8)
        la      9, 1(9)
        cr      9, 7
        jl      LOOP1

        LOOP2:
        bctr    8, 0
        bctr    8, 0
        bctr    8, 0
        bctr    8, 0
        l       2, arr-ds(6, 8)
        brasl   %r14, print_int
        brasl   %r14, print_nl
        chi     8, 0
        jp      LOOP2
    # ---------------------------       

    lay     %r15, 8(%r15)
    lg      %r14, -4(%r15)
    br      %r14