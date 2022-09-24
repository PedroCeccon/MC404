//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B

#include <fcntl.h>
#include <unistd.h>

#define _PATH "../lab2/executavel.x"

#define _SIZE(size) size
#define _MAX(x, y) x>y ? x : y
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

typedef struct {
    int shstrtab_offset;
    int header_offset;
    int offset;
    int vma;
    char vma_str[8];
    int size;
    char size_str[8];
    int name_size;
} Section;

typedef struct{
    int strtab_offset;
    int symbol;
    int section;
    int name_size;
} Symbol;

/*int power(int base, int exponent){
    int result = 1;
    for (int i = 0; i < exponent; i++){
        result = result*base;
    }
    return result;
}*/

int valorMem(unsigned char *file, int offset, int size){
    int valor = 0;
    for(int i = 0; i < size; i++)
        valor += file[offset+i]<<8*i;
    return valor;
}

int getNameSize(unsigned char *file, Section nametab, int nametab_offset){
    int size = 0;
    int a = nametab.offset+nametab_offset;
    int i =0;
    while(file[nametab.offset+nametab_offset+size] != 0)
        size++;
    return size++;
}

void getSectionName(unsigned char *file, char *name, Section shstrtab, Section _section){
    for(int i = 0; i < _section.name_size; i++)
        name[i] = file[shstrtab.offset+_section.shstrtab_offset+i];
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

int getSectionOffset(unsigned char *file, Section *sections, char *str_section, int size_str, int e_shnum, int e_shstrdnx){
    int section_offset = -1;
    for(int i = 0; i < e_shnum; i++){
        char name[_SIZE(sections[i].name_size)];
        getSectionName(file, name, sections[e_shstrdnx], sections[i]);
        if(compareStrings(name, str_section, sections[i].name_size, size_str))
            section_offset = i;
    }
    return section_offset;
}

void intToHexStr(char *str, int value, int number_bytes){
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

void fillSections(unsigned char *file, Section *sections, int e_shoff, int e_shnum, int e_shstrdnx){
    for(int i = 0; i < e_shnum; i++){
        sections[i].header_offset = e_shoff + i*_SECTION_HEADER_SIZE;
        sections[i].shstrtab_offset = valorMem(file, sections[i].header_offset, _SIZE_4BYTE);
        sections[i].vma = valorMem(file, sections[i].header_offset + _SH_ADDR, _SIZE_4BYTE);
        intToHexStr(sections[i].vma_str, sections[i].vma, _SIZE_4BYTE);
        sections[i].offset = valorMem(file, sections[i].header_offset + _SH_OFFSET, _SIZE_4BYTE);
        sections[i].size = valorMem(file, sections[i].header_offset + _SH_SIZE, _SIZE_4BYTE);
        intToHexStr(sections[i].size_str, sections[i].size, _SIZE_4BYTE);
    }
    for(int i = 0; i < e_shnum; i++){
        sections[i].name_size = getNameSize(file, sections[e_shstrdnx], sections[i].shstrtab_offset);
    }
}

void fillSymbolTable(unsigned char *file, Section *sections, Symbol *symbol_table, int symbols_num, int symtab, int strtab){
    int offset_symtab = sections[symtab].offset + 16;
    for(int i = 0; i < symbols_num - 1; i++){
        symbol_table[i].section = valorMem(file, offset_symtab + 14, _SIZE_2BYTE);
        symbol_table[i].symbol = valorMem(file, offset_symtab + 4, _SIZE_4BYTE);
        symbol_table[i].strtab_offset = valorMem(file, offset_symtab, _SIZE_4BYTE);
        symbol_table[i].name_size = getNameSize(file, sections[strtab], symbol_table[i].strtab_offset);
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

void printSections(unsigned char *file, char *file_name, Section *sections, int e_shnum, int e_shstrdnx){
    int name_sizeMAX = 13;
    for (int i = 0; i < e_shnum; i++)
        name_sizeMAX = _MAX(sections[i].name_size, name_sizeMAX);
    char text1[] = ":\tfile format elf32-littleriscv\n\nSections:\nIdx Name";
    char text2[] ="Size     VMA";
    write(1, "\n", 1);
    write(1, file_name, sizeof(_PATH)-1);
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
        getSectionName(file, name, sections[e_shstrdnx], sections[i]);
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

    int e_shoff = 0, e_shnum = 0, e_shstrdnx = 0;
    int sizeFile;

    char _FLAG[] = "-h";

    e_shoff = valorMem(file_header, _E_SHOFF, _SIZE_4BYTE);
    e_shnum = valorMem(file_header, _E_SHNUM, _SIZE_2BYTE);
    e_shstrdnx = valorMem(file_header, _E_SHSTRNDX, _SIZE_2BYTE);
    sizeFile = e_shoff + e_shnum*_SECTION_HEADER_SIZE;

    fd = open(/*argv[argc-1]*/ _PATH, O_RDONLY);
    unsigned char file[_SIZE(sizeFile)];

    read(fd, file, sizeFile);
    Section sections[_SIZE(e_shnum)];

    fillSections(file, sections, e_shoff, e_shnum, e_shstrdnx);
    int symtab = getSectionOffset(file, sections, ".symtab", 7, e_shnum, e_shstrdnx);
    int strtab = getSectionOffset(file, sections, ".strtab", 7, e_shnum, e_shstrdnx);
    int symbols_num = sections[symtab].size/16;
    Symbol symbol_table[_SIZE(symbols_num-1)];
    fillSymbolTable(file, sections, symbol_table, symbols_num, symtab, strtab);
    if(_FLAG[1] == 'h')
        printSections(file, _PATH, sections, e_shnum, e_shstrdnx);

    return 0;
}