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

/**
 * exit syscall
 * @param int error_code
 */
void exit_syscall(int error_code){
    __asm__ __volatile__(
        "li a7, 93           # syscall write (93) \n"
        "ecall"
        :   
        :"r"(error_code)
        :"a7"
    );
}

/**
 * calcula a potencia: result = base^exponent
 * @param int base
 * @param int exponent
 * @return result
 */
int power(int base, int exponent){
    int result = 1;
    for (int i = 0; i < exponent; i++){
        result = result*base;
    }
    return result;
}

/**
 * copia os n primeiros elementos de input para output
 * @param char *input
 * @param char *output
 * @param int n
 */
void copyString(char *input, char *output, int n){
    for(int i = 0; i < n; i++){
        output[i] = input[i];
    }
}

/**
 * copia os n ultimos elementos de input em output de forma inversa, comecando da posicao start do output
 * @param char *input
 * @param char *output
 * @param int n
 * @param int start
 */
void invertString(char *input, char *output, int n, int start){
    for(int i = 0; i < n; i++){
        output[i+start] = input[n-i-1];
    }
}   

/**
 * monta o complemento do numero na base binaria representado na string "input" em "output"
 * @param char *input
 * @param char *output
 */
void complement(char *input, char *output){
    int i = 2;
    while(input[i] != 10){
        output[i-2] = input[i] == 48 ? 49 : 48;
        i++;
    }
}

/**
 * monta uma string de caracteres em "string" que representa o numero "value" 
 * na base numerica "base" a partir da posicao "start" da string
 * e retorna quantos elementos tem em "string"
 * @param u_int value
 * @param int base
 * @param int start
 * @param char *string
 * @return size
 */
int intToString(unsigned int value, int base, int start, char *string){
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

/**
 * recebe uma string de caracteres "string" que repesenta
 * um numero em alguma base numerica "base" e transforma
 * o numero contido entre as posicoes start e size
 * da string em um valor numerico e retorna como int
 * @param char *string
 * @param int size
 * @param int base
 * @param int start
 * @return total_value
 */
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

/**
 * recebe uma string de caracteres "input", com "input_size" caracteres,
 * que representa um numero na base binaria e troca a endian desse numero
 * armazenando na string de caracteres "output"
 * @param char *input
 * @param char *output
 * @param int input_size
 */
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
    char input[20];
    char binary[40], binary_complement[32], hex[20], decimal[20], endian_2[32], endian_10[20];
    int bin_size = 0, decimal_size = 0, hex_size = 0, endian_size = 0;
    int value;

    int n = read(0, input, 20); //Leitura da string de entrada, retorna a quantidade de bytes (caracteres) lidos 
    
    //No caso de a entrada ser fornecida em hexadecimal
    if(input[0] == '0' && input[1] == 'x'){
        copyString(input, hex, n);
        hex_size = n;
        value = stringToInt(hex, n, 16, 2); //Pega o valor numerico fornecido em uma variavel int
        binary[0] = '0';
        binary[1] = 'b';
        bin_size = intToString(value, 2, 2, binary);
        
        //No caso de ter sido fornecido um numero negativo (sempre considerando a representacao complemento de 2)
        if (value<0){
            complement(binary, binary_complement);
            value = stringToInt(binary_complement, bin_size-2, 2, 0);
            decimal[0] = '-';
            decimal_size = intToString(value + 1, 10, 1, decimal);
        }

        //Numero positivo
        else{
            decimal_size = intToString(value, 10, 0, decimal);
        }

        switchEndian(binary, endian_2, bin_size);
        value = stringToInt(endian_2, 33, 2, 0);
        endian_size = intToString(value, 10, 0, endian_10);
    }

    //No caso de a entrada ser fornecida em decimal
    else{
        copyString(input, decimal, n);
        decimal_size = n;

        //No caso de ter sido fornecido um numero negativo
        if(input[0] == '-'){
            value = stringToInt(decimal, n, 10, 1);
            value = value * (-1);
        }

        //Numero positivo
        else{
            value = stringToInt(decimal, n, 10, 0);
        }

        binary[0] = '0';
        binary[1] = 'b';
        bin_size = intToString(value, 2, 2, binary);
        hex[0] = '0';
        hex[1] = 'x';
        hex_size = intToString(value, 16, 2, hex);
        switchEndian(binary, endian_2, bin_size);
        value = stringToInt(endian_2, 33, 2, 0);
        endian_size = intToString(value, 10, 0, endian_10);
    }

    //Escreve os resultados no terminal da simualcao do RISC-V
    write(1, binary, bin_size);
    write(1, decimal, decimal_size);
    write(1, hex, hex_size);
    write(1, endian_10, endian_size);
    
    return 0;
}
 
void _start(){
    exit_syscall(main());
}
