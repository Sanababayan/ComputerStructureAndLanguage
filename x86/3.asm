%include "asm_io.inc"

segment .data
arr TIMES 200 dw 0
segment end

%macro stack_alignment_begin 0
    push rbp
    mov rbp, rsp
    mov rax, rsp
    and rax, 15
    add rsp, rax
%endmacro

%macro stack_alignment_done 0
    mov rsp, rbp
    pop rbp
%endmacro

segment .text

global asm_main

asm_main:
    push	rbp
    push	rbx
    push	r12
    push	r13
    push	r14
    push 	r15

    sub		rsp, 8

    ; -------------------------
    ; write your code here

    xor		rsi, rsi

    stack_alignment_begin

    call read_int


    stack_alignment_done
    
    cmp		rax, 3
    jle		LAST
    
    mov		rbx, rax
    mov		r15, rbx

    xor		r13, r13

    LOOP_3_TO_N:
	mov	r12, 2
	INNER_LOOP:
		xor	rdx, rdx
   		mov	rax, rbx
		div	r12
		cmp	rdx, 0
		je	INNER_END
		
		inc	r12
		cmp	r12, rbx
		jl	INNER_LOOP
		jmp	IF_COND
			
	INNER_END:			
		dec	rbx
		cmp	rbx, 3
		jge	LOOP_3_TO_N
		jmp	CHECKING_TWO

	IF_COND:			
		mov	word arr[rsi], bx
		add	rsi, 2		
		inc	r13
		jmp	INNER_END
      
      CHECKING_TWO:
        cmp	r15, 4
        jge	TWO
        jmp	LOOP1

      TWO:
        xor	rdi, rdi
      	mov	rdi, 4
      	push	rsi
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	mov	rdi, ' '
	stack_alignment_begin
	call	print_char
	stack_alignment_done
	
	mov	rdi, 2
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	mov	rdi, ' '
	stack_alignment_begin
	call	print_char
	stack_alignment_done
	
	mov	rdi, 2
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	stack_alignment_begin
	call	print_nl
	stack_alignment_done
	pop	rsi
		
      LOOP1:
        xor	rdi, rdi
	sub	rsi, 2 
	mov	di, word arr[rsi]
	mov	r12, rdi
	mov	rbx, rsi

     LOOP2:
        xor	rbp, rbp
        mov	bp, word arr[rbx]
        mov	r14, rbp
        
        cmp	r14, 2
        jle	OUT
        
	add	rbp, r12
	cmp	rbp, r15
	jge	OUT

	push	rsi
	push	rbx
	
	mov	rdi, rbp
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	mov	di, ' '
	stack_alignment_begin
	call	print_char
	stack_alignment_done
	
	mov	rdi, r12
	
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	mov	di, ' '
	stack_alignment_begin
	call	print_char
	stack_alignment_done
	
	mov	rdi, r14
	
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	
	stack_alignment_begin
	call	print_nl
	stack_alignment_done
	
	pop	rbx
	pop	rsi
     
     OUT:		
        sub	rbx, 2
	cmp	rbx, 0
	jge	LOOP2
   
	dec	r13
	jnz	LOOP1
	
	LAST:
	
    ;--------------------------

    add 	rsp, 8

    pop		r15
    pop		r14
    pop		r13
    pop		r12
    pop		rbx
    pop		rbp

    ret
