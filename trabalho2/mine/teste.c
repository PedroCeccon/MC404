#include "api_car.h"

int main(){
    char my_string[100];
    char filter[3];
    filter[0] = -1;
    filter[1] = 2;
    filter[0] = -1;
    
    unsigned char camera[256];
    while (1)
    {
        int x = atoi(gets(my_string));
        int y = 5 + x;
        puts(itoa(y, my_string, 10));

    }
    return 0;
}