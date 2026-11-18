# ============================================================
# University of Information Technology - VNU-HCM
# Course     : CSBU102 - Computer Systems
# Lab        : LAB 03 - Leaf Procedures
# Experiment : 1 - Calling and Returning (jal and jr)
# Full name  : Pham Nguyen Minh Tam
# Student ID : 26560053
# Class      : KHBC-2026
# Date       : 18/11/2026
# File       : Lab03_26560053_TN1.asm
# Purpose    : Print a score report using leaf procedures.
# ============================================================
#
# REGISTER PLAN
# $a0 holds the string address and $v0 holds the syscall service.
# $ra holds the return address. No temporary, saved, or stack registers are used.
# ============================================================

.data
title:    .asciiz "SCORE REPORT\n"
endMsg:   .asciiz "END\n"
line:     .asciiz "----------\n"
starLine: .asciiz "**********\n"

.text
.globl main

# STEP 1.1 - CALLING A PROCEDURE (LISTING 1)
# The call to sep in main demonstrates jal and jr.

# STEP 1.2 - CONTROLLED EXPERIMENTS
# j sep transfers control without setting $ra. jal sep sets $ra.
# Removing jr $ra causes execution to fall through into following code.
# A valid $ra lets execution resume in the caller after the call.

# STEP 1.3 - YOUR OWN PROCEDURE
main:
    jal   stars
    nop
    la    $a0, title
    li    $v0, 4
    syscall
    jal   sep
    nop
    la    $a0, endMsg
    li    $v0, 4
    syscall
    jal   stars
    nop
    li    $v0, 10
    syscall

# Arguments: none. Returns no value. Clobbers $a0 and $v0.
sep:
    la    $a0, line
    li    $v0, 4
    syscall
    jr    $ra
    nop

# Arguments: none. Returns no value. Clobbers $a0 and $v0.
stars:
    la    $a0, starLine
    li    $v0, 4
    syscall
    jr    $ra
    nop
