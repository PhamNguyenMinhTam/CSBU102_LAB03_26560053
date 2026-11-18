# ============================================================
# University of Information Technology - VNU-HCM
# Course     : CSBU102 - Computer Systems
# Lab        : LAB 03 - Leaf Procedures
# Experiment : 4 - Registers a Procedure Must Not Change
# Full name  : Pham Nguyen Minh Tam
# Student ID : 26560053
# Class      : KHBC-2026
# Date       : 18/11/2026
# File       : Lab03_26560053_TN4.asm
# Purpose    : Preserve the caller's class number while summing three integers.
# ============================================================
#
# REGISTER PLAN
# $a0-$a2 hold the three addends. $a0 also holds a print argument.
# $v0 holds the sum or syscall service. $t0 keeps the sum while printing.
# $s0 holds the class number in main and the partial sum inside sum3.
# $sp moves down four bytes to save $s0 and back up after restoring it.
# $ra holds the return address.
# ============================================================

.text
.globl main

# STEP 4.1 - FIND THE ERROR (LISTING 6)
# main keeps class number 2 in $s0. The original sum3 overwrites $s0
# with a partial sum of 15, causing main to print 15 24.

# STEP 4.2 - TWO WAYS TO FIX IT
# Fix A: Use caller-saved $t0 for the partial sum with no stack operations.
# Fix B (implemented): Save $s0 on the stack, then restore $s0 and $sp.
main:
    li    $s0, 2
    li    $a0, 7
    li    $a1, 8
    li    $a2, 9
    jal   sum3
    nop
    move  $t0, $v0
    move  $a0, $s0
    li    $v0, 1
    syscall
    li    $a0, 32
    li    $v0, 11
    syscall
    move  $a0, $t0
    li    $v0, 1
    syscall
    li    $a0, 10
    li    $v0, 11
    syscall
    li    $v0, 10
    syscall

# Arguments: $a0-$a2 three integers. Returns $v0 = their sum.
# Preserves $s0 and $sp. Writes one word in its stack frame.
sum3:
    addi  $sp, $sp, -4
    sw    $s0, 0($sp)

    add   $s0, $a0, $a1
    add   $v0, $s0, $a2

    lw    $s0, 0($sp)
    addi  $sp, $sp, 4
    jr    $ra
    nop
