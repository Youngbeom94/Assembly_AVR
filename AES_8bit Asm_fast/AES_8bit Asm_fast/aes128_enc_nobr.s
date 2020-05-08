﻿
/*
 * aes128_enc_nobr.s
 *
 * Created: 2020-04-28 오후 1:37:57
 *  Author: 김영범
 */ 
//.arch atmega128
.data

SBOX_TABLE:
.byte	0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76, \
		0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0, \
		0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15, \
		0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75, \
		0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84, \
		0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf, \
		0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8, \
		0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2, \
		0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73, \
		0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb, \
		0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79, \
		0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08, \
		0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a, \
		0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e, \
		0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf, \
		0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16

MIX2_TABLE:
.byte	0xc6,0xf8,0xee,0xf6,0xff,0xd6,0xde,0x91,0x60,0x02,0xce,0x56,0xe7,0xb5,0x4d,0xec, \
		0x8f,0x1f,0x89,0xfa,0xef,0xb2,0x8e,0xfb,0x41,0xb3,0x5f,0x45,0x23,0x53,0xe4,0x9b, \
		0x75,0xe1,0x3d,0x4c,0x6c,0x7e,0xf5,0x83,0x68,0x51,0xd1,0xf9,0xe2,0xab,0x62,0x2a, \
		0x08,0x95,0x46,0x9d,0x30,0x37,0x0a,0x2f,0x0e,0x24,0x1b,0xdf,0xcd,0x4e,0x7f,0xea, \
		0x12,0x1d,0x58,0x34,0x36,0xdc,0xb4,0x5b,0xa4,0x76,0xb7,0x7d,0x52,0xdd,0x5e,0x13, \
		0xa6,0xb9,0x00,0xc1,0x40,0xe3,0x79,0xb6,0xd4,0x8d,0x67,0x72,0x94,0x98,0xb0,0x85, \
		0xbb,0xc5,0x4f,0xed,0x86,0x9a,0x66,0x11,0x8a,0xe9,0x04,0xfe,0xa0,0x78,0x25,0x4b, \
		0xa2,0x5d,0x80,0x05,0x3f,0x21,0x70,0xf1,0x63,0x77,0xaf,0x42,0x20,0xe5,0xfd,0xbf, \
		0x81,0x18,0x26,0xc3,0xbe,0x35,0x88,0x2e,0x93,0x55,0xfc,0x7a,0xc8,0xba,0x32,0xe6, \
		0xc0,0x19,0x9e,0xa3,0x44,0x54,0x3b,0x0b,0x8c,0xc7,0x6b,0x28,0xa7,0xbc,0x16,0xad, \
		0xdb,0x64,0x74,0x14,0x92,0x0c,0x48,0xb8,0x9f,0xbd,0x43,0xc4,0x39,0x31,0xd3,0xf2, \
		0xd5,0x8b,0x6e,0xda,0x01,0xb1,0x9c,0x49,0xd8,0xac,0xf3,0xcf,0xca,0xf4,0x47,0x10, \
		0x6f,0xf0,0x4a,0x5c,0x38,0x57,0x73,0x97,0xcb,0xa1,0xe8,0x3e,0x96,0x61,0x0d,0x0f, \
		0xe0,0x7c,0x71,0xcc,0x90,0x06,0xf7,0x1c,0xc2,0x6a,0xae,0x69,0x17,0x99,0x3a,0x27, \
		0xd9,0xeb,0x2b,0x22,0xd2,0xa9,0x07,0x33,0x2d,0x3c,0x15,0xc9,0x87,0xaa,0x50,0xa5, \
		0x03,0x59,0x09,0x1a,0x65,0xd7,0x84,0xd0,0x82,0x29,0x5a,0x1e,0x7b,0xa8,0x6d,0x2c 

.text


#include "avr-asm-macros.S"
/*
 * param a: r24
 * param b: r22
 * param reducer: r0
 */

.global aes128_enc_nobr
aes128_enc_nobr:

ST00 =	0
ST01 =  1
ST02 =  2
ST03 =  3
ST10 =  4
ST11 =  5
ST12 =  6
ST13 =  7
ST20 =  8
ST21 =  9
ST22 = 10
ST23 = 11
ST30 = 12
ST31 = 13
ST32 = 14
ST33 = 15
M0 = 16
M1 = 17
M2 = 18
M3 = 19
T0 = 20
T1 = 21
T2 = 22
T3 = 23
CTR = 24

