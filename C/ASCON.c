#include <stdio.h>
#include <stdint.h>

#define bit64 uint64_t

const bit64 RC[12] = {
    0x00000000000000F0,
    0x00000000000000E1,
    0x00000000000000D2,
    0x00000000000000C3,
    0x00000000000000B4,
    0x00000000000000A5,
    0x0000000000000096,
    0x0000000000000087,
    0x0000000000000078,
    0x0000000000000069,
    0x000000000000005A,
    0x000000000000004B
};
bit64 state[5] = {0};
void print_state(bit64 state[5])
{
    for (int i = 0; i < 5; i++)
    {
        printf("%016I64x\n", state[i]);
    }
}

bit64 rotate(bit64 x, int l)
{
    return (x >> l) | (x << (64 - l));
}

void Sbox(bit64 x[5])
{
    bit64 t0, t1, t2, t3, t4;

    x[0] ^= x[4];
    x[4] ^= x[3];
    x[2] ^= x[1];

    t0 = ~x[0];
    t1 = ~x[1];
    t2 = ~x[2];
    t3 = ~x[3];
    t4 = ~x[4];

    t0 &= x[1];
    t1 &= x[2];
    t2 &= x[3];
    t3 &= x[4];
    t4 &= x[0];

    x[0] ^= t1;
    x[1] ^= t2;
    x[2] ^= t3;
    x[3] ^= t4;
    x[4] ^= t0;

    x[1] ^= x[0];
    x[0] ^= x[4];
    x[3] ^= x[2];
    x[2] = ~x[2];
}

bit64 temp0[5] = {19, 61, 1, 10, 7};
bit64 temp1[5] = {28, 39, 6, 17, 41};
void linear(bit64 state[5])
{
    for (int i = 0; i < 5; i++)
    {
        state[i] ^= rotate(state[i], temp0[i]) ^ rotate(state[i], temp1[i]);
    }
}

void add_const(bit64 state[5], int i, int a)
{
    state[2] = state[2] ^ RC[i + 12 - a];
}

void p(bit64 state[5], int a)
{
    for (int i = 0; i < a; i++)
    {
        add_const(state, i , a);
        Sbox(state);
        linear(state);
    }
}

void initialization(bit64 state[5], bit64 key[2])
{
    p(state, 12);
    state[3] ^= key[0];
    state[4] ^= key[1];
}

void Associated(bit64 state[5], int length, bit64 associated_text[])
{
    for (int i = 0; i < length; i++)
    {
        state[0] ^= associated_text[i];
        p(state, 6);
    }
    state[4] ^= 0x0000000000000001;
}


void Finalization(bit64 state[5], bit64 key[2])
{
    state[1] ^= key[0];
    state[2] ^= key[1];
    p(state, 12);
    state[3] ^= key[0];
    state[4] ^= key[1];
}

void Plaintext(bit64 state[5], int length, bit64 plaintext[], bit64 ciphertext[]) {
   ciphertext[0] = plaintext[0] ^ state[0];
   for (int i = 1; i < length; i++){
      p(state, 6);
      ciphertext[i] = plaintext[i] ^ state[0];
      state[0] = ciphertext[i];
   }
}

void Ciphertext(bit64 state[5], int length, bit64 plaintext[], bit64 ciphertext[]){
   plaintext[0] = ciphertext[0] ^ state[0];
   for (int i = 1; i < length; i++){
      p(state, 6);
      plaintext[i] = ciphertext[i] ^ state[0];
      state[0] = ciphertext[i];
   }
}

void encrypt(bit64 IV, bit64 state[], bit64 key[], bit64 nonce[], bit64 plaintext[], bit64 ciphertext[], bit64 associated_data_text[])
{
    state[0] = IV;
    state[1] = key[0];
    state[2] = key[1];
    state[3] = nonce[0];
    state[4] = nonce[1];
    initialization(state,key);
    Associated(state, 3, associated_data_text);
    print_state(state);
    Plaintext(state, 2, plaintext, ciphertext);
    printf("\nEncrypt: %016I64x %016I64x\n", ciphertext[0], ciphertext[1]);
    Finalization(state, key);
    printf("tag: %016I64x %016I64x\n", state[3], state[4]);
}

void decrypt(bit64 IV, bit64 state[], bit64 key[], bit64 nonce[], bit64 plaintext[], bit64 ciphertext[], bit64 associated_data_text[])
{
    state[0] = IV;
    state[1] = key[0];
    state[2] = key[1];
    state[3] = nonce[0];
    state[4] = nonce[1];
    initialization(state,key);
    Associated(state, 3, associated_data_text);
    print_state(state);
    Ciphertext(state, 2, plaintext, ciphertext);
    printf("\nDecrypt: %016I64x %016I64x\n", plaintext[0], plaintext[1]);
    Finalization(state, key);
    printf("tag: %016I64x %016I64x\n", state[3], state[4]);
}
int main() {
    bit64 nonce[2] = { 0x0000000000000001, 0x0000000000000002 };
    bit64 key[2] = { 0 };
    bit64 IV = 0x80400c0600000000;
    bit64 plaintext[] = {0x1234567890abcdef, 0x82187};
    bit64 ciphertext[2] = { 0 };
    bit64 associated_data_text[] = { 0x787878, 0x878787, 0x09090};

    encrypt(IV, state, key, nonce, plaintext, ciphertext, associated_data_text);
    decrypt(IV, state, key, nonce, plaintext, ciphertext, associated_data_text);
}