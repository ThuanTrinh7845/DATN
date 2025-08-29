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

void Plaintext(bit64 plaintext[], int length, bit64 ciphertext[], bit64 state[5])
{
    ciphertext[0] = plaintext[0] ^ state[0];
    for (int i = 1; i < length; i++)
    {
        p(state, 6);
        ciphertext[i] = plaintext[i] ^ state[0];
        state[0] = ciphertext[i];
    }
}

void Finalization(bit64 state[5], bit64 key[2])
{
    state[0] ^= key[1];
    state[1] ^= key[2];
    p(state, 12);
}

void ascon(bit64 nonce[2], bit64 key[2], bit64 IV, bit64 plaintext[], bit64 ciphertext[], bit64 state[5])
{
    state[0] = IV;
    state[1] = key[0];
    state[2] = key[1];
    state[3] = nonce[0];
    state[4] = nonce[1];
    initialization(state, key);
    print_state(state);
    Plaintext(plaintext, 2, ciphertext, state);
    printf("Ciphertext: %016I64x %016I64x\n", ciphertext[0], ciphertext[1]);
    Finalization(state, key);
    printf("Tag: %016I64x %016I64x\n", state[3], state[4]);
}

int main() {
    bit64 nonce[2] = {0};
    bit64 key[2] = {0};
    bit64 IV = 0x80400c0600000000;
    bit64 plaintext[] = {0x1234567980abcdef, 0x82187}, ciphertext[] = {0};
    ascon(nonce, key, IV, plaintext, ciphertext, state);
    ascon(nonce, key, IV, ciphertext, ciphertext, state);
    return 0;
}