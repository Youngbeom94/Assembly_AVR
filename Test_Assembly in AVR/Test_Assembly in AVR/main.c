

/*
 * AES_8bit_asm.c
 *
 * Created: 2020-03-25 오전 11:21:43
 * Author : 김영범
 */ 

#include "header.h"


int main(void)
{
	
 	 u8 inp[16] = {0x32,0x43,0xf6,0xa8,0x88,0x5a,0x30,0x8d,0x31,0x31,0x98,0xa2,0xe0,0x37,0x07,0x34};
 	 u8 userkey[16] = {0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c};

	 //u8 inp[16 * BLOCKSIZE] ={0x00};
	 u8 out[16 * BLOCKSIZE] = {0x00};
	 //u8 userkey[16] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0a,0x0b,0x0c,0x0d,0x0e,0x0f};
	 //u8 LUT_FL[4][4][256]PROGMEM = {{{0x00}}};
	 u8 count[16] = {0x00};
		 
	//Make_LUT_Face_Light(LUT_FL,userkey,count,sbox,Rcon);
	//CRYPTO_ctr128_encrypt_FACE_Light(inp,out,LUT_FL,AES_KEY_BIT,userkey,count,sbox,Rcon);
	
	//CRYPTO_ctr128_encrypt(inp,out,AES_KEY_BIT,userkey,count,sbox,Rcon);	
	
	//AES_encrypt(inp,out,userkey);
	//AES_encrypt_asm(inp,out,userkey);
	//AES_encrypt_asm_Progm(inp,out,userkey);
	
	AddRoundKey_asm(inp,userkey);
	//AddRoundKey(inp,userkey);
	




	
}

