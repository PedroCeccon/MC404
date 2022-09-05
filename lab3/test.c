//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B
 
#include <stdio.h>

int power(int base, int position){
    int result = 1;
    for (int i = 0; i < position; i++){
        result = result*base;
    }
    return result;
}

void copyString(char *input, char* output, int n){
    for(int i = 0; i < n; i++){
        output[i] = input[i];
    }
}

void invertString(char *input, char *output, int n, int start){
    for(int i = 0; i < n; i++){
        output[i+start] = input[n-i-1];
    }
}   

int intToString(int value, int base, int start, char *string){
    int size = 0;
    char temp[40];
    int digit_value;

    while(value > 0){
        digit_value = value%base;
        value -= digit_value;
        value = value/base;
        int ascii_complement = (digit_value<10 ? 48 : 87);
        temp[size] = digit_value+ascii_complement;
        size++;
    }

    invertString(temp, string, size, start);
    size += start;
    string[size] = 10;

    return size + 1;
}

int stringToInt(char *string, int size, int base, int start){
    int digit_value, total_value=0;
    for (int i = 2; (size - i) >= start; i++){
        if(string[size-i] <= 57){
            digit_value = string[size-i]-48;
        }
        else{
            digit_value = string[size-i]-87;
        }
        total_value += digit_value*power(base, i-2);
    }
    return total_value;
}

void switchEndian(char *input, char *output, int input_size){
    char temp[32];
    for(int i = 1; i < input_size - 2; i++){
        temp[32-i] = input[input_size-i-1];
    }
    for(int i = input_size - 2; i <=32; i++){
        temp[32-i] = '0';
    }
    for(int i = 0; i < 32; i+=8){
        for(int j = 0; j < 8; j++){
            output[31-i-j] = temp[i+7-j];
        }
    }
}

int main(){
    char input[] = "0x80000000\n";
    int n = 11;
    char binary[40], hex[20], decimal[20], endian_2[32], endian_10[20];
    int bin_size = 0, decimal_size = 0, hex_size = 0, endian_size = 0;
    int value;
    unsigned int u_value;
    if(input[0] == '0' && input[1] == 'x'){
        copyString(input, hex, n);
        hex_size = n;
        value = stringToInt(hex, n, 16, 2);
        decimal_size = intToString(value, 10, 0, decimal);
        binary[0] = '0';
        binary[1] = 'b';
        bin_size = intToString(value, 2, 2, binary);
        switchEndian(binary, endian_2, bin_size);
        u_value = stringToInt(endian_2, 33, 2, 0);
        endian_size = intToString(u_value, 10, 0, endian_10);
    }
    printf("%s", endian_10);
    
    /*write(1, input, n);
    write(1, hex, hex_size);
    write(1, decimal, decimal_size);
    write(1, binary, bin_size);*/
    
    
    return 0;
}
 
void _start(){
    main();
}
