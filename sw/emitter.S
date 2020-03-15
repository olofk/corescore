/*
* Read packet from base and bitbang on UART
*
*/
#define GPIO_ADDR 0x40000000
#define AXIS_ADDR 0xC0000000
#define HALT_ADDR 0x90000000

	/*
	a0 = Console address
	a1 = FIFO address
	t0 = Character to write
	*/

.globl _start
_start:
	/* Load gpio address to a0 */
	li	a0, GPIO_ADDR

	/* Set GPIO high initially */
	addi	t0, zero, 1
	sb	t0, 0(a0)

	/* Load axis address to a0 */
	li	a1, AXIS_ADDR

	/* Check for valid data */
next:	lb	t1, 1(a1)
	andi	t2, t1, 2
	beqz	t2, next

	/* Read byte from axis */
	lbu	t0, 0(a1)

	/* Bitbanged UART loop */
	ori	t0, t0, 0x100
	slli	t0, t0, 1
1:	sb	t0, 0(a0)
	srli	t0, t0, 1
	nop
	nop
	bnez	t0, 1b

	j next
