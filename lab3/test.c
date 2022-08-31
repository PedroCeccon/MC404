int power(int base, int value, int position){
    int result = 1;
    for (int i = 0; i < position; i++){
        result = result*base;
    }
    return result*value;
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

    for(int i = 0; i < decimal_size; i++){
        decimal[i] = temp[decimal_size - i - 1];
    }
    decimal[decimal_size] = 10;

    return decimal_size + 1;
}

void main(){
    char decimal[20];
    int decimal_size;
    decimal_size = hexToDec("0x12\n", decimal, 5);
    decimal[decimal_size] = "\0";
    printf("%s", decimal);
}