.globl main
main:
    addi sp,sp,-48
    sd ra,0(sp)
    sd s0,8(sp)
    sd s1,16(sp)
    sd s2,24(sp)
    sd s3,32(sp)
    sd s4,40(sp)

    # Open file
    la a0,filename
    la a1,mode
    call fopen
    beq a0,x0,fail

    addi s0,a0,0        # s0 = file pointer (callee-saved)

    # Seek to end to get file size
    addi a0,s0,0
    addi a1,x0,0
    addi a2,x0,2        # SEEK_END
    call fseek

    # Get file size
    addi a0,s0,0
    call ftell
    addi s1,a0,0        # s1 = file size (callee-saved)

    # Two-pointer palindrome check
    addi s2,x0,0        # s2 = left index (callee-saved)
    addi s3,s1,-1       # s3 = right index (callee-saved)

loop:
    bge s2,s3,yes

    # Read char at left index
    addi a0,s0,0
    addi a1,s2,0
    addi a2,x0,0        # SEEK_SET
    call fseek

    addi a0,s0,0
    call fgetc
    addi s4,a0,0        # s4 = left char (callee-saved)

    # Read char at right index
    addi a0,s0,0
    addi a1,s3,0
    addi a2,x0,0        # SEEK_SET
    call fseek

    addi a0,s0,0
    call fgetc
    # a0 = right char

    bne s4,a0,no

    addi s2,s2,1
    addi s3,s3,-1
    j loop

yes:
    la a0,yes_string
    call printf
    j cleanup

no:
    la a0,no_string
    call printf

cleanup:
    addi a0,s0,0
    call fclose

    ld ra,0(sp)
    ld s0,8(sp)
    ld s1,16(sp)
    ld s2,24(sp)
    ld s3,32(sp)
    ld s4,40(sp)
    addi sp,sp,48
    addi a0,x0,0
    jalr x0,0(ra)

fail:
    la a0,fail_string
    call printf
    ld ra,0(sp)
    ld s0,8(sp)
    ld s1,16(sp)
    ld s2,24(sp)
    ld s3,32(sp)
    ld s4,40(sp)
    addi sp,sp,48
    addi a0,x0,1
    jalr x0,0(ra)



.data
filename: .asciz "input.txt"
mode: .asciz "r"
yes_string: .asciz "Yes\n"
no_string: .asciz "No\n"
fail_string: .asciz "Error: cannot open input.txt\n"