.globl main

main:
addi sp,sp,-56 
sd ra,0(sp)
sd s0,8(sp)
sd s1,16(sp)
sd s2,24(sp)
sd s3,32(sp)
sd s4,40(sp)
sd s5,48(sp)    #saving the value of the return address and saved register in the stack so that data doesnt lost

addi s0,a0,0   #s0=argc
addi s1,a1,0   #s1=argv
addi s0,s0,-1  #s0=n subtracting 1 as the first argument is the name of the file

slli a0,s0,2    #multiplying by 2^2=4 because integer occupies 4 bytes
call malloc
addi s2,a0,0   #s2=input array

slli a0,s0,2   #multiplying by 2^2=4 because integer occupies 4 bytes
call malloc
addi s3,a0,0  #s3=output array

slli a0,s0,2   #multiplying by 2^2=4 because integer occupies 4 bytes
call malloc
addi s4,a0,0   #s4=stack 

addi s5,x0,0    #s5=loop counter(i)
fill_loop:
bge s5,s0,fill_done   #loop is run till the i<n if i>=n then break the loop
addi t1,s5,1    #t1=i+1 skipping the first index as it is file name
slli t1,t1,3    #multiplying by 2^3=8 because each argument is stored as a string and each string is stored as a pointer which occupies 8 bytes
add t1,s1,t1    #adding it in base address to get the address of the i+1 th argument
ld a0,0(t1)
call atoi
slli t1,s5,2    #multiplying by 2^2=4 because integer occupies 4 bytes
add t1,s2,t1    #adding it in base address to get the address of the i th input
sw a0,0(t1)     #storing the value of the i th input
addi s5,s5,1    #incrementing the loop counter
jal x0,fill_loop

fill_done:

addi t0,s0,-1   #i=n-1 starting the loop from the back as mentioned in the approach
addi t1,x0,-1   #stack top=-1

main_loop:
blt t0,x0,print   #when i become less than 0 then break the loop and jump to the print

while_loop:
blt t1,x0,while_done   #if the stack is empty then break the loop and jump to the while_done
slli t2,t1,2    #multiplying by 2^2=4 because integer occupies 4 bytes
add t2,s4,t2    #adding it in base address to get the address of the stack top
lw t3,0(t2)    #t3=index at stack top
slli t4,t3,2    #multiplying by 2^2=4 because integer occupies 4 bytes
add t4,s2,t4    #adding it in base address to get the address corresponding to stack top in input array
lw t4,0(t4)    #t4=value at stack top index
slli t5,t0,2    #multiplying by 2^2=4 because integer occupies 4 bytes
add t5,s2,t5    #adding it in base address to get the address of the i th input
lw t5,0(t5)    #t5=arr[i]
bgt t4,t5,while_done   #if the value at stack top index is greater than the value at i th input then break the loop and jump to the while_done
addi t1,t1,-1   #decrementing the stack top
jal x0,while_loop

while_done:
slli t2,t0,2
add t2,s3,t2    #accessing the address of i th value of the output array 
blt t1,x0,store_neg1    #if stack is empty then stores -1 in the output array
slli t3,t1,2
add t3,s4,t3
lw t3,0(t3)
sw t3,0(t2)     #stores the index at stack top in the output array
jal x0,push_idx   #now pushing the curr index i in the stack

store_neg1:
addi t3,x0,-1
sw t3,0(t2)     #stores -1 in the output array

push_idx:
addi t1,t1,1   #inc the stack pointer
slli t3,t1,2
add t3,s4,t3
sw t0,0(t3)   #pushing the curr index i in the stack
addi t0,t0,-1  #decrementing the loop counter
jal x0,main_loop

print:
addi s1,s3,0  #s1=output array pointer
addi s2,x0,0  #s2=counter(i)
addi s0,s0,-1

print_loop:
bge s2,s0,exit   #if i>=n then exit
lw a1,0(s1)
la a0,fmt
call printf
addi s2,s2,1
addi s1,s1,4
jal x0,print_loop

exit:
lw a1,0(s1)
la a0,fmt_last
call printf

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
fmt_last: .asciz "%d"
