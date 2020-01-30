;;; RANDOM.S
;;; Pseudo-random number generator, using a simple
;;; linear feedback shift register
;;; PARAMETERS: none
;;; RETURNS: A - Random number
	
RANDOM:	
	PUSH H
	LXI H,RAND01
	MOV A,M
	PUSH PSW
	RAL A
	ADC A,0H
	XRI 26H
	
	MOV M,A
	POP PSW
	POP H
	RET

RAND01:	DB 93H
