.data
msg:
    .ascii "Hello World\n"
    len = . - msg

.text
.globl _start
_start:
    movl $len, %edx
    movl $msg, %ecx
    movl $1, %ebx   # write系统调用
    movl $4, %eax
    int $0x80

    movl $0, %ebx
    movl $1, %eax
    int $0x80
