.text

# Decodes a quadtree to the original matrix
#
# Arguments:
#     quadtree (qNode*)
#     matrix (void*)
#     matrix_width (int)
#
# Recall that quadtree representation uses the following format:
#     struct qNode {
#         int leaf;
#         int size;
#         int x;
#         int y;
#         int gray_value;
#         qNode *child_NW, *child_NE, *child_SE, *child_SW;
#     }

quad2matrix:
    	lw $t0 0($a0) # $t0 = quadtree->leaf
    	beq $t0 $zero Else # if quadtree->leaf = 0, go to Else
    	lw $t1 4($a0) # $t1 = quadtree->size
	li $t2 0 # i = 0

For1:
    	slt $t3 $t2 $t1	# i < size
    	beq $t3 $zero Return # if i >= size, return
	li $t4 0 #j = 0
For2:	
    	slt $t5 $t4 $t1	# j < size
    	beq $t5 $zero IncI
    	lw $t6 12($a0) # $t6 = y
    	lw $t7 8($a0) # $t7 = x
    	addu $t6 $t6 $t2 # $t6 = y + i
    	addu $t7 $t7 $t4 # $t7 = x + j
    	multu $t6 $a2 # (y + i) * image_width
    	mflo $t6
    	addu $t7 $t7 $t6 # $t7 = (x+j) + (y+i) * image_width ; index
    	addu $t7 $t7 $a1 # $t7 = address of matrix[index]
    	lw $t6 16($a0) # $t6 = gray_value
    	sb $t6 0($t7) # matrix[index] = gray_value 
    	addiu $t4 $t4 1	# j++
    	j For2
        
IncI:        
	addiu $t2 $t2 1 # i++ 
	j For1 

Else: 	
	addi $sp $sp -8
	sw $a0 0($sp) #save root
	sw $ra 4($sp)
	
	lw $t0 20($a0) # $t0 = child_NW
	move $a0 $t0		
	jal quad2matrix
	
	lw $t0 24($a0) # $t0 = child_NE
	move $a0 $t0		
	jal quad2matrix
						
	lw $t0 28($a0) # $t0 = child_SE
	move $a0 $t0		
	jal quad2matrix

	lw $t0 32($a0) # $t0 = child_SW
	move $a0 $t0		
	jal quad2matrix
	
	lw $ra 4($sp)
	addi $sp $sp 8
Return: 
	lw $a0 0($sp)
	jr $ra
