#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

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

void encrypt(bit64 IV, bit64 state[], bit64 key[], bit64 nonce[],
             bit64 plaintext[], bit64 ciphertext[],
             bit64 associated_data_text[], size_t ad_len, size_t pt_len)
{
    state[0] = IV;
    state[1] = key[0];
    state[2] = key[1];
    state[3] = nonce[0];
    state[4] = nonce[1];

    initialization(state,key);
    Associated(state, ad_len, associated_data_text);
    print_state(state);

    Plaintext(state, pt_len, plaintext, ciphertext);

    Finalization(state, key);
    printf("tag: %016" PRIx64 " %016" PRIx64 "\n", state[3], state[4]);
}

void decrypt(bit64 IV, bit64 state[], bit64 key[], bit64 nonce[],
             bit64 plaintext[], bit64 ciphertext[],
             bit64 associated_data_text[], size_t ad_len, size_t ct_len)
{
    state[0] = IV;
    state[1] = key[0];
    state[2] = key[1];
    state[3] = nonce[0];
    state[4] = nonce[1];

    initialization(state,key);
    Associated(state, ad_len, associated_data_text);
    print_state(state);

    Ciphertext(state, ct_len, plaintext, ciphertext);

    Finalization(state, key);
    printf("tag: %016" PRIx64 " %016" PRIx64 "\n", state[3], state[4]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int load_file(const char *path, uint8_t **out_data, size_t *out_len) {
    FILE *f = fopen(path, "rb");
    if (!f) return -1;
    if (fseek(f, 0, SEEK_END) != 0) { fclose(f); return -2; }
    long sz = ftell(f);
    if (sz < 0) { fclose(f); return -3; }
    rewind(f);

    uint8_t *buf = (uint8_t*)malloc((size_t)sz);
    if (!buf) { fclose(f); return -4; }

    size_t got = fread(buf, 1, (size_t)sz, f);
    fclose(f);
    if (got != (size_t)sz) { free(buf); return -5; }

    *out_data = buf;
    *out_len  = (size_t)sz;
    return 0;
}

int write_file(const char *path, const uint8_t *data, size_t len) {
    FILE *f = fopen(path, "wb");
    if (!f) return -1;
    size_t put = fwrite(data, 1, len, f);
    fclose(f);
    return (put == len) ? 0 : -2;
}

static inline uint64_t pack64_be(const uint8_t b[8]) {
    return ((uint64_t)b[0] << 56) | ((uint64_t)b[1] << 48) |
           ((uint64_t)b[2] << 40) | ((uint64_t)b[3] << 32) |
           ((uint64_t)b[4] << 24) | ((uint64_t)b[5] << 16) |
           ((uint64_t)b[6] <<  8) | ((uint64_t)b[7] <<  0);
}

static inline void unpack64_be(uint64_t x, uint8_t b[8]) {
    b[0] = (uint8_t)(x >> 56);
    b[1] = (uint8_t)(x >> 48);
    b[2] = (uint8_t)(x >> 40);
    b[3] = (uint8_t)(x >> 32);
    b[4] = (uint8_t)(x >> 24);
    b[5] = (uint8_t)(x >> 16);
    b[6] = (uint8_t)(x >>  8);
    b[7] = (uint8_t)(x >>  0);
}

int bytes_to_u64_blocks_be(const uint8_t *in, size_t len,
                           bit64 **out_words, size_t *out_n) {
    size_t nblocks = (len + 7) / 8;
    if (nblocks == 0) nblocks = 1;

    bit64 *w = (bit64*)calloc(nblocks, sizeof(bit64));
    if (!w) return -1;

    size_t full = len / 8;
    size_t rem  = len % 8;

    for (size_t i = 0; i < full; ++i) {
        w[i] = pack64_be(in + i*8);
    }

    if (rem) {
        uint8_t last[8] = {0};
        memcpy(last, in + full*8, rem);
        w[full] = pack64_be(last);
    } else if (len == 0) {
        // len=0 thì block 0 đã là 0 do calloc
    }

    *out_words = w;
    *out_n     = nblocks;
    return 0;
}

int u64_blocks_to_bytes_be(const bit64 *words, size_t nblocks,
                           size_t orig_len, uint8_t **out_bytes, size_t *out_len) {
    if (nblocks == 0) return -1;
    size_t total = nblocks * 8;

    uint8_t *buf = (uint8_t*)malloc(total);
    if (!buf) return -2;

    for (size_t i = 0; i < nblocks; ++i) {
        unpack64_be(words[i], buf + i*8);
    }

    if (orig_len <= total) {
        *out_bytes = (uint8_t*)malloc(orig_len);
        if (!*out_bytes) { free(buf); return -3; }
        memcpy(*out_bytes, buf, orig_len);
        free(buf);
        *out_len = orig_len;
        return 0;
    } else {
        free(buf);
        return -4;
    }
}
int main() {
    bit64 nonce[2] = {0x0000000000000001ULL, 0x0000000000000002ULL};
    bit64 key[2]   = {0, 0};
    bit64 IV       = 0x80400c0600000000ULL;

    uint8_t *img_bytes = NULL;
    size_t   img_len   = 0;

    if (load_file("input.png", &img_bytes, &img_len) != 0) {
        printf("Khong mo duoc file input.png\n");
        return 1;
    }

    bit64 ad[3] = { (bit64)img_len, 0x787878ULL, 0x878787ULL };

    bit64 *plaintext_blocks = NULL;
    size_t nblocks = 0;
    if (bytes_to_u64_blocks_be(img_bytes, img_len, &plaintext_blocks, &nblocks) != 0) {
        printf("Loi chuyen doi bytes -> blocks\n");
        free(img_bytes);
        return 1;
    }

    bit64 *cipher_blocks = (bit64*)calloc(nblocks, sizeof(bit64));
    if (!cipher_blocks) {
        printf("Khong cap duoc bo nho cho cipher\n");
        free(img_bytes); free(plaintext_blocks);
        return 1;
    }

    encrypt(IV, state, key, nonce, plaintext_blocks, cipher_blocks, ad, 3, nblocks);
    {
        size_t out_len = nblocks * 8;
        uint8_t *out_bytes = (uint8_t*)malloc(out_len);
        if (!out_bytes) { printf("Khong cap duoc bo nho out_bytes\n"); }
        else {
            for (size_t i = 0; i < nblocks; ++i)
                unpack64_be(cipher_blocks[i], out_bytes + i*8);
            if (write_file("output_enc.bin", out_bytes, out_len) != 0)
                printf("Khong ghi duoc output_enc.bin\n");
            free(out_bytes);
        }
    }

    bit64 *plain_recovered = (bit64*)calloc(nblocks, sizeof(bit64));
    if (!plain_recovered) {
        printf("Khong cap duoc bo nho plain_recovered\n");
        free(img_bytes); free(plaintext_blocks); free(cipher_blocks);
        return 1;
    }

    decrypt(IV, state, key, nonce, plain_recovered, cipher_blocks, ad, 3, nblocks);
    {
        uint8_t *dec_bytes = NULL;
        size_t   dec_len   = 0;
        if (u64_blocks_to_bytes_be(plain_recovered, nblocks, img_len, &dec_bytes, &dec_len) == 0) {
            if (write_file("output_dec.png", dec_bytes, dec_len) != 0)
                printf("Khong ghi duoc output_dec.png\n");
            free(dec_bytes);
        } else {
            printf("Loi chuyen doi blocks -> bytes khi giai ma\n");
        }
    }

    free(img_bytes);
    free(plaintext_blocks);
    free(cipher_blocks);
    free(plain_recovered);

    printf("Done. Da tao 'output_enc.bin' va 'output_dec.png'\n");

    return 0;
}