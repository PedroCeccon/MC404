#include "api_car.h"

int main(){
    char my_string[100];
    char camera[256];
    while (1)
    {
        read_camera(camera);
        display_image(camera);
    } 
    return 0;
}