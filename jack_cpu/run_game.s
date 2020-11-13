.text
add $r0, $r0, $r0
add $r0, $r0, $r0
add $r0, $r0, $r0
add $r0, $r0, $r0 #let random number initialize
#initialize display?
bne $r0, $r3, 6    #so long as we haven't received any input ($r3 == 0) keeping checking for some.
add $r0, $r0, $r0 #alternative way to wait on input would be to modify stall logic.
add $r0, $r0, $r0
add $r0, $r0, $r0
add $r0, $r0, $r0 #guard against bypassing issues
j 6

add $r0, $r0, $r0
add $r0, $r0, $r0
add $r0, $r0, $r0

add $r2, $r1, $r0 #put randomly generated number into the $r2 register


add $r0, $r0, $r0
add $r0, $r0, $r0


add $r0, $r0, $r0
bne $r3, $r2, 10 #jump 10 lines if the guess isn't correct.
#You win! Integrate win prompt within processor for (blt & $rd != $r0)
j 100000 #jump to end of program OR game over logic.





blt $r3, $r2, 0 #if guess not less than AND not equal, must be greater than 
# PROMPT down arrow, because blt == false.
# PROMPT up arrow if true. 
j 18 #go back to check guess

