.text
addi $r3, $r0, 100
add $r1, $r0, $r3
add $r0, $r0, $r0 #HAZARD
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
and $r5, $r3, $r0
sub $r2, $r0, $r5 #HAZARD
add $r1, $r0, $r0
add $r1, $r0, $r0
add $r1, $r0, $r0
and $r5, $r3, $r0
sll $r3, $r0, 2 #NO HAZARD