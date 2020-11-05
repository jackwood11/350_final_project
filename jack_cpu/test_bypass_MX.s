.text
add $r0, $r0, $r0
addi $r3, $r0, 100
addi $r2, $r3, 0 #MX_A
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
addi $r1, $r0, 50
add $r4, $r0, $r1 #MX_B
# WAI final reg values:
# $r1 = 50
# $r2 = 100
# $r3 = 100
# $r4 = 50
#reset
add $r1, $r0, $r0
add $r2, $r0, $r0
add $r3, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
addi $r1, $r0, 999
addi $r2, $r0, 1
add $r5, $r0, $r0
add $r5, $r0, $r0
sw $r1, 1000($r3)
add $r5, $r0, $r0
add $r5, $r0, $r0
add $r5, $r0, $r0
add $r3, $r1, $r2
lw $r4, 0($r3)