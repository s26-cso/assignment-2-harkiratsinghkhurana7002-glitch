.globl main

main:
addi sp,sp,-48
sd ra,0(sp)
sd s0,8(sp)
sd s1,16(sp)
sd s2,24(sp)
sd s3,32(sp)
sd s4,40(sp)

addi s0,a0,0
addi s1,a1,0

addi t0,s0,-1

slli a0,t0,2
call malloc
addi s2,a0,0

slli a0,t0,2
call malloc
addi s3,a0,0

slli a0,t0,2
call malloc
addi s4,a0,0

addi t1,x0,0
addi t2,s1,8
addi t3,s2,0

fill_loop:
bge t1,t0,fill_done

ld a0,0(t2)
call atoi

sw a0,0(t3)

addi t1,t1,1
addi t2,t2,8
addi t3,t3,4
jal x0,fill_loop

fill_done:

addi t1,x0,-1
addi t3,t0,-1

slli t4,t3,2
add t6,s2,t4
add t8,s3,t4

loop:
blt t3,x0,done

while:
blt t1,x0,while_end

slli t4,t1,2
add t5,s4,t4
lw t2,0(t5)

slli t2,t2,2
add t2,s2,t2
lw t7,0(t2)

lw t9,0(t6)

bgt t7,t9,while_end

addi t1,t1,-1
jal x0,while

while_end:

blt t1,x0,no_ans

slli t4,t1,2
add t4,s4,t4
lw t5,0(t4)

slli t5,t5,2
add t5,s2,t5
lw t7,0(t5)

sw t7,0(t8)
jal x0,push

no_ans:
addi t7,x0,-1
sw t7,0(t8)

push:
addi t1,t1,1
slli t4,t1,2
add t4,s4,t4
sw t3,0(t4)

addi t3,t3,-1
addi t8,t8,-4
addi t6,t6,-4
jal x0,loop

done:

addi t0,x0,0
addi t2,s0,-1
addi t4,s3,0

print_loop:
bge t0,t2,exit

lw a1,0(t4)
la a0,fmt
call printf

addi t0,t0,1
addi t4,t4,4
jal x0,print_loop

exit:
ld ra,0(sp)
ld s0,8(sp)
ld s1,16(sp)
ld s2,24(sp)
ld s3,32(sp)
ld s4,40(sp)
addi sp,sp,48
jalr x0,0(ra)

.data
fmt: .asciz "%d "