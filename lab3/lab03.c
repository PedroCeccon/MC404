//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B

int read(int __fd, const void *__buf, int __n){
    int bytes;
    __asm__ __volatile__(
        "mv a0, %1           # file descriptor\n"
        "mv a1, %2           # buffer \n"
        "mv a2, %3           # size \n"
        "li a7, 63           # syscall read (63) \n"
        "ecall \n"
        "mv %0, a0"
        : "=r"(bytes)  // Output list
        :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
        : "a0", "a1", "a2", "a7"
    );
    return bytes;
}
 
void write(int __fd, const void *__buf, int __n){
    __asm__ __volatile__(
        "mv a0, %0           # file descriptor\n"
        "mv a1, %1           # buffer \n"
        "mv a2, %2           # size \n"
        "li a7, 64           # syscall write (64) \n"
        "ecall"
        :   // Output list
        :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
        : "a0", "a1", "a2", "a7"
    );
}
 
int power(int base, int value, int position){
    int result = 1;
    for (int i = 0; i < position; i++){
        result = result*base;
    }
    return result*value;
}

void copyString(char *input, char* output, int n){
    for(int i = 0; i < n; i++){
        output[i] = input[i];
    }
}

void invertString(char *input, char *output, int n){
    for(int i = 0; i < n; i++){
        output[i] = input[n-i-1];
    }
}   

int decToHex(char *decimal, char *hex, int n){
    return 0;
}

int decToBin(char *decimal, char *binary, int n){
    return 0;
}

int hexToBin(char *hex, char *binary, int n){
    int bin_size = 3;
    int digit_value, bit_value;
    for (int i = 2; i<n-1; i++){
        if(hex[n-i] <= 57){
            digit_value = hex[n-i]-48;
        }
        else{
            digit_value = hex[n-i]-87;
        }
        int counter = 0;
        while(counter < 4){
            bit_value = digit_value%2;
            digit_value -= bit_value;
            digit_value = digit_value/2;
            binary[bin_size - counter] = bit_value+48;
            counter++;
        }
        bin_size += 4;
    }
    binary[bin_size] = 10;
    return bin_size+1;
}

int hexToDec(char *hex, char *decimal, int n){
    int decimal_size = 0;
    char temp[20];
    int digit_value, total_value = 0;
    for (int i = 2; (n - i) >= 2; i++){
        if(hex[n-i] <= 57){
            digit_value = hex[n-i]-48;
        }
        else{
            digit_value = hex[n-i]-87;
        }
        total_value += power(16, digit_value, i-2);
    }

    while(total_value > 0){
        digit_value = total_value%10;
        total_value -= digit_value;
        total_value = total_value/10;
        temp[decimal_size] = digit_value+48;
        decimal_size++;
    }

    invertString(temp, decimal, decimal_size);
    decimal[decimal_size] = 10;

    return decimal_size + 1;
}

int main(){
    char input[20];
    int n = read(0, input, 20);
    char binary[40], endian_s[20], hex[20], decimal[20];
    int bin_size, decimal_size, hex_size, endian_size;
    if(input[0] == '0' && input[1] == 'x'){
        copyString(input, hex, n);
        hex_size = n;
        decimal_size = hexToDec(hex, decimal, n);
        bin_size = hexToBin(hex, binary, n);
    }
    write(1, input, n);
    write(1, hex, hex_size);
    write(1, decimal, decimal_size);
    write(1, binary, bin_size);
    
    
    return 0;
}
 
void _start(){
    main();
}
