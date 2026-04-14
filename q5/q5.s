.globl main
main:
addi sp,sp,-48
sd ra,0(sp)
sd s0,8(sp)
sd s1,16(sp)
sd s2,24(sp)
sd s3,32(sp)
sd s4,40(sp)  #saving the value of the return address and saved register in the stack so that data doesnt lost

la a0,filename   #loading filename in a0 fopen as first arg
la a1,mode   #loading the mode in a1 for fopen as second arg
call fopen
addi s0,a0,0  #s0=file pointer

addi a0,s0,0   #loading file pointer in a0 for fseek as first arg
addi a1,x0,0  #loading 0 in a1 for fseek as second arg
addi a2,x0,2   #loading 2(SEEK_END) in a2 for fseek as third arg
call fseek

addi a0,s0,0
call ftell
addi s1,a0,0  #s1=file size

addi s2,x0,0  #s2=left index
addi s3,s1,-1  #s3=right index

loop:
bge s2,s3,yes  #if l>=r then the complete doc is scanned and no error is found

addi a0,s0,0  #loading file pointer in a0 for fseek as first arg
addi a1,s2,0  #loading left index in a1 for fseek as second arg
addi a2,x0,0  #loading 0(SEEK_SET) in a2 for fseek as third arg
call fseek  #so now the file pointer is at the left index

addi a0,s0,0
call fgetc 
addi s4,a0,0  #s4=left char

addi a0,s0,0
addi a1,s3,0
addi a2,x0,0  
call fseek  #so now the file pointer is at the right index

addi a0,s0,0
call fgetc  
addi s5,a0,0  #s5=right char

bne s4,a0,no #if left and right char are not equal then not palindrome

addi s2,s2,1  #incrementing left index
addi s3,s3,-1  #decrementing right index
jal x0,loop

yes:
la a0,yes_string
call printf
jal x0,end

no:
la a0,no_string
call printf

end:
addi a0,s0,0
call fclose   #closing the file

ld ra,0(sp)
ld s0,8(sp)
ld s1,16(sp)
ld s2,24(sp)
ld s3,32(sp)
ld s4,40(sp)
addi sp,sp,48
addi a0,x0,1
jalr x0,0(ra)   #restoring the values



.data
filename: .asciz "input.txt"
mode: .asciz "r"
yes_string: .asciz "Yes\n"
no_string: .asciz "No\n"
