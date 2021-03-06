﻿/*
 * aes_types.h
 *
 * Created: 2020-04-22 오후 5:23:04
 *  Author: 김영범
 */ 

#ifndef AES_TYPES_H_
#define AES_TYPES_H_

#include <stdint.h>

typedef struct{
	uint8_t ks[16];
} aes_roundkey_t;

typedef struct{
	aes_roundkey_t key[10+1];
} aes128_ctx_t;

typedef struct{
	aes_roundkey_t key[12+1];
} aes192_ctx_t;

typedef struct{
	aes_roundkey_t key[14+1];
} aes256_ctx_t;

typedef struct{
	aes_roundkey_t key[1]; /* just to avoid the warning */
} aes_genctx_t;

typedef unsigned char u8;

//typedef struct{
//	uint8_t s[16];
//} aes_cipher_state_t;

#endif
