.text
addi $r1, $r0, 7
addi $r2, $r0, 11
sub $r2, $r2, $r1 #r2 is 4
mul $r3, $r2, $r2 #r3 is 16
sll $r2, $r2, 2 #r2 is 32
addi $r4, $r0, 2 #r4 is 2
div $r2, $r2, $r3 #r2 is 16
bne $r2, $r3, 1
j 6 #div one more time
addi $r1, $r0, 999 #should get here 