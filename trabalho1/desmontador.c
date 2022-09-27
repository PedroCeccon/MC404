//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B

#include <fcntl.h>
#include <unistd.h>

#define _PATH "../lab2/executavel.x"

#define _SIZE(size) size
#define _MAX(x, y) x>y ? x : y
#define _SIZE_1BYTE 1
#define _SIZE_2BYTE 2
#define _SIZE_4BYTE 4
#define _SIZE_8BYTE 8
#define _HEADER_SIZE 0x34
#define _E_SHOFF 0x20
#define _E_SHNUM 0x30
#define _E_SHSTRNDX 0x32
#define _SECTION_HEADER_SIZE 0x28
#define _SH_OFFSET 0x10
#define _SH_ADDR 0xc
#define _SH_SIZE 0x14
#define _ST_VALUE 0x4
#define _ST_SIZE 0x8
#define _ST_INFO 0xc
#define _ST_SHNDX 0xe

typedef struct {
    unsigned int shstrtab_offset;
    unsigned int header_offset;
    unsigned int offset;
    unsigned int vma;
    char vma_str[8];
    unsigned int size;
    char size_str[8];
    unsigned int name_size;
} Section;

typedef struct{
    unsigned int st_name;
    unsigned int st_value;
    char value_str[8];
    unsigned int st_size;
    char size_str[8];
    unsigned char st_info;
    char info[1];
    unsigned short st_shndx;
    unsigned int name_size;
} Symbol;

/*int power(int base, int exponent){
    int result = 1;
    for (int i = 0; i < exponent; i++){
        result = result*base;
    }
    return result;
}*/

unsigned int memValue(unsigned char *file, unsigned int offset, int size){
    unsigned int value = 0;
    for(int i = 0; i < size; i++)
        value += file[offset+i]<<8*i;
    return value;
}

unsigned int getNameSize(unsigned char *file, Section nametab, unsigned int nametab_offset){
    unsigned int size = 0;
    while(file[nametab.offset+nametab_offset+size] != 0)
        size++;
    return size++;
}

void getName(unsigned char *file, char *name, Section nametab, unsigned int name_size, unsigned int nametab_offset){
    for(int i = 0; i < name_size; i++)
        name[i] = file[nametab.offset+nametab_offset+i];
}

int compareStrings(char *str1, char *str2, int size_str1, int size_str2){
    int equal = 1;
    if(size_str1 != size_str2)
        equal = 0;
    else{
        for(int i = 0; i < size_str1; i++){
            if(str1[i] != str2[i]){
                equal = 0;
                break;
            }
        }
    }
    return equal;
}

unsigned int getSectionIndex(unsigned char *file, Section *sections, char *str_section, int size_str, unsigned int e_shnum, unsigned int e_shstrdnx){
    int section_index = -1;
    for(int i = 0; i < e_shnum; i++){
        char name[_SIZE(sections[i].name_size)];
        getName(file, name, sections[e_shstrdnx], sections[i].name_size, sections[i].shstrtab_offset);
        if(compareStrings(name, str_section, sections[i].name_size, size_str))
            section_index = i;
    }
    return section_index;
}

void intToHexStr(char *str, unsigned int value, int number_bytes, char fill){
    int digit = 1;
    int digit_value;
    int number_nimbles = number_bytes * 2;

    while(value > 0){
        digit_value = value%16;
        value -= digit_value;
        value = value/16;
        int ascii_complement = (digit_value<10 ? 48 : 87);
        str[number_nimbles-digit] = digit_value+ascii_complement;
        digit++;
    }
    while(digit <= number_nimbles){
        str[number_nimbles-digit] = fill;
        digit++;
    }
}

void fillSections(unsigned char *file, Section *sections, unsigned int e_shoff, unsigned int e_shnum, unsigned int e_shstrdnx){
    for(int i = 0; i < e_shnum; i++){
        sections[i].header_offset = e_shoff + i*_SECTION_HEADER_SIZE;
        sections[i].shstrtab_offset = memValue(file, sections[i].header_offset, _SIZE_4BYTE);
        sections[i].vma = memValue(file, sections[i].header_offset + _SH_ADDR, _SIZE_4BYTE);
        intToHexStr(sections[i].vma_str, sections[i].vma, _SIZE_4BYTE, '0');
        sections[i].offset = memValue(file, sections[i].header_offset + _SH_OFFSET, _SIZE_4BYTE);
        sections[i].size = memValue(file, sections[i].header_offset + _SH_SIZE, _SIZE_4BYTE);
        intToHexStr(sections[i].size_str, sections[i].size, _SIZE_4BYTE, '0');
    }
    for(int i = 0; i < e_shnum; i++){
        sections[i].name_size = getNameSize(file, sections[e_shstrdnx], sections[i].shstrtab_offset);
    }
}

void fillSymbolTable(unsigned char *file, Section *sections, Symbol *symbol_table, int symbols_num, int symtab, int strtab){
    unsigned int offset_symtab = sections[symtab].offset + 16;
    for(int i = 0; i < symbols_num; i++){
        symbol_table[i].st_name = memValue(file, offset_symtab, _SIZE_4BYTE);
        symbol_table[i].st_value = memValue(file, offset_symtab + _ST_VALUE, _SIZE_4BYTE);
        intToHexStr(symbol_table[i].value_str, symbol_table[i].st_value, _SIZE_4BYTE, '0');
        symbol_table[i].st_size = memValue(file, offset_symtab + _ST_SIZE, _SIZE_4BYTE);
        intToHexStr(symbol_table[i].size_str, symbol_table[i].st_size, _SIZE_4BYTE, '0');
        symbol_table[i].st_info = memValue(file, offset_symtab + _ST_INFO, _SIZE_1BYTE);
        symbol_table[i].st_shndx = memValue(file, offset_symtab + _ST_SHNDX, _SIZE_2BYTE);
        symbol_table[i].name_size = getNameSize(file, sections[strtab], symbol_table[i].st_name);
        symbol_table[i].info[0] = (symbol_table[i].st_info == 0) ? 'l' : 'g';
        offset_symtab += 16;
    }
}

void indexStr(char *str, int index){
    int digit = 1;
    int digit_value;
    if(index>999)
        index = -1;

    while(index > 0){
        digit_value = index%10;
        index -= digit_value;
        index = index/10;
        str[3-digit] = digit_value+48;
        digit++;
    }
}

int getLabelsSection(int *labels_text_ndx, Section _section, Symbol *symbol_table, int  symbols_num){
    int labels_counter = 0;
    for(unsigned int i = _section.vma; i < _section.vma+_section.size; i+=4){
        for(int j = 0; j < symbols_num; j++){
            if(symbol_table[j].st_value == i){
                labels_text_ndx[labels_counter] = j;
                labels_counter++;
                break;
            }
        }
    }
    return labels_counter;
}

void printImm(int value){
    int digit = 0;
    int digit_value;
    char str[20][1];
    while(value > 0){
        digit_value = value%10;
        value -= digit_value;
        value = value/10;
        str[digit][0] = digit_value+48;
        digit++;
    }
    if(digit == 0)
        write(1, "0", 1);
    for(int i = digit - 1; i >= 0; i--)
        write(1, str[i], 1);
}

void printIO(int reg){
    if(reg == 0)
        write(1, "unknown", 7);
    else{
        if((reg >> 3) & 1)
            write(1, "i", 1);
        if((reg >> 2) & 1)
            write(1, "o", 1);
        if((reg >> 1) & 1)
            write(1, "r", 1);
        if(reg & 1)
            write(1, "w", 1);
    }
}

void printAdress(unsigned char *file, Section _strtab, int adress, Symbol *symbol_table, int *labels_ndx, int labels_num){
    char str[8][1];
    int digit = 1;
    int digit_value;
    int value = adress;

    write(1, "0x", 2);

    while(value > 0){
        digit_value = value%16;
        value -= digit_value;
        value= value/16;
        int ascii_complement = (digit_value<10 ? 48 : 87);
        str[8-digit][0] = digit_value+ascii_complement;
        digit++;
    }
    for(int i = 9 - digit; i < 8; i++){
        write(1, str[i], 1);
    }
    for(int i = 0; i < labels_num; i++){
        if(symbol_table[labels_ndx[i]].st_value == adress){
            write(1, " <", 2);
            char name[_SIZE(symbol_table[labels_ndx[i]].name_size)];
            getName(file, name, _strtab, symbol_table[labels_ndx[i]].name_size, symbol_table[labels_ndx[i]].st_name);
            write(1, name, symbol_table[labels_ndx[i]].name_size);
            write(1, ">", 1);
        }
    }
}

void printInstruction(unsigned char *file, Section _strtab, int instruction, Symbol *symbol_table, int *labels_ndx, int labels_num, int adress){
    int opcode = instruction & 0b1111111;
    int funct3 = (instruction >> 12) & 0b111;
    const char *registers[32] = {"zero", "ra", "sp", "gp", "tp", "t0", "t1", "t2", "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7", "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"};
    const int register_str_len[32] = {4, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2};
    int unknown = 0;
    //Tipo U
    if(opcode == 0b0110111 || opcode == 0b0010111){
        int rd = (instruction >> 7) & 0b11111;
        int imm = instruction >> 12;
        opcode > 32 ? write(1, "lui     ", 8) : write(1, "auipc   ", 8);
        write(1, registers[rd], register_str_len[rd]);
        write(1, ", ", 2);
        if(instruction >> 31) {
            imm = (imm ^ 0xffffffff) + 1;
            write(1, "-", 1);
        }
        printImm(imm);
    }
    //jal
    else if(opcode == 0b1101111){
        int rd = (instruction >> 7) & 0b11111;
        int imm = (((instruction >> 21) & 0x3ff) << 1) + (((instruction >> 20) & 1) << 11) + (instruction & 0x000ff000) + (((instruction >> 31) & 1) << 20);
        write(1, "jal     ", 8);
        write(1, registers[rd], register_str_len[rd]);
        write(1, ", ", 2);
        printAdress(file, _strtab, imm + adress, symbol_table, labels_ndx, labels_num);
    }
    //jalr
    else if(opcode == 0b1100111 && funct3 == 0){
        int rd = (instruction >> 7) & 0b11111, rs1 = (instruction >> 15) & 0b11111;
        int imm = instruction >> 20;
        write(1, "jalr    ", 8);
        write(1, registers[rd], register_str_len[rd]);
        write(1, ", ", 2);
        if(instruction >> 31) {
            imm = (imm ^ 0xffffffff) + 1;
            write(1, "-", 1);
        }
        printImm(imm);
        write(1, "(", 1);
        write(1, registers[rs1], register_str_len[rs1]);
        write(1, ")", 1);
    }
    //Tipo B
    else if(opcode == 0b1100011){
        const char *op[8] = {"beq     ", "bne     ", "\0", "\0", "blt     ", "bge     ", "bltu    ", "bgeu    "};
        if (op[funct3][0] == 0)
            unknown = 1;
        else{
            int rs1 = (instruction >> 15) & 0b11111, rs2 = (instruction >> 20) & 0b11111;
            int imm = (((instruction >> 7) & 1) << 11) + (((instruction >> 8) & 0b1111) << 1) + (((instruction >> 25) & 0b111111) << 5) + ((instruction >> 31) << 12);
            write(1, op[funct3], 8);
            write(1, registers[rs1], register_str_len[rs1]);
            write(1, ", ", 2);
            write(1, registers[rs2], register_str_len[rs2]);
            write(1, ", ", 2);
            printAdress(file, _strtab, imm + adress, symbol_table, labels_ndx, labels_num);
        }
    }
    //Tipo I (load)
    else if(opcode == 0b0000011){
        const char *op[8] = {"lb      ", "lh      ", "lw      ", "\0", "lbu     ", "lhu     ", "\0", "\0"};
        if (op[funct3][0] == 0)
            unknown = 1;
        else{
            int rd = (instruction >> 7) & 0b11111, rs1 = (instruction >> 15) & 0b11111;
            int imm = instruction >> 20;
            write(1, op[funct3], 8);
            write(1, registers[rd], register_str_len[rd]);
            write(1, ", ", 2);
            if(instruction >> 31) {
                imm = (imm ^ 0xffffffff) + 1;
                write(1, "-", 1);
            }
            printImm(imm);
            write(1, "(", 1);
            write(1, registers[rs1], register_str_len[rs1]);
            write(1, ")", 1);
        }
    }
    //Tipo S
    else if(opcode == 0b0100011){
        const char *op[3] = {"sb      ", "sh      ", "sw      "};
        if (funct3 > 2)
            unknown = 1;
        else{
            int rs1 = (instruction >> 15) & 0b11111, rs2 = (instruction >> 20) & 0b11111;
            int imm = ((instruction >> 7) & 0b11111) + (((instruction >> 25) & 0b111111) << 5);
            write(1, op[funct3], 8);
            write(1, registers[rs2], register_str_len[rs2]);
            write(1, ", ", 2);
            if(instruction >> 31) {
                imm = (imm ^ 0xffffffff) + 1;
                write(1, "-", 1);
            }
            printImm(imm);
            write(1, "(", 1);
            write(1, registers[rs1], register_str_len[rs1]);
            write(1, ")", 1);
        }
    }
    //Tipo I (operacao)
    else if(opcode == 0b0010011){
        char *op[8] = {"addi    ", "slli    ", "slti    ", "sltiu   ", "xori    ", "srli    ", "ori     ", "andi    "};
        int imm = instruction >> 20;
        if((funct3 == 1 && (instruction >> 25) == 0) || (funct3 == 5 && (instruction >> 25) == 0))
            imm = imm & 0b11111;
        else if((instruction>>25) == 32){
            imm = imm & 0b11111;
            op[5] = "srai    ";
        }
        else{
            op[1] = "\0       ";
            op[5] = "\0       ";
        }
        if (op[funct3][0] == 0)
            unknown = 1;
        else{
            int rd = (instruction >> 7) & 0b11111, rs1 = (instruction >> 15) & 0b11111;
            write(1, op[funct3], 8);
            write(1, registers[rd], register_str_len[rd]);
            write(1, ", ", 2);
            write(1, registers[rs1], register_str_len[rs1]);
            write(1, ", ", 2);
            if(instruction >> 31 && funct3 != 1 && funct3 != 5) {
                imm = (imm ^ 0xffffffff) + 1;
                write(1, "-", 1);
            }
            printImm(imm);
        }
    }
    //Tipo R
    else if(opcode == 0b0110011){
        char *op[8] = {"add     ", "sll     ", "slt     ", "sltu    ", "xor     ", "srl     ", "or      ", "and     "};
        if(instruction >> 25 != 0){
            op[funct3] = "\0       ";
        }
        if(instruction >> 25 == 32){
            op[0] = "sub     ";
            op[5] = "sra     ";
        }
        if (op[funct3][0] == 0)
            unknown = 1;
        else {
            int rd = (instruction >> 7) & 0b11111, rs1 = (instruction >> 15) & 0b11111, rs2 = (instruction >> 20) & 0b11111;
            write(1, op[funct3], 8);
            write(1, registers[rd], register_str_len[rd]);
            write(1, ", ", 2);
            write(1, registers[rs1], register_str_len[rs1]);
            write(1, ", ", 2);
            write(1, registers[rs2], register_str_len[rs2]);
        }
    }
    //fenc
    else if((instruction & 0xf00fffff) == 0xf){
        int pred = (instruction >> 24) & 0b1111, succ = (instruction >> 20) & 0b1111;
        write(1, "fence   ", 8);
        printIO(pred);
        write(1, ", ", 2);
        printIO(succ);
    }
    //fenc.i
    else if(instruction == 0x0000100f)
        write(1, "fence.i ", 8);
    //ecall
    else if(instruction == 0x00000073)
        write(1, "ecall   ", 8);
    //ebreak
    else if(instruction == 0x00100073)
        write(1, "ebreak  ", 8);
    else if(opcode == 0b1110011){
        const char *op[8] = {"\0", "csrrw   ", "csrrs   ", "csrrc   ", "\0", "csrrwi  ", "csrrsi  ", "csrrci  "};
        if(op[funct3][0] == 0)
            unknown = 1;
        else{
            unsigned int rd = (instruction >> 7) & 0b11111, csr = instruction >> 20, rs1_zimm = (instruction >> 15) & 0b11111;
            write(1, op[funct3], 8);
            write(1, registers[rd], register_str_len[rd]);
            write(1, ", ", 2);
            printImm(csr);
            write(1, ", ", 2);
            if(funct3 < 4)
                write(1, registers[rs1_zimm], register_str_len[rs1_zimm]);
            else
                printImm(rs1_zimm);
        }
    }
    else
        unknown = 1;
    if(unknown)
        write(1, "<unknown>", 9);
}

void printHeader(char *file_name){
    char text[] = ":\tfile format elf32-littleriscv\n\n";
    write(1, "\n", 1);
    int i = 1;
    while(!(file_name[i] == 'x' && file_name[i-1] == '.'))
        i++;
    write(1, file_name, i+1);
    write(1, text, sizeof(text)-1);
}

void printText(unsigned char *file, Section _text, Section _strtab, Symbol *symbol_table, int *labels_ndx, int labels_num){
    int label_counter = 0;
    char str[] = "\nDisassembly of section .text:\n";
    int vma = _text.vma, offset = _text.offset;
    write(1, str, sizeof(str)-1);
    for(unsigned int i = 0; i < _text.size; i+=4){
        if(symbol_table[labels_ndx[label_counter]].st_value == i + vma){
            write(1, "\n", 1);
            write(1, symbol_table[labels_ndx[label_counter]].value_str, _SIZE_8BYTE);
            write(1, " <", 2);
            char name[_SIZE(symbol_table[labels_ndx[label_counter]].name_size)];
            getName(file, name, _strtab, symbol_table[labels_ndx[label_counter]].name_size, symbol_table[labels_ndx[label_counter]].st_name);
            write(1, name, symbol_table[labels_ndx[label_counter]].name_size);
            write(1, ">:\n", 3);
            label_counter++;
        }
        char adress[8];
        intToHexStr(adress, i + vma, _SIZE_4BYTE, ' ');
        write(1, adress, 8);
        write(1, ": ", 2);
        for(unsigned int j = i + offset; j < i + offset + 4; j++) {
            char byte[2];
            intToHexStr(byte, file[j], _SIZE_1BYTE, '0');
            write(1, byte, 2);
            write(1, " ", 1);
        }
        write(1, "\t", 1);
        unsigned int instruction = memValue(file, i + offset, _SIZE_4BYTE);
        printInstruction(file, _strtab, instruction, symbol_table, labels_ndx, labels_num, i+vma);
        write(1, "\n", 1);
    }
}

void printSymbols(unsigned  char  *file, Section *sections, Symbol *symbol_table, int strtab, int symbols_num, unsigned int e_shnum, unsigned int e_shstrdnx){
    char text[] = "SYMBOL TABLE:\n";
    write(1, text, sizeof(text)-1);
    for(int i = 0; i < symbols_num; i++) {
        write(1, symbol_table[i].value_str, 8);
        write(1, " ", 1);
        write(1, symbol_table[i].info, 1);
        write(1, " \t", 2);
        if(symbol_table[i].st_shndx < e_shnum){
            char name[_SIZE(sections[symbol_table[i].st_shndx].name_size)];
            getName(file, name, sections[e_shstrdnx], sections[symbol_table[i].st_shndx].name_size, sections[symbol_table[i].st_shndx].shstrtab_offset);
            write(1, name, sections[symbol_table[i].st_shndx].name_size);
        }
        else{
            write(1, "*ABS*", 5);
        }
        write(1, " \t", 2);
        write(1, symbol_table[i].size_str, 8);
        write(1, " ", 1);
        char name[_SIZE(symbol_table[i].name_size)];
        getName(file, name, sections[strtab], symbol_table[i].name_size, symbol_table[i].st_name);
        write(1, name, symbol_table[i].name_size);
        write(1, "\n", 1);
    }
}

void printSections(unsigned char *file, Section *sections, unsigned int e_shnum, unsigned int e_shstrdnx){
    int name_sizeMAX = 13;
    for (int i = 0; i < e_shnum; i++)
        name_sizeMAX = _MAX(sections[i].name_size, name_sizeMAX);
    char text1[] = "Sections:\nIdx Name";
    char text2[] ="Size     VMA";
    write(1, text1, sizeof(text1)-1);
    for(int i = 4; i <= name_sizeMAX; i ++)
        write(1, " ", 1);
    write(1, text2, sizeof(text2)-1);
    
    for (int i = 0; i < e_shnum; i++){
        write(1, "\n", 1);
        char index[] = "  0";
        indexStr(index, i);
        write(1, index, 3);
        write(1, " ", 1);
        char name[_SIZE(sections[i].name_size)];
        getName(file, name, sections[e_shstrdnx], sections[i].name_size, sections[i].shstrtab_offset);
        write(1, name, sections[i].name_size);
        for(int j = sections[i].name_size; j <= name_sizeMAX; j ++)
            write(1, " ", 1);
        write(1, sections[i].size_str, _SIZE_8BYTE);
        write(1, " ", 1);
        write(1, sections[i].vma_str, _SIZE_8BYTE);
    }
    write(1, "\n", 1);
}

int main(int argc, char *argv[]){
    int fd = open(argv[argc-1], O_RDONLY);
    unsigned char file_header[_HEADER_SIZE];
    read(fd, file_header, _HEADER_SIZE);

    unsigned int e_shoff = 0, e_shnum = 0, e_shstrdnx = 0;
    int sizeFile;

    e_shoff = memValue(file_header, _E_SHOFF, _SIZE_4BYTE);
    e_shnum = memValue(file_header, _E_SHNUM, _SIZE_2BYTE);
    e_shstrdnx = memValue(file_header, _E_SHSTRNDX, _SIZE_2BYTE);
    sizeFile = e_shoff + e_shnum*_SECTION_HEADER_SIZE;

    fd = open(argv[argc-1], O_RDONLY);
    unsigned char file[_SIZE(sizeFile)];

    read(fd, file, sizeFile);
    Section sections[_SIZE(e_shnum)];

    fillSections(file, sections, e_shoff, e_shnum, e_shstrdnx);
    int symtab = getSectionIndex(file, sections, ".symtab", 7, e_shnum, e_shstrdnx);
    int strtab = getSectionIndex(file, sections, ".strtab", 7, e_shnum, e_shstrdnx);
    int symbols_num = sections[symtab].size/16 - 1;
    Symbol symbol_table[_SIZE(symbols_num)];
    fillSymbolTable(file, sections, symbol_table, symbols_num, symtab, strtab);
    int text = getSectionIndex(file, sections, ".text", 5, e_shnum, e_shstrdnx);
    int labels_text_ndx[_SIZE(symbols_num)];
    int labels_text_num = getLabelsSection(labels_text_ndx, sections[text], symbol_table, symbols_num);

    printHeader(argv[argc-1]);
    if(argv[1][0] == '-') {
        if (argv[1][1] == 'h')
            printSections(file, sections, e_shnum, e_shstrdnx);
        if (argv[1][1] == 't')
            printSymbols(file, sections, symbol_table, strtab, symbols_num, e_shnum, e_shstrdnx);
        if (argv[1][1] == 'd')
            printText(file, sections[text], sections[strtab], symbol_table, labels_text_ndx, labels_text_num);
    }
    return 0;
}