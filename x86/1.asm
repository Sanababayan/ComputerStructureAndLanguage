%include "asm_io.inc"

segment .text

global asm_main

asm_main:
    push rbp
    push rbx
    push r12
    push r13
    push r14
    push r15

    sub rsp, 8

    ; -------------------------
    ; write your code here
    loop:
    	call	read_char
    	mov	rbx, rax
   	cmp	rbx, 'q'
   	jz	end1

    	call	read_int
    	mov	r12, rax

    	call	read_int
    	mov	r13, rax

    	cmp	rbx, '+'
    	jz	POS

   	cmp	rbx, '-'
    	jz	NEG

    	cmp	rbx, '*'
    	jz	MUL

    	cmp	rbx, '/'
    	jz	DEV

    	POS:
    		add	r12 ,r13
		mov 	rdi, r12
		jmp 	end2
    
    	NEG:
		sub	r12, r13
 		mov	rdi, r12
		jmp	end2

   	MUL:
		mov	rax, r12
		imul	r13
		mov	rdi, rax
		jmp	end2

    	DEV:
		mov	rax, r12
		mov	rdx, 0
		idiv 	r13
		mov	rdi, rax
		jmp	end2

    	end2:
		call	print_int
		call 	print_nl
	 	call	read_char
		jmp	loop
   
    	end1:			
    ;--------------------------

    add rsp, 8

    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp

	ret
