make_node:
addi sp,sp,-16
sd ra,0(sp)
sd s0,8(sp)

addi s0,a0,0
li a0,24
call malloc

sw s0,0(a0)
sd x0,8(a0)
sd x0,16(a0)

ld ra,0(sp)
ld s0,8(sp)
addi sp,sp,16
jalr x0,0(ra)



insert:
addi sp,sp,-16
sd s0,8(sp)
sd ra,0(sp)

addi s0,a0,0
beq a0,x0,base

lw t0,0(s0)
bgt a1,t0,right

ld a0,8(s0)
jal ra,insert
sd a0,8(s0)
addi a0,s0,0
jal x0,end

right:
ld a0,16(s0)
jal ra,insert
sd a0,16(s0)
addi a0,s0,0
jal x0,end

base:
addi a0,a1,0
jal ra,make_node

end:
ld ra,0(sp)
ld s0,8(sp)
addi sp,sp,16
jalr x0,0(ra)



get:
addi sp,sp,-16
sd ra,0(sp)

beq a0,x0,base

lw t0,0(a0)
beq t0,a1,found

bgt a1,t0,right

ld a0,8(a0)
jal ra,get
jal x0,end

right:
ld a0,16(a0)
jal ra,get
jal x0,end

found:
jal x0,end

base:
addi a0,x0,0

end:
ld ra,0(sp)
addi sp,sp,16
jalr x0,0(ra)



getAtMost:
addi t0,x0,-1

loop:
beq a1,x0,end

lw t1,0(a1)
bgt t1,a0,left

addi t0,t1,0
ld a1,16(a1)
jal x0,loop

left:
ld a1,8(a1)
jal x0,loop

end:
addi a0,t0,0
jalr x0,0(ra)