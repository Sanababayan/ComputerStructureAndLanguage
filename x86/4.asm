%include "asm_io.inc"

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

global gcd
global lcm

gcd:
    push	rbp
    push	rbx
    push	r12
    push	r13
    push	r14
    push	r15

    sub		rsp, 8

    ; -------------------------
    ; write your code here
    
    cmp		edi, 0
    jz		ZERO0
    cmp		esi, 0
    jz		ZERO1
    
    xor		rbp, rbp
    cmp		edi, esi
    jl		LOW
    jmp		HIGH
    LOW:
    	mov	ebp, edi
    	jmp	LOOP
    HIGH:
    	mov	ebp, esi
    LOOP:
	xor	rdx, rdx
    	xor	rax, rax
    	mov	eax, edi
    	idiv	rbp
    	cmp	rdx, 0
    	jnz	END_IF
    	
	xor	rdx, rdx
    	xor	rax, rax
    	mov	eax, esi
    	idiv	rbp
    	cmp	rdx, 0
    	jnz	END_IF
    	
    IF_COND:
    	xor	rax, rax
    	mov	eax, ebp
    	jmp	DONE
    	
    END_IF:	
	dec	ebp
	jnz	LOOP

    ZERO0:
    	xor	rax, rax
    	mov	eax, esi
    	jmp	DONE
    
    ZERO1:
    	xor	rax, rax
    	mov	eax, edi				
    
    DONE:
    ;--------------------------

    add		rsp, 8

    pop		r15
    pop		r14
    pop 	r13
    pop 	r12
    pop 	rbx
    pop 	rbp

    ret

lcm:
    push	rbp
    push	rbx
    push	r12
    push	r13
    push	r14
    push	r15

    sub		rsp, 8

    ; -------------------------
    ; write your code here
    xor		rax, rax
    mov		eax, edi
    xor		rbp, rbp
    mov		ebp, esi
    imul	rbp
    mov		r12, rax
    
    stack_alignment_begin
    call	gcd
    stack_alignment_done
    
    xor		rdx, rdx
    mov		rbx, rax
    mov		rax, r12
    idiv	rbx
    ;--------------------------

    add		rsp, 8

    pop		r15
    pop		r14
    pop 	r13
    pop 	r12
    pop 	rbx
    pop 	rbp

    ret    
   
