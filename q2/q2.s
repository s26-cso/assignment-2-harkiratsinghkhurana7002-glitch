.globl main
main:
    addi sp,sp,-56
    sd ra,0(sp)
    sd s0,8(sp)
    sd s1,16(sp)
    sd s2,24(sp)
    sd s3,32(sp)
    sd s4,40(sp)
    sd s5,48(sp)

    addi s0,a0,0        # s0 = argc
    addi s1,a1,0        # s1 = argv
    addi s0,s0,-1       # s0 = n

    slli a0,s0,2
    call malloc
    addi s2,a0,0        # s2 = input array

    slli a0,s0,2
    call malloc
    addi s3,a0,0        # s3 = output array

    slli a0,s0,2
    call malloc
    addi s4,a0,0        # s4 = stack array

    addi s5,x0,0        # s5 = loop counter (was t0, now callee-saved)
fill_loop:
    bge s5,s0,fill_done
    addi t1,s5,1
    slli t1,t1,3
    add t1,s1,t1
    ld a0,0(t1)
    call atoi
    slli t1,s5,2
    add t1,s2,t1
    sw a0,0(t1)
    addi s5,s5,1
    jal x0,fill_loop
fill_done:

    addi t0,s0,-1       # i = n-1
    addi t1,x0,-1       # stack top = -1

main_loop:
    blt t0,x0,print

while_loop:
    blt t1,x0,while_done
    slli t2,t1,2
    add t2,s4,t2
    lw t3,0(t2)         # t3 = stack top index
    slli t4,t3,2
    add t4,s2,t4
    lw t4,0(t4)         # t4 = value at stack top index
    slli t5,t0,2
    add t5,s2,t5
    lw t5,0(t5)         # t5 = arr[i]
    bgt t4,t5,while_done
    addi t1,t1,-1
    jal x0,while_loop

while_done:
    slli t2,t0,2
    add t2,s3,t2
    blt t1,x0,store_neg1
    slli t3,t1,2
    add t3,s4,t3
    lw t3,0(t3)
    sw t3,0(t2)
    jal x0,push_idx

store_neg1:
    addi t3,x0,-1
    sw t3,0(t2)

push_idx:
    addi t1,t1,1
    slli t3,t1,2
    add t3,s4,t3
    sw t0,0(t3)
    addi t0,t0,-1
    jal x0,main_loop

print:
    addi s1,s3,0        # s1 = output array pointer
    addi s2,x0,0        # s2 = counter

print_loop:
    bge s2,s0,exit
    lw a1,0(s1)
    la a0,fmt
    call printf
    addi s2,s2,1
    addi s1,s1,4
    jal x0,print_loop

exit:
    la a0,newline
    call printf
    ld ra,0(sp)
    ld s0,8(sp)
    ld s1,16(sp)
    ld s2,24(sp)
    ld s3,32(sp)
    ld s4,40(sp)
    ld s5,48(sp)
    addi sp,sp,56
    jalr x0,0(ra)

.data
fmt: .asciz "%d "
newline: .asciz "\n"
