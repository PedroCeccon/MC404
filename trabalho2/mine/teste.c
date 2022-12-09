#include "api_car.h"

int main(){
    unsigned char my_string[100];
    char filter[3];
    filter[0] = -1;
    filter[1] = 2;
    filter[0] = -1;
    unsigned char teste[256];
    for(int i = 0; i < 256; i ++){
        teste[i] = i;
    }
    unsigned char camera[256];
    while (1)
    {
        display_image(teste);
    }
    return 0;
}