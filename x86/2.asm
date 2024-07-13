%include "asm_io.inc"

segment .data
arr TIMES 1000 dw 0
segment end

segment .text

global asm_main

asm_main:
    push	rbp
    push	rbx
    push	r12
    push	r13
    push	r14
    push	r15

    sub		rsp, 8

    ; --------------------
    ; write your code here
    xor		rsi, rsi

    push	rsi
    push 	rbp
    mov 	rbp, rsp
    mov 	rax, rsp
    and 	rax, 15
    add 	rsp, rax
    call	read_int
    mov 	rsp, rbp
    pop 	rbp
    pop		rsi
    
    mov		r12, rax
    mov		r13, rax

    LOOP0:
        push	rsi
	push	rbp
	mov     rbp, rsp
	mov 	rax, rsp
	and	rax, 15
	add 	rsp, rax
	call   	read_char
	mov	rsp, rbp
        pop	rbp

    

	push 	rbp
	mov 	rbp, rsp
	mov 	rax, rsp
	and 	rax, 15
	add 	rsp, rax
	call	read_int
	mov 	rsp, rbp
        pop 	rbp
	pop	rsi
 
	mov	word arr[rsi], ax
	add	rsi, 2 
	dec	r12
	jnz	LOOP0
   
    LOOP1:
	sub	rsi, 2
	xor	rdi, rdi
	mov	di, word arr[rsi]
	
        push	rsi
	push 	rbp
	mov 	rbp, rsp
	mov 	rax, rsp
	and 	rax, 15
	add 	rsp, rax
	call	print_int
	mov 	rsp, rbp
        pop 	rbp


  
	push 	rbp
	mov 	rbp, rsp
	mov 	rax, rsp
	and 	rax, 15
	add 	rsp, rax
	call	print_nl
	mov	rsp, rbp
        pop	rbp
        pop	rsi

	dec	r13
	jnz	LOOP1
   ;--------------------------

    add		rsp, 8
    pop		r15
    pop		r14
    pop 	r13
    pop 	r12
    pop 	rbx
    pop 	rbp

    ret
