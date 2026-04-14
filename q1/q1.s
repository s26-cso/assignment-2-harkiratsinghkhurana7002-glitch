.globl make_node
.globl insert
.globl get
.globl getAtMost

make_node:
addi sp,sp,-16
sd ra,0(sp)
sd s0,8(sp)    #saving the value of the return address and saved register in the stack so that data doesnt lost

addi s0,a0,0     #saving the value of a0 in s0
addi a0,x0,24    #storing 24 in a0 for allocating 24 bytes
call malloc    #allocating 24 bytes

sw s0,0(a0)    #storing the value of s0 in a0
sd x0,8(a0)    #storing Null in left pointer
sd x0,16(a0)   #storing Null in right pointer

ld ra,0(sp)    #restoring the values from the stack
ld s0,8(sp)
addi sp,sp,16
jalr x0,0(ra)



insert:
addi sp,sp,-16    #saving the value of the return address and saved register in the stack so that data doesnt lost
sd s0,8(sp)
sd ra,0(sp)

addi s0,a0,0 
beq a0,x0,insert_base    #if the value of a0 is Null then jump to insert_base

lw t0,0(s0) 
bgt a1,t0,insert_right    #if the value of a1 is greater than t0 then jump to insert_right other wise insert on the left side

ld a0,8(s0) 
jal ra,insert
sd a0,8(s0)     #storing the returned pointer from the recusrsive on the left pointer on the root
addi a0,s0,0    #storing the root agin in a0 for returning
jal x0,insert_end

insert_right:
ld a0,16(s0)
jal ra,insert
sd a0,16(s0)   #storing the returned pointer from the recusrsive on the right pointer on the root
addi a0,s0,0   #storing the root agin in a0 for returning
jal x0,insert_end

insert_base:
addi a0,a1,0    #since the current node is NULL now make a new node with the value stored in a1 and return it as a root
jal ra,make_node

insert_end:
ld ra,0(sp)    #restoring the values from the stack
ld s0,8(sp)
addi sp,sp,16
    jalr x0,0(ra)



get:
addi sp,sp,-16
sd ra,0(sp)

beq a0,x0,get_not_found    #if the root node is NULL then jump to the get_not_found i.e. no node with the given value 

lw t0,0(a0)
beq t0,a1,get_found    #root->val==val given

bgt a1,t0,get_right    #if the value of given val is greater than root->val then jump to the get_right other wise jump to the get_left

ld a0,8(a0)    #exploring the val in the left subtree
jal ra,get
jal x0,get_end

get_right:
ld a0,16(a0)    #exploring the val in the right subtree
jal ra,get
jal x0,get_end

get_found:
jal x0,get_end    #value found.Hence returning the root

get_not_found:
addi a0,x0,0    #value not found.Hence returning Null

get_end:
ld ra,0(sp)    #restoring the values from the stack
addi sp,sp,16
jalr x0,0(ra)



getAtMost:
addi t0,x0,-1    #initializing ans to -1 as mentioned in the question if no node is found return -1

getAtMost_loop:
beq a1,x0,getAtMost_end    #if the root node is NULL then jump to the getAtMost_end

lw t1,0(a1)
bgt t1,a0,getAtMost_left    #if the root->val>given val then non need to update the ans 

addi t0,t1,0    #if the root->val<=given val then update the ans and move to the rightsubtree to find greater val that can be ans
ld a1,16(a1)
jal x0,getAtMost_loop

getAtMost_left:
ld a1,8(a1)    #if the root->val>given val then move to the leftsubtree to find smaller val that can be ans
jal x0,getAtMost_loop

getAtMost_end:
addi a0,t0,0    #returning the ans
jalr x0,0(ra)