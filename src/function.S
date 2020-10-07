.global coroutine_switch_stack
coroutine_switch_stack:
    push %rbp
    push %rbx
    push %r12
    push %r13
    push %r14
    push %r15

    // As seen later, after a stack change we always check the value at the top of the stack
    // to determine whether `start_call` must be called. Push a 0 to signify that no.
    pushq $0

    // Keep the current stack for later.
    mov %rsp, %rax

    // Set the stack to the request one.
    mov %rdi, %rsp

    // At the top of this new stack there must always be the value of rsi
    pop %rsi

    // This value of rsi must always be 0 unless it is the entrance of the coroutine, in
    // which case rsi is the parameter to pass to `start_call`. We call `start_call` with the
    // appropriate parameters.
    cmp $0, %rsi
    je 2f
    mov %rax, %rdi
    call corooteen_start_call
    int $3

    // If we reach here, it means that we are about to return to a code that has indeed called
    // `coroutine_switch_stack` earlier.
    // Pop rip.
    // Since we will eventually jump to label `3` below it may seem like we could just do
    // `add rsp, 8`, but since this inline assembly can exist in multiple versions in the final
    // binary, it is not guaranteed that the label `3` below is the same as the one we will
    // end up jumping to after the `ret`.
2:  pop %r15
    pop %r14
    pop %r13
    pop %r12
    pop %rbx
    pop %rbp
    ret
