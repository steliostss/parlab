#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

typedef int comb_t;

#define COMBINE(P, B) ((comb_t)((int)P | B))
//comb_t create_value(int* num, int bit)
//{
//    uint64_t ret;
//    ret = (num << 1);
//    bit &= 0x0000000000000001;
//    ret |= bit;
//    return ret;
//}

#define GETNEXTPOINTER(C) ((int*)(C & 0xfffffffe))
//int *get_num(comb_t c)
//{
//    return c & 0x11111110;
//}

#define GETBIT(C) (C & 0x00000001)
//uint64_t get_bit(comb_t c)
//{
//    uint64_t mask = 0x00000001;
//    return c & mask;
//}

int main()
{
    int x = 5;
    int *p = &x;
    char buff[64];
    itoa(p, buff, 2);

    comb_t c = COMBINE(p,1);
    printf("%d %d\n", c, sizeof(c));

    p = GETNEXTPOINTER(c);
    printf("%d %d %d\n", p, sizeof(p), *p);

    int b = GETBIT(c);
    printf("%d %d\n", b, sizeof(b));

    return 0;
}