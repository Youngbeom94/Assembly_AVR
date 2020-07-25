﻿#define DELTA	R0
#define ZERO	R1

#define X0		R16
#define X1		R17
#define X2		R18
#define X3		R19
#define X4		R20
#define X5		R21
#define X6		R22
#define X7		R23

#define TMP		R24
#define CTR		R25

.global HIGHT_CTR_Enc
.type HIGHT_CTR_Enc, @function
  
	HIGHT_CTR_Enc:

	PUSH R16
	PUSH R17
	PUSH R18

	MOVW R26, R22		// PT
	LD X0, X+
	LD X1, X+
	LD X2, X+
	LD X3, X+
	LD X4, X+
	LD X5, X+
	LD X6, X+
	LD X7, X+

	MOVW R30, R24		// RK
	
	// 암호화 초기변환
	LDD TMP, Z+0
	ADD X0, TMP
	LDD TMP, Z+1
	EOR X2, TMP
	LDI X4, 0x37

	MOV TMP, X0			// 1라운드 시작
	LSL TMP
	ADC TMP, ZERO
	LSL TMP
	ADC TMP, ZERO		// TMP = X <<< 2
	MOV DELTA, TMP
	SWAP DELTA			// DELTA = X <<< 6
	LSL TMP
	ADC TMP, ZERO		// TMP = X <<< 3
	EOR DELTA, TMP		// DELTA = X <<< 3 ^ X <<< 6
	LSL TMP
	ADC TMP, ZERO		// TMP = X <<< 4
	EOR DELTA, TMP		// DELTA = X <<< 3 ^ X <<< 4 ^ X <<< 6
	LDD TMP, Z+8		// RK 로드
	EOR DELTA, TMP		// DELTA = F1(X) ^ RK
	ADD X1, DELTA		// XX[1] = (XX[1] + (HIGHT_F1[XX[0]] ^ RoundKey[8])) & 0xFF;
	
	MOV TMP, X2	
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LDD TMP, Z+9
	ADD DELTA, TMP
	EOR X3, DELTA		// XX[3] = (XX[3] ^ (HIGHT_F0[XX[2]] + RoundKey[9])) & 0xFF;

	LDI X5, 0x00		// XX[7] = 0x5b;
	
	LDI X7, 0x5b		// XX[5] = 0x00;

	LDI TMP, 0xac
	ADD X0, TMP			// XX[0] = (XX[0] + 0xac) & 0xFF; 2라운드 시작
	
	MOV TMP, X1
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LDD TMP, Z+13
	ADD DELTA, TMP
	EOR X2, DELTA		// XX[2] = (XX[2] ^ (HIGHT_F0[XX[1]] + RoundKey[13])) & 0xFF;

	MOV TMP, X3
	LSL TMP
	ADC TMP, ZERO
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP
	SWAP DELTA
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LDD TMP, Z+14
	EOR DELTA, TMP
	ADD X4, DELTA		// XX[4] = (XX[4] + (HIGHT_F1[XX[3]] ^ RoundKey[14])) & 0xFF;
	
	LDI X6, 0x7e		// XX[6] = 0x7e;
	
	LDI X7, 0x1d		// XX[7] = 0x1d;		3라운드 시작
	
	MOV TMP, X0
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LDD TMP, Z+17
	ADD DELTA, TMP
	EOR X1, DELTA

	MOV TMP, X2
	LSL TMP
	ADC TMP, ZERO
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP
	SWAP DELTA			// 6
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LDD TMP, Z+18
	EOR DELTA, TMP
	ADD X3, DELTA
	
	MOV TMP, X4
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LDD TMP, Z+19
	ADD DELTA, TMP
	EOR X5, DELTA
	
	MOV DELTA, X3
	MOV X3, X0
	MOV X0, X5
	MOV X5, X2
	MOV X2, X7
	MOV X7, X4
	MOV X4, X1
	MOV X1, X6
	MOV X6, DELTA	

	ADIW R30, 20		// RK 포인터 뛰기

	LDI CTR, 29			// 31 라운드 + 사전 연산 1라운드

	STEP1:
	
	MOV TMP, X0
	LSL TMP
	ADC TMP, ZERO
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP
	SWAP DELTA
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LD TMP, Z+
	EOR DELTA, TMP
	ADD X1, DELTA
	
	MOV TMP, X2	
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LD TMP, Z+
	ADD DELTA, TMP
	EOR X3, DELTA

	MOV TMP, X4
	LSL TMP
	ADC TMP, ZERO
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP
	SWAP DELTA
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LD TMP, Z+
	EOR DELTA, TMP
	ADD X5, DELTA
	
	MOV TMP, X6	
	LSL TMP
	ADC TMP, ZERO
	MOV DELTA, TMP	
	LSL TMP
	ADC TMP, ZERO
	EOR DELTA, TMP
	LSL TMP
	ADC TMP, ZERO
	SWAP TMP
	EOR DELTA, TMP
	LD TMP, Z+
	ADD DELTA, TMP
	EOR X7, DELTA

	MOV DELTA, X7
	MOV X7, X6
	MOV X6, X5
	MOV X5, X4
	MOV X4, X3
	MOV X3, X2
	MOV X2, X1
	MOV X1, X0
	MOV X0, DELTA
	
	DEC CTR
	CPSE CTR, ZERO
	RJMP STEP1

	LDI TMP, 136
	SUB R30, TMP
	SBC R31, ZERO

	// 암호화 최종변환
	LDD TMP, Z+4
	ADD X1, TMP
	LDD TMP, Z+5
	EOR X3,TMP
	LDD TMP, Z+6
	ADD X5, TMP
	LDD TMP, Z+7	
	EOR X7, TMP

	ST -X, X0
	ST -X, X7
	ST -X, X6
	ST -X, X5
	ST -X, X4
	ST -X, X3
	ST -X, X2
	ST -X, X1

	POP R18
	POP R17
	POP R16

	RET