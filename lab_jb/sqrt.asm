.text
	csrrw t0, 0xf00, zero #input
	#li t0, 2
	slli t0, t0, 14
	
	li t4, 0 #guess
	li t1, 256 #step
	li t6, 100000 #scale to generate 5 decimal digits
	
	slli t1, t1, 14
	
sqrt:	
	mul t2, t4, t4
	mulhu t3, t4, t4
	
	srli t2, t2, 14
	slli t3, t3, 18
	or t2, t2, t3
	
	beq t2, t0, load
	
	bgeu t2, t0, skip1
	
	add t4, t4, t1
	jal skip2
	
skip1:					
	sub t4, t4, t1
	mv s0, t4

skip2:
	srli t1, t1, 1
	beq t1, zero, dec
	jal sqrt

load:	li s0, 0		
dec:
	li t0, 100000
	mulhu s1, t4, t0 #whole
	mul s0, t4, t0 #decimal
	slli s1, s1, 18
	srli s0, s0, 14
	or s0, s0, s1
	
	addi t1, s0, 0 #temp
	li t4, 10
	li t5, 0
	li t2, 429496730 #0.1
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3
	
	srli t5, t5, 4
	mul t3, t1, t2 #temp2 = temp%10
	mulhu t1, t1, t2 #temp = temp/10 (whole number)
	mulhu t3, t4, t3
	slli t3, t3, 28
	or t5, t5, t3

	csrrw t0, 0xf02, t5

exit:
