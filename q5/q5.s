.globl main
main:
addi sp,sp,-16
sd ra,0(sp)


la a0,filename
la a1,mode
call fopen
beq a0,x0,fail

addi t4,a0,0    


addi a0,t4,0
addi a1,x0,0
addi a2,x0,2
call fseek


addi a0,t4,0
call ftell
addi t5,a0,0    

addi t0,x0,0    
addi t1,t5,-1    
loop:
bge t0,t1,yes


addi a0,t4,0
addi a1,t0,0
addi a2,x0,0
call fseek

addi a0,t4,0
call fgetc
addi t2,a0,0    


addi a0,t4,0
addi a1,t1,0
addi a2,x0,0
call fseek

addi a0,t4,0
call fgetc
addi t3,a0,0    

bne t2,t3,no

addi t0,t0,1
addi t1,t1,-1
j loop

yes:
la a0,yes_string
call printf
j end

no:
la a0,no_string
call printf

end:
ld ra,0(sp)
addi sp,sp,16
jalr x0,0(ra)

fail:
jalr x0,0(ra)



.data
filename: .asciz "input.txt"
mode: .asciz "r"
yes_string: .asciz "Yes\n"
no_string: .asciz "No\n"