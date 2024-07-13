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

segment .data
first_input TIMES 80 db 0
second_input TIMES 80 db 0

answer TIMES 80 db 0
div_answer TIMES 80 db 0

mul_co_second TIMES 80 db 0
remainder_co_first TIMES 80 db 0

first_sign TIMES 1 db 1
second_sign TIMES 1 db 1
answer_sign TIMES 1 db 1
division_answer_sign TIMES 1 db 1
first_sign_rem 	TIMES 1 db 1
second_sign_rem TIMES 1 db 1

first_input_size TIMES 1 db 1
second_input_size TIMES 1 db 1
div_flag TIMES 1 db 0
rem_flag TIMES 1 db 0 

memory_rax TIMES 1 dq 0
memory_rbx TIMES 1 dq 0
memory_rcx TIMES 1 dq 0
memory_rdx TIMES 1 dq 0
memory_r13 TIMES 1 dq 0
memory_r14 TIMES 1 dq 0
memory_r15 TIMES 1 dq 0
memory_rsi TIMES 1 dq 0

ten TIMES 1 db 10
print_int_format: db "%ld", 0
read_int_format: db "%ld", 0
segment end

segment .text
	global asm_main
	extern printf
        extern putchar
        extern puts
        extern scanf
        extern getchar

asm_main:
    push	rbp
    push	rbx
    push	r12
    push	r13
    push	r14
    push	r15
    sub		rsp, 8
	
	START:
	mov	byte rem_flag[0], 0
	mov	byte division_answer_sign[0], 1
	mov	byte div_flag[0], 0
	mov	byte first_sign[0], 1
	mov	byte first_sign_rem[0], 1
	mov	byte second_sign_rem[0], 1
	mov	byte second_sign[0], 1
	mov	byte answer_sign[0], 1
	mov	byte first_input_size[0], 1
	mov	byte second_input_size[0], 1
	mov	rsi, 79
	START_LOOP0:
	mov	byte answer[rsi], 0
	mov	byte mul_co_second[rsi], 0
	mov	byte div_answer[rsi], 0
	mov	byte first_input[rsi], 0
	mov	byte second_input[rsi], 0
	mov	byte remainder_co_first[rsi], 0
	dec	rsi
	cmp	rsi, 0
	jge	START_LOOP0

	stack_alignment_begin
	call	read_char
	stack_alignment_done
	mov	r15, rax
        cmp     r15, 'q'
        jz      exit
	
	stack_alignment_begin
	call	read_char
	stack_alignment_done

	xor 	r13, r13
	stack_alignment_begin
	call	read_char
	stack_alignment_done
	mov	rbx, rax
	cmp	rbx, '-'
	jne	AFTER_FIRST_SIGN
	mov	byte first_sign[0], -1
	mov	byte first_sign_rem[0], -1
	jmp	FIRST_INPUT
	AFTER_FIRST_SIGN:
	sub	bl, 48
	mov	byte first_input[r13], bl
	mov	byte remainder_co_first[r13], bl
	inc	r13
	FIRST_INPUT:
	stack_alignment_begin
	call	read_char
	stack_alignment_done
	mov	rbx, rax
	cmp	rbx, 10
	jz	SECOND_INPUT
	sub	rbx, 48
	mov	byte first_input[r13], bl
	mov	byte remainder_co_first[r13], bl
	mov	rcx, r13
	inc	cl
	mov	first_input_size[0], cl
	inc	r13
	jmp	FIRST_INPUT
	
	SECOND_INPUT:
	xor	r14, r14
	stack_alignment_begin
	call	read_char
	stack_alignment_done
	mov	rbx, rax
	cmp	rbx, '-'
	jne	AFTER_SECOND_SIGN
	mov	byte second_sign[0], -1
	mov	byte second_sign_rem[0], -1
	jmp	LOOP0
	AFTER_SECOND_SIGN:
	sub	bl, 48
	mov	byte second_input[r14], bl
	inc	r14
	LOOP0:
	stack_alignment_begin
	call	read_char
	stack_alignment_done
	mov	rbx, rax
	cmp	rbx, 10
	jz	CALCULATION
	sub	rbx, 48
	mov	byte second_input[r14], bl
	mov	rcx, r14
	inc	cl
	mov	second_input_size[0], cl
	inc	r14
	jmp	LOOP0

	CALCULATION:
	cmp	r15, '+'
	je	SUM
	cmp	r15, '-'
	je	SUB
	cmp	r15, '*'
	je	MUL
	cmp	r15, '/'
	je	DIV
	cmp	r15, '%'
	je	REM

	REM:
	mov	byte rem_flag[0], 1
	jmp	DIV
	REM_BEFOR_PRINT:
	mov	al, byte second_sign_rem[0]
	mov	byte second_sign[0], al
	mov	byte first_sign[0], 1
	add	al, byte first_sign_rem[0]
	cmp	al, 0
	jne	REM_AFTER_SIGNING
	mov	byte first_sign[0], -1
	REM_AFTER_SIGNING:
	mov	rsi, 80
	xor	rbx, rbx
	REM_LOOP0:
	dec	rsi
	cmp	byte answer[rsi], 0
	jne	REM_LOOP1
	mov	byte first_input[rsi], 0
	cmp	rsi, 0
	jge	REM_LOOP0
	REM_LOOP1:
	mov	al, byte answer[rsi]
	mov	byte first_input[rbx], al
	dec	rsi
	inc	rbx
	cmp	rsi, 0
	jge	REM_LOOP1
	mov	r13, rbx
	movzx	r14, byte second_input_size[0]
	xor	rsi, rsi
	REM_ANSWER_ZEROING0:
	mov	byte answer[rsi], 0
	inc	rsi
	cmp	rsi, 80
	jle	REM_ANSWER_ZEROING0
	jmp	MUL
	REM_AFTER_MUL:
	mov	rsi, 80
	xor	rbx, rbx
	REM_LOOP2:
	dec	rsi
	mov	r14, rsi
	cmp	byte answer[rsi], 0
	jne	REM_LOOP3
	mov	byte second_input[rsi], 0
	cmp	rsi, 0
	jge	REM_LOOP2
	REM_LOOP3:
	mov	al, byte answer[rsi]
	mov	byte second_input[rbx], al
	dec	rsi
	inc	rbx
	cmp	rsi, 0
	jge	REM_LOOP3
	mov	al, byte answer_sign[0]
	mov	byte second_sign[0], al
	xor	rsi, rsi
	movzx	r13, byte first_input_size[0]
	REM_FIRST_INPUT_LOOP:
	mov	al, byte remainder_co_first[rsi]
	mov	byte first_input[rsi], al
	inc	rsi
	cmp	rsi, 79
	jle	REM_FIRST_INPUT_LOOP
	;inc	r13
	inc	r14
	xor	rsi, rsi
	REM_ANSWER_ZEROING1:
	mov	byte answer[rsi], 0
	inc	rsi
	cmp	rsi, 79
	jle	REM_ANSWER_ZEROING1
	mov	al, byte first_sign_rem[0]
	mov	byte first_sign[0], al
	mov	byte answer_sign[0], 1


	mov     byte rem_flag[0], 0
        mov     byte division_answer_sign[0], 1
        mov     byte div_flag[0], 0
        mov     byte first_sign_rem[0], 1
        mov     byte second_sign_rem[0], 1
        mov     byte answer_sign[0], 1
        mov     rsi, 79
        REM_START_LOOP0:
        mov     byte answer[rsi], 0
        mov     byte mul_co_second[rsi], 0
        mov     byte div_answer[rsi], 0
        mov     byte remainder_co_first[rsi], 0
        dec     rsi
        cmp     rsi, 0
        jge     REM_START_LOOP0

	jmp	SUB


	;r13 index of first_input
	;r14 index of second_input
	;r12 will hold the carry of sum
	;rbx == 10

	SUM:
	mov	cl, byte first_sign[0]
	add	cl, byte second_sign[0]
	cmp	cl, 0
	je	SUM_DIFFIRENT_SIGN
	cmp	byte first_sign[0], -1
	jne	SUM_SAME_SIGN
	mov	byte answer_sign[0], -1
	SUM_SAME_SIGN:
	xor	rsi, rsi
	xor	r12, r12
	mov	rbx, 10
	dec	r13
	dec	r14
	SUM_LOOP1:
	mov	rax, r12
	cmp	r13, 0
	jl	FIRST_NUMBER_FINISHED
	add	al, byte first_input[r13]
	FIRST_NUMBER_FINISHED:
	cmp	r14, 0
	jl	SECOND_NUMBER_FINISHED
	add	al, byte second_input[r14]
	SECOND_NUMBER_FINISHED:
	xor	r12, r12
	cmp	al, bl
	jl	SUM_ADJUST
	inc	r12
	sub	al, bl
	SUM_ADJUST:
	mov	byte answer[rsi], al
	dec	r13
	dec	r14
	inc	rsi
	cmp	rsi, 79
	jle	SUM_LOOP1
	jmp	PRINT
	SUM_DIFFIRENT_SIGN:
	cmp	byte first_sign[0], 1
	je	SUM_SECOND_NEGETIVE
	;second - first
	SUM_THIRD:
	dec	r13
	dec	r14
	xor	rsi, rsi
	xor	rbx, rbx
	SUM_THIRD_LOOP0:
	xor	rax, rax
	cmp	r14, 0
	jl	SUM_THIRD_FIRST_NUMBER_FINISHED
	mov	al, byte second_input[r14]
	SUM_THIRD_FIRST_NUMBER_FINISHED:
	cmp	r13, 0
	jl	SUM_THIRD_SECOND_NUMBER_FINISHED
	sub	al, byte first_input[r13]
	SUM_THIRD_SECOND_NUMBER_FINISHED:
	sub	al, bl	
	xor	rbx, rbx
	cmp	al, 0
	jge	SUM_THIRD_AFTER_ADJUST
	add	al, 10
	inc	rbx
	SUM_THIRD_AFTER_ADJUST:
	mov	byte answer[rsi], al
	dec	r13
	dec	r14
	inc	rsi
	cmp	rsi, 79
	jle	SUM_THIRD_LOOP0
	cmp	byte answer[79], 9
	jl	PRINT
	mov	byte answer_sign[0], -1
	SUM_THIRD_LOOP_FOR_NEGETION:
	dec	rsi
	sub	byte answer[rsi], 9
	neg	byte answer[rsi]
	cmp	rsi, 0
	jge	SUM_THIRD_LOOP_FOR_NEGETION
	add	byte answer[0], 1
	jmp	PRINT
	SUM_SECOND_NEGETIVE:
	;first - second
	jmp	SUB_TWO_POSITIVE

	SUB:
	mov	cl, byte first_sign[0]
	add	cl, byte second_sign[0]
	cmp	cl, 0
	jne	SUB_DIFFERENT_SIGN
	mov	cl, byte first_sign[0]
	mov	byte answer_sign[0], cl
	jmp	SUM_SAME_SIGN
	SUB_DIFFERENT_SIGN:
	cmp	byte first_sign[0], 1
	je	SUB_TWO_POSITIVE
	xor	rsi, rsi
	jmp	SUM_THIRD
	SUB_TWO_POSITIVE:
	xor	rsi, rsi
	SUB_ZEROING_ANSWER:
	mov	byte answer[rsi], 0
	inc	rsi
	cmp	rsi, 79
	jle	SUB_ZEROING_ANSWER
	dec	r13
	dec	r14
	xor	rsi, rsi
	xor	rbx, rbx
	SUB_LOOP0:
	xor	rax, rax
	cmp	r13, 0
	jl	SUB_FIRST_NUMBER_FINISHED
	mov	al, byte first_input[r13]
	SUB_FIRST_NUMBER_FINISHED:
	cmp	r14, 0
	jl	SUB_SECOND_NUMBER_FINISHED
	sub	al, byte second_input[r14]
	SUB_SECOND_NUMBER_FINISHED:
	sub	al, bl
	xor	rbx, rbx
	cmp	al, 0
	jge	SUB_AFTER_ADJUST
	add	al, 10
	inc	rbx
	SUB_AFTER_ADJUST:
	mov	byte answer[rsi], al
	dec	r13
	dec	r14
	mov	rbp, r14
	inc	rsi
	cmp	rsi, 79
	jle	SUB_LOOP0
	cmp	byte answer[79], 9
	jge	AFTER_SUB_DIV_CHECK
	cmp	byte div_flag[0], 1
	je	DIV_SIGN_CHECK
	jmp	PRINT
	AFTER_SUB_DIV_CHECK:
	mov	byte answer_sign[0], -1
	SUB_LOOP_FOR_NEGETION:
	dec	rsi
	sub	byte answer[rsi], 9
	neg	byte answer[rsi]
	cmp	rsi, 0
	jge	SUB_LOOP_FOR_NEGETION
	add	byte answer[0], 1
	cmp	byte div_flag[0], 1
	je	DIV_SIGN_CHECK
	jmp	PRINT

	MUL:
	xor	r9, r9
	xor	r8, r8
	dec	r8
	dec	r13
	mov	r15, r13
	mov	cl, byte first_sign[0]
	add	cl, byte second_sign[0]
	cmp	cl, 0
	jne	MUL_DIFFIRENT_SIGN
	mov	byte answer_sign[0], -1
	jmp	MUL_START
	MUL_DIFFIRENT_SIGN:
	mov	byte answer_sign[0], 1
	MUL_START:
	inc	r8
	dec	r14
	cmp	r14, 0
	jge	REM_MUL_CHECK
	cmp	byte rem_flag[0], 1
	je	REM_AFTER_MUL
	jmp	PRINT
	REM_MUL_CHECK:
	mov	r13, r15
	xor	rbx, rbx
	mov	bl, byte second_input[r14]
	xor	rsi, rsi
	mov	r9, r8
	MUL_ZERO_LOOP:
	xor	r12, r12
	cmp	r9, 0
	jle	MUL_FIRST_INPUT_ITERATION
	mov	byte mul_co_second[rsi], 0
	inc	rsi
	dec	r9
	jmp	MUL_ZERO_LOOP
	MUL_FIRST_INPUT_ITERATION:
	movzx	rax, byte first_input[r13]
	imul	bl
	add	rax, r12
	mov	r10, rax
	mov	rcx, 10
	xor	rdx, rdx
	idiv	rcx
	mov	r12, rax
	imul	byte ten[0]
	sub	r10, rax
	mov	rcx, r10
	mov	byte mul_co_second[rsi], cl
	inc	rsi
	dec	r13
	cmp	r13, 0
	jge	MUL_FIRST_INPUT_ITERATION
	mov	byte mul_co_second[rsi], r12b
	xor	rsi, rsi
	xor	r12, r12
	MUL_SUM_OF_TEMP_AND_ANSWER:
	movzx	rax, byte answer[rsi]
	add	al, byte mul_co_second[rsi]
	add	rax, r12
	mov	r10, rax
	mov	rcx, 10
	xor	rdx, rdx
	idiv	rcx
	mov	r12, rax
	imul	byte ten[0]
	sub	r10, rax
	mov	byte answer[rsi], r10b
	inc	rsi
	cmp	rsi, 79
	jle	MUL_SUM_OF_TEMP_AND_ANSWER
	jmp	MUL_START

	DIV:
	mov	byte div_flag[0], 1
	mov	cl, byte first_sign[0]
	add	cl, byte second_sign[0]
	cmp	cl, 0
	jne	BEFOR_DIV_START
	mov	byte division_answer_sign[0], -1
	BEFOR_DIV_START:
	mov	r15, r13
	sub	r15, r14
	cmp	r15, 0
	jl	PRINT_ZERO_ANSWER
	DIV_START:
	xor	rcx, rcx
	mov	byte answer_sign[0], 1
	mov	byte first_sign[0], 1
	mov	byte second_sign[0], 1
	DIV_LOOP0:
	movzx	r14, byte second_input_size[0]
	add	r14, r15
	mov	memory_rax[0], rax
	mov	memory_rbx[0], rbx
	mov	memory_rcx[0], rcx
	mov	memory_rdx[0], rdx
	mov	memory_rsi[0], rsi
	mov	memory_r15[0], r15
	mov	memory_r14[0], r14
	mov	memory_r13[0], r13
	jmp	SUB_TWO_POSITIVE
	DIV_SIGN_CHECK:
	mov	rax, memory_rax[0]
	mov	rbx, memory_rbx[0]
	mov	rcx, memory_rcx[0]
	mov	rdx, memory_rdx[0]
	mov	rsi, memory_rsi[0]
	mov	r15, memory_r15[0]
	mov	r14, memory_r14[0]
	mov	r13, memory_r13[0]
	cmp	byte answer_sign[0], -1
	je	DIV_SIGN_NEG
	inc	rcx
	mov	rsi, 80
	xor	rbx, rbx
	DIV_INDEX_OF_FIRST_INPUT:
	dec	rsi
	mov	r13, rsi
	inc	r13
	cmp	byte answer[rsi], 0
	jne	DIV_TRANSFER0
	cmp	rsi, 0
	jg	DIV_INDEX_OF_FIRST_INPUT
	
	DIV_TRANSFER0:
	mov	al, byte answer[rsi]
	mov	byte first_input[rbx], al
	dec	rsi
	inc	rbx
	cmp	rsi, 0
	jge	DIV_TRANSFER0
	jmp	DIV_LOOP0

	DIV_DONE:
	xor	rsi, rsi
	DIV_DONE_LOOP:
	mov	byte answer[rsi], 0
	inc	rsi
	cmp	rsi, 80
	jl	DIV_DONE_LOOP
	mov	byte answer[r15], cl
	cmp	byte rem_flag[0], 1
	je	REM_BEFOR_PRINT
	jmp	PRINT

	DIV_SIGN_NEG:
	mov	byte div_answer[r15], cl

	dec	r15
	cmp	r15, 0
	jge	DIV_START
	DIV_BEFOT_PRINT_LOOP0:
	xor	rsi, rsi
	DIV_BEFOR_PRINT_LOOP:
	mov	al, byte div_answer[rsi]
	mov	byte answer[rsi], al
	inc	rsi
	cmp	rsi, 80
	jl	DIV_BEFOR_PRINT_LOOP
	cmp	byte rem_flag[0], 1
	je	REM_BEFOR_PRINT
	jmp	PRINT

	PRINT:
	cmp	byte div_flag[0], 1
	je	PRINT_DIV_SIGN
	cmp	byte answer_sign[0], 1
	je	AFTER_PRINT_SIGN
	PRINT_NEGETIVE:
	mov	rdi, '-'
	stack_alignment_begin
	call	print_char
	stack_alignment_done
	jmp	AFTER_PRINT_SIGN
	PRINT_DIV_SIGN:
	cmp	byte division_answer_sign[0], 1
	jne	PRINT_NEGETIVE
	AFTER_PRINT_SIGN:
	xor	rsi, rsi
	mov	rsi, 79
	xor	rbx, rbx
	DO0:
	mov	bl, byte answer[rsi]
	cmp	bl, 0
	jg	DO1
	dec	rsi
	cmp	rsi, 0
	jge	DO0
	PRINT_ZERO_ANSWER:
	mov	rdi, 0
	stack_alignment_begin
	call	print_int
	call	print_nl
	stack_alignment_done
	jmp	START
	DO1:
	push	rsi
	mov	rdi, rbx
	stack_alignment_begin
	call	print_int
	stack_alignment_done
	pop	rsi
	dec	rsi
	mov	bl, byte answer[rsi]
	cmp	rsi, 0
	jge	DO1
	stack_alignment_begin
	call	print_nl
	stack_alignment_done
	jmp	START

	exit:





    add		rsp, 8
    pop		r15
    pop		r14
    pop 	r13
    pop 	r12
    pop 	rbx
    pop 	rbp

	ret
print_char:
    sub rsp, 8
    call putchar
    add rsp, 8 ; clearing local variables from stack
    ret

print_string:
    sub rsp, 8
    call puts    
    add rsp, 8 ; clearing local variables from stack
    ret

print_nl:
    sub rsp, 8
    mov rdi, 10
    call putchar
    add rsp, 8 ; clearing local variables from stack
    ret

read_int:
    sub rsp, 8
    mov rsi, rsp
    mov rdi, read_int_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call scanf
    mov rax, [rsp]
    add rsp, 8 ; clearing local variables from stack
    ret

read_char:
    sub rsp, 8
    call getchar
    add rsp, 8 ; clearing local variables from stack
    ret

print_int:
    sub rsp, 8
    mov rsi, rdi
    mov rdi, print_int_format
    mov rax, 1 ; setting rax (al) to number of vector inputs
    call printf 
    add rsp, 8 ; clearing local variables from stack
    ret
