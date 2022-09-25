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

void intToHexStr(char *str, unsigned int value, int number_bytes){
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
        str[number_nimbles-digit] = 48;
        digit++;
    }
}

void fillSections(unsigned char *file, Section *sections, unsigned int e_shoff, unsigned int e_shnum, unsigned int e_shstrdnx){
    for(int i = 0; i < e_shnum; i++){
        sections[i].header_offset = e_shoff + i*_SECTION_HEADER_SIZE;
        sections[i].shstrtab_offset = memValue(file, sections[i].header_offset, _SIZE_4BYTE);
        sections[i].vma = memValue(file, sections[i].header_offset + _SH_ADDR, _SIZE_4BYTE);
        intToHexStr(sections[i].vma_str, sections[i].vma, _SIZE_4BYTE);
        sections[i].offset = memValue(file, sections[i].header_offset + _SH_OFFSET, _SIZE_4BYTE);
        sections[i].size = memValue(file, sections[i].header_offset + _SH_SIZE, _SIZE_4BYTE);
        intToHexStr(sections[i].size_str, sections[i].size, _SIZE_4BYTE);
    }
    for(int i = 0; i < e_shnum; i++){
        sections[i].name_size = getNameSize(file, sections[e_shstrdnx], sections[i].shstrtab_offset);
    }
}

void fillSymbolTable(unsigned char *file, Section *sections, Symbol *symbol_table, int symbols_num, int symtab, int strtab){
    Section s =sections[symtab];
    unsigned int offset_symtab = sections[symtab].offset + 16;
    for(int i = 0; i < symbols_num; i++){
        symbol_table[i].st_name = memValue(file, offset_symtab, _SIZE_4BYTE);
        symbol_table[i].st_value = memValue(file, offset_symtab + _ST_VALUE, _SIZE_4BYTE);
        intToHexStr(symbol_table[i].value_str, symbol_table[i].st_value, _SIZE_4BYTE);
        symbol_table[i].st_size = memValue(file, offset_symtab + _ST_SIZE, _SIZE_4BYTE);
        intToHexStr(symbol_table[i].size_str, symbol_table[i].st_size, _SIZE_4BYTE);
        symbol_table[i].st_info = memValue(file, offset_symtab + _ST_INFO, _SIZE_1BYTE);
        symbol_table[i].st_shndx = memValue(file, offset_symtab + _ST_SHNDX, _SIZE_2BYTE);
        symbol_table[i].name_size = getNameSize(file, sections[strtab], symbol_table[i].st_name);
        symbol_table[i].info[0] = (symbol_table[i].st_info == 0) ? 'l' : 'g';
        offset_symtab += 16;
        Symbol f = symbol_table[i];
        int a = 2;
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

void printHeader(char *file_name, int name_size){
    char text[] = ":\tfile format elf32-littleriscv\n\n";
    write(1, "\n", 1);
    write(1, file_name, name_size);
    write(1, text, sizeof(text)-1);
}

void printInstructions(unsigned char *file, unsigned int text_offset, Symbol *symbol_table, unsigned int _start){
    char text[] = "\n Disassembly of section .text:\n";
    write(1, text, sizeof(text)-1);
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
            getName(file, name, sections[e_shstrdnx], sections[symbol_table[i].st_shndx].name_size, sections[symbol_table[i].st_shndx].shstrtab_offset);;
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


int main(/*int argc, char *argv[]*/){
    int fd = open(/*argv[argc-1]*/ _PATH, O_RDONLY);
    unsigned char file_header[_HEADER_SIZE];

    read(fd, file_header, _HEADER_SIZE);

    unsigned int e_shoff = 0, e_shnum = 0, e_shstrdnx = 0;
    int sizeFile;

    char _FLAG[] = "-t";

    e_shoff = memValue(file_header, _E_SHOFF, _SIZE_4BYTE);
    e_shnum = memValue(file_header, _E_SHNUM, _SIZE_2BYTE);
    e_shstrdnx = memValue(file_header, _E_SHSTRNDX, _SIZE_2BYTE);
    sizeFile = e_shoff + e_shnum*_SECTION_HEADER_SIZE;

    fd = open(/*argv[argc-1]*/ _PATH, O_RDONLY);
    unsigned char file[_SIZE(sizeFile)];

    read(fd, file, sizeFile);
    Section sections[_SIZE(e_shnum)];

    fillSections(file, sections, e_shoff, e_shnum, e_shstrdnx);
    int symtab = getSectionIndex(file, sections, ".symtab", 7, e_shnum, e_shstrdnx);
    int strtab = getSectionIndex(file, sections, ".strtab", 7, e_shnum, e_shstrdnx);
    int symbols_num = sections[symtab].size/16 - 1;
    Symbol symbol_table[_SIZE(symbols_num)];
    fillSymbolTable(file, sections, symbol_table, symbols_num, symtab, strtab);

    printHeader(_PATH, sizeof(_PATH)-1);
    if(_FLAG[1] == 'h')
        printSections(file, sections, e_shnum, e_shstrdnx);
    if(_FLAG[1] == 't')
        printSymbols(file, sections, symbol_table, strtab, symbols_num, e_shnum, e_shstrdnx);

    return 0;
}