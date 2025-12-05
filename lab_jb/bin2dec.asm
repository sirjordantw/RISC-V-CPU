.text
	csrrw t0, 0xf00, zero #value
	addi t1, t0, 0 #temp
	li t4, 10
	li t5, 0
	li, t2, 429496730 #0.1
	
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