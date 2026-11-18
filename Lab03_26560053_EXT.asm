# ============================================================
# University of Information Technology - VNU-HCM
# Course     : CSBU102 - Computer Systems
# Lab        : LAB 03 - Leaf Procedures
# Experiment : Extension - Two Results From One Call
# Full name  : Pham Nguyen Minh Tam
# Student ID : 26560053
# Class      : KHBC-2026
# Date       : 18/11/2026
# File       : Lab03_26560053_EXT.asm
# Purpose    : Print the minimum and maximum grades for two classes.
# ============================================================
#
# REGISTER PLAN
# $a0 holds an array or label address, or a syscall print argument.
# $a1 holds an array length or a value to print.
# $v0 and $v1 return the minimum and maximum. $v0 also holds syscall services.
# $t0 walks the array, $t1 counts remaining elements, $t2 holds a grade,
# and $t3 holds a comparison. $t4 keeps the maximum across the first show call.
# $ra holds the return address. No saved or stack registers are used.
# ============================================================

.data
classA: .word 72, 55, 90, 48, 63, 85, 39, 77, 60, 94
classB: .word 45, 81, 66, 50, 92, 38, 70, 59
minA: .asciiz "Class A min: "
maxA: .asciiz "Class A max: "
minB: .asciiz "Class B min: "
maxB: .asciiz "Class B max: "

.text
.globl main
main:
    la    $a0, classA
    li    $a1, 10
    jal   min_max
    nop
    move  $t4, $v1             # show preserves $t4.
    move  $a1, $v0             # Pass the minimum before show changes $v0.
    la    $a0, minA
    jal   show
    nop
    move  $a1, $t4
    la    $a0, maxA
    jal   show
    nop

    la    $a0, classB
    li    $a1, 8
    jal   min_max
    nop
    move  $t4, $v1             # show preserves $t4.
    move  $a1, $v0             # Pass the minimum before show changes $v0.
    la    $a0, minB
    jal   show
    nop
    move  $a1, $t4
    la    $a0, maxB
    jal   show
    nop

    li    $v0, 10
    syscall

# Arguments: $a0 array address, $a1 positive element count.
# Returns $v0 = minimum and $v1 = maximum. Clobbers $t0-$t3.
min_max:
    lw    $v0, 0($a0)          # Seed both results with the first grade.
    move  $v1, $v0
    addiu $t0, $a0, 4
    addiu $t1, $a1, -1
min_max_loop:
    beq   $t1, $zero, min_max_done
    nop
    lw    $t2, 0($t0)
    slt   $t3, $t2, $v0
    beq   $t3, $zero, check_max
    nop
    move  $v0, $t2
check_max:
    slt   $t3, $v1, $t2
    beq   $t3, $zero, min_max_next
    nop
    move  $v1, $t2
min_max_next:
    addiu $t0, $t0, 4
    addiu $t1, $t1, -1
    j     min_max_loop
    nop
min_max_done:
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
