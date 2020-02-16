#include "header.s"
	* = $8000
start	LDA #%01000
	STA $2000
	LDA #%11110
	STA $2001
