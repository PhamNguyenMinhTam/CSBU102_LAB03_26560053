# ============================================================
# University of Information Technology - VNU-HCM
# Course     : CSBU102 - Computer Systems
# Lab        : LAB 03 - Leaf Procedures
# Experiment : 2 - Arguments and Return Values
# Full name  : Pham Nguyen Minh Tam
# Student ID : 26560053
# Class      : KHBC-2026
# Date       : 18/11/2026
# File       : Lab03_26560053_TN2.asm
# Purpose    : Read an integer and clamp it to the range 0 through 100.
# ============================================================
#
# REGISTER PLAN
# $a0-$a2 hold procedure arguments. $a0 also holds the integer to print.
# $v0 holds the input, procedure result, or syscall service.
# $t0 holds signed comparison results. $ra holds the return address.
# No saved or stack registers are used.
# ============================================================

.text
.globl main
main:
    # STEP 2.2 - CLAMP (LISTING 3)
    li    $v0, 5
    syscall
    move  $a0, $v0
    li    $a1, 0
    li    $a2, 100
    jal   clamp
    nop
    move  $a0, $v0             # Copy the result before setting the syscall service.
    li    $v0, 1
    syscall
    li    $v0, 10
    syscall

# STEP 2.1 - MAX2 (LISTING 2)
# Examples: max2(15, 42) = 42; max2(-7, -3) = -3.
# Copy the result out of $v0 before loading a syscall service into $v0.
# Arguments: $a0 first integer, $a1 second integer.
# Returns $v0 = larger integer. Clobbers $t0.
max2:
    slt   $t0, $a0, $a1
    bne   $t0, $zero, max2_second
    nop
    move  $v0, $a0
    jr    $ra
    nop
max2_second:
    move  $v0, $a1
    jr    $ra
    nop

# STEP 2.2 - CLAMP PROCEDURE
# Arguments: $a0 input, $a1 lower bound, $a2 upper bound.
# Returns $v0 = clamped input. Clobbers $t0.
clamp:
    slt   $t0, $a0, $a1
    bne   $t0, $zero, clamp_low
    nop
    slt   $t0, $a2, $a0
    bne   $t0, $zero, clamp_high
    nop
    move  $v0, $a0
    jr    $ra
    nop
clamp_low:
    move  $v0, $a1
    jr    $ra
    nop
clamp_high:
    move  $v0, $a2
    jr    $ra
    nop
