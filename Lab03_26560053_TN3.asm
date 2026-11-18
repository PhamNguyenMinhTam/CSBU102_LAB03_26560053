# ============================================================
# University of Information Technology - VNU-HCM
# Course     : CSBU102 - Computer Systems
# Lab        : LAB 03 - Leaf Procedures
# Experiment : 3 - Procedures on Arrays - Gradebook Library
# Full name  : Pham Nguyen Minh Tam
# Student ID : 26560053
# Class      : KHBC-2026
# Date       : 18/11/2026
# File       : Lab03_26560053_TN3.asm
# Purpose    : Print grade totals and passing counts for two classes.
# ============================================================
#
# REGISTER PLAN
# $a0 holds an array or label address, or a syscall print argument.
# $a1 holds an array length or value to print. $a2 holds the passing mark.
# $v0 holds a sum, a passing count, or a syscall service.
# $t0 walks the array, $t1 counts remaining elements, $t2 holds a grade,
# and $t3 holds the passing-mark comparison. $ra holds the return address.
# No saved or stack registers are used.
# ============================================================

.eqv PASS_MARK 67

.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
totalA:  .asciiz "Class A total: "
totalB:  .asciiz "Class B total: "
passedA: .asciiz "Class A passed: "
passedB: .asciiz "Class B passed: "

.text
.globl main
main:
    # STEP 3.1 - SUM BOTH ARRAYS
    la    $a0, classA
    li    $a1, 10
    jal   sum_array
    nop
    move  $a1, $v0
    la    $a0, totalA
    jal   show
    nop

    la    $a0, classB
    li    $a1, 8
    jal   sum_array
    nop
    move  $a1, $v0
    la    $a0, totalB
    jal   show
    nop

    # STEP 3.3 - STUDENT-SPECIFIC PASSING MARK
    # The last digit is 3, so M = 55 + 4 * 3 = 67.
    la    $a0, classA
    li    $a1, 10
    li    $a2, PASS_MARK
    jal   count_pass
    nop
    move  $a1, $v0
    la    $a0, passedA
    jal   show
    nop

    la    $a0, classB
    li    $a1, 8
    li    $a2, PASS_MARK
    jal   count_pass
    nop
    move  $a1, $v0
    la    $a0, passedB
    jal   show
    nop

    li    $v0, 10
    syscall

# STEP 3.1 - SUM_ARRAY
# Arguments: $a0 array address, $a1 element count.
# Returns $v0 = sum. Clobbers $t0-$t2.
sum_array:
    move  $v0, $zero
    move  $t0, $a0
    move  $t1, $a1
sum_loop:
    beq   $t1, $zero, sum_done
    nop
    lw    $t2, 0($t0)
    addu  $v0, $v0, $t2
    addiu $t0, $t0, 4
    addiu $t1, $t1, -1
    j     sum_loop
    nop
sum_done:
    jr    $ra
    nop

# STEP 3.2 - COUNT_PASS
# With a passing mark of 50, Class A has 8 passes and Class B has 6.
# Arguments: $a0 array address, $a1 element count, $a2 passing mark.
# Returns $v0 = number of grades at or above the mark. Clobbers $t0-$t3.
count_pass:
    move  $v0, $zero
    move  $t0, $a0
    move  $t1, $a1
count_loop:
    beq   $t1, $zero, count_done
    nop
    lw    $t2, 0($t0)
    slt   $t3, $t2, $a2
    bne   $t3, $zero, count_next
    nop
    addiu $v0, $v0, 1
count_next:
    addiu $t0, $t0, 4
    addiu $t1, $t1, -1
    j     count_loop
    nop
count_done:
    jr    $ra
    nop

# Arguments: $a0 label address, $a1 integer. Returns no value.
# Clobbers $a0 and $v0.
show:
    li    $v0, 4
    syscall
    move  $a0, $a1
    li    $v0, 1
    syscall
    li    $a0, 10
    li    $v0, 11
    syscall
    jr    $ra
    nop
