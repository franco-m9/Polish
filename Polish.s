# Franco Marcoccia - 6/12/2018
# Polish.s - polish sequence that produces the next number of the sequence
# Register use:
#	$s0 for preserving the value of $a0 aka the number the Polish function is on
#	$s1 for the 16 sequence counter
#	$v0 for return value of Polish
#	$a0 for Polish parameter and other calls
#	$t1, $t2 to store the value 10 & 0 for div/rem
#	$t0 to store other calculations

# insert your terms procedure and your Polish function here
terms:	addi	$sp, $sp, -12		# save registers on stack
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	move	$s0, $a0		# save the value of $a0 before used elsewhere

	la	$a0, numbs
	li	$v0, 4			# print the first text needed
	syscall

	li	$s1, 16

loop2:	move	$a0, $s0		# loop to run 16 times	
	
	li	$v0, 1			# displays original number
	syscall

	addi	$s1, $s1, -1		# decrements counter
	beq	$s1, $zero, done	# once counter is 0, branch

	la	$a0, space		# prints space after numbers
	li	$v0, 4
	syscall

	move	$a0, $s0		# moves value into parameter for Polish
	jal	Polish			# jump and link to polish function

	move	$s0, $v0		# value Polish returned stored
	j	loop2			# loops until branch

done:	la	$a0, endl		# displays extra endline needed
	lw	$s0, 0($sp)		# restores values of stack
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12

	jr	$ra			# returns to original call

Polish:	li	$t1, 10			# gives value 10 for calc
	li	$t2, 0			# gives initial value of 0 for calc

loop3:	rem	$t0, $a0, $t1		
	mul	$t0, $t0, $t0		# multiplies value by itself
	div	$a0, $a0, $t1		# discards remainder
	add	$t2, $t2, $t0		# adds into following number

	move	$v0, $t2		# stores value into value return
	bne	$a0, $zero, loop3	# branches if #$a0 is not 0

	jr	$ra			# returns to original call

# Driver program provided by Stephen P. Leach -- written 11/12/17

main:	la	$a0, intro	# print intro
	li	$v0, 4
	syscall

loop:	la	$a0, req	# request value of n
	li	$v0, 4
	syscall

	li	$v0, 5		# read value of n
	syscall

	ble	$v0, $zero, out	# if n is not positive, exit

	move	$a0, $v0	# set parameter for terms procedure

	jal	terms		# call terms procedure

	j	loop		# branch back for next value of n

out:	la	$a0, adios	# display closing
	li	$v0, 4
	syscall

	li	$v0, 10		# exit from the program
	syscall

	.data
intro:	.asciiz	"Welcome to the Polish sequence tester!"
req:	.asciiz	"\nEnter an integer (zero or negative to exit): "
adios:	.asciiz	"Come back soon!\n"
numbs:	.asciiz "First 16 terms: "
space:	.asciiz " "
endl:	.asciiz "\n"