/*
 * param state:  r24:r25
 * param ks:     r22:r23
 * param rounds: r20   
 */
	//push_range 0, 15
	push r28
	push r29
	push r24
	push r25
	movw r26, r22
	movw r30, r24
	
	//State Set
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld ST\row\col, Z+
		.endr
	.endr

	ldi r31, hi8(SBOX_TABLE)	
	ldi r29, hi8(MIX2_TABLE)

	ldi r20, 14 ;!!-------
	add r26, r20 ;!!------

	;2297 --> 14개 copy
	;2303 --> 10개 copy
	
	// 0Round----------------------------------------------------------------------------------------
	/*.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr*/

	/*ld r16,	X+ ;------
	eor ST30, r16  ;------
	ld r16,	X+     ;------
	eor ST31, r16*/;------

	ld r16,	X+     ;------
	eor ST32, r16  ;------
	ld r16,	X+     ;------
	eor ST33, r16  ;------

	//1 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 1Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	
	//2 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 2Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr

	
	//3 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 3Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	//4 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 4Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	//5 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 5Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	//6 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 6Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	//7 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 7Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	
	//8 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 8Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	//9 Round------------------------------------------------------------------------------------------
	
	/* Shift Row and Subbyte , Mixcolumns */
	//! 1번째 열 시작
	mov r30, ST00 
	ld  M1, Z 
	mov M2, M1
	mov M3, M2 
	mov r28, ST00
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST11
	ld  T0, Z
	eor M0, T0
	eor M2, T0
	eor M3, T0 
	mov r28, ST11
	ld  T0, Y
	eor M0, T0
	eor M1, T0 ;3, 2, 2, 1 완료

	mov r30, ST22
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M3, T0
	mov r28, ST22
	ld  T0, Y
	eor M1, T0
	eor M2, T0 ;1, 3, 2, 1 완료

	mov r30, ST33
	ld  T0, Z
	eor M0, T0
	eor M1, T0
	eor M2, T0 
	mov r28, ST33
	ld  T0, Y
	eor M2, T0
	eor M3, T0 ;1, 1, 3, 2 완료

	mov ST00, M0
	//! 1번째 열 완료

	//! 2번째 열 시작
	mov r30, ST10 
	ld  T1, Z 
	mov T2, T1
	mov T3, T2 
	mov r28, ST10
	ld  T0, Y
	eor T3, T0 ; 2, 1, 1, 3 완료

	mov r30, ST21
	ld  M0, Z
	eor T0, M0
	eor T2, M0
	eor T3, M0 
	mov r28, ST21
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST32
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST32
	ld  M0, Y
	eor T1, M0
	eor T2, M0 ;1, 3, 2, 1 완료

	mov r30, ST03
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T2, M0 
	mov r28, ST03
	ld  M0, Y
	eor T2, M0
	eor T3, M0 ;1, 1, 3, 2 완료

	mov ST10, T0
	mov ST11, T1
	mov ST03, M3
	//! 2번째 열 완료

	//! 3번째 열 시작
	mov r30, ST20 
	ld  T0, Z 
	mov T1, T0
	mov M3, T1 
	mov r28, ST20
	ld  M0, Y
	eor M3, M0 ; 2, 1, 1, 3 완료

	mov r30, ST31
	ld  r25, Z
	eor M0, r25
	eor T1, r25
	eor M3, r25
	mov r28, ST31
	ld  r25, Y
	eor M0, r25
	eor T0, r25 ;3, 2, 2, 1 완료

	mov r30, ST02
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor M3, r25
	mov r28, ST02
	ld  r25, Y
	eor T0, r25
	eor T1, r25;1, 3, 2, 1 완료

	mov r30, ST13
	ld  r25, Z
	eor M0, r25
	eor T0, r25
	eor T1, r25 
	mov r28, ST13
	ld  r25, Y
	eor T1, r25
	eor M3, r25 ;1, 1, 3, 2 완료

	mov ST20, M0
	mov ST21, T0
	mov ST22, T1
	mov ST13, T3
	//! 3번째 열 완료



	//! 4번째 열 시작
	mov r30, ST30 
	ld  T1, Z 
	mov T3, T1
	mov r25, T3 
	mov r28, ST30
	ld  T0, Y
	eor r25, T0 ; 2, 1, 1, 3 완료

	mov r30, ST01
	ld  M0, Z
	eor T0, M0
	eor T3, M0
	eor r25, M0 
	mov r28, ST01
	ld  M0, Y
	eor T0, M0
	eor T1, M0 ;3, 2, 2, 1 완료

	mov r30, ST12
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor r25, M0 
	mov r28, ST12
	ld  M0, Y
	eor T1, M0
	eor T3, M0 ;1, 3, 2, 1 완료

	mov r30, ST23
	ld  M0, Z
	eor T0, M0
	eor T1, M0
	eor T3, M0 
	mov r28, ST23
	ld  M0, Y
	eor T3, M0
	eor r25, M0 ;1, 1, 3, 2 완료

	mov ST30, T0
	mov ST31, T1
	mov ST32, T3
	mov ST33, r25
	mov ST01, M1
	mov ST02, M2
	mov ST12, T2
	mov ST23, M3
	//! 4번째 열 완료

	/* 9Round Key*/
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr
	
	
	


	// 10 Round--------------------------------------------------------------------------------------------
	// Shift Row + Subbyte
	mov r30, ST00
	ld ST00, Z
	mov r30, ST10
	ld ST10, Z
	mov r30, ST20
	ld ST20, Z
	mov r30, ST30
	ld ST30, Z

	mov r30, ST01
	ld T0, Z
	mov r30, ST11
	ld ST01, Z
	mov r30, ST21
	ld ST11, Z
	mov r30, ST31
	ld ST21, Z
	mov ST31, T0

	mov r30, ST02
	ld T0, Z
	mov r30, ST12
	ld T1, Z
	mov r30, ST22
	ld ST02, Z
	mov r30, ST32
	ld ST12, Z
	mov ST22, T0
	mov ST32, T1

	mov r30, ST03
	ld T0, Z
	mov r30, ST33
	ld  ST03, Z
	mov r30, ST23
	ld ST33, Z
	mov r30, ST13
	ld ST23, Z
	mov ST13, T0

	//10Round key
	.irp row, 0, 1, 2, 3
		.irp col, 0, 1, 2, 3
			ld r16, X+
			eor ST\row\col, r16
		.endr
	.endr

	//ST
	pop r31
	pop r30
	.irp row, 0, 1, 2, 3
			.irp col, 0, 1, 2, 3
			st Z+, ST\row\col
		.endr
	.endr
	pop r29
	pop r28
	ret


