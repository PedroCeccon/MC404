//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B

#include <fcntl.h>
#include <unistd.h>

#define _PATH "../lab2/executavel.x"
#define _FLAG "-d"

#define _SIZE(size) size
#define _SIZE_2BYTE 2
#define _SIZE_4BYTE 4
#define _SIZE_8BYTE 8
#define _HEADER_SIZE 52
#define _E_SHOFF 32
#define _E_SHNUM 48
#define _E_SHSTRNDX 50
#define _SECTION_HEADER_SIZE 40
#define _SH_OFFSET 16
#define _SH_ADDR 12
#define _SH_SIZE 20

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

int getSectionNameSize(unsigned char *file, Section shstrtab, Section _section){
    int size = 0;
    while(file[shstrtab.offset+_section.shstrtab_offset+size] != 0)
        size++;
    return size++;
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

void getSectionName(unsigned char *file, char *name, Section shstrtab, Section _section){
    for(int i = 0; i < _section.name_size; i++)
        name[i] = file[shstrtab.offset+_section.shstrtab_offset+i];
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
        sections[i].name_size = getSectionNameSize(file, sections[e_shstrdnx], sections[i]);
    }
}

void printSections(unsigned char *file, char *file_name, Section *sections, int e_shnum, int e_shstrdnx){
    int name_sizeMAX = 14;
    for (int i = 0; i < e_shnum; i++)
        name_sizeMAX = (name_sizeMAX < sections[i].name_size) ? sections[i].name_size : name_sizeMAX;
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
        write(1, "  ", 2);
        char digit[1];
        digit[0] = 48 + i;
        write(1, digit, 1);
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
}


int main(/*int argc, char *argv[]*/){
    int fd = open(/*argv[argc-1]*/ _PATH, O_RDONLY);
    unsigned char file_header[_HEADER_SIZE];

    read(fd, file_header, _HEADER_SIZE);

    int e_shoff = 0, e_shnum = 0, e_shstrdnx = 0;
    int sizeFile;

    e_shoff = valorMem(file_header, _E_SHOFF, _SIZE_4BYTE);
    e_shnum = valorMem(file_header, _E_SHNUM, _SIZE_2BYTE);
    e_shstrdnx = valorMem(file_header, _E_SHSTRNDX, _SIZE_2BYTE);

    sizeFile = e_shoff + e_shnum*_SECTION_HEADER_SIZE;

    fd = open(/*argv[argc-1]*/ _PATH, O_RDONLY);
    unsigned char file[_SIZE(sizeFile)];

    read(fd, file, sizeFile);
    Section sections[_SIZE(e_shnum)];

    fillSections(file, sections, e_shoff, e_shnum, e_shstrdnx);


    printSections(file, _PATH, sections, e_shnum, e_shstrdnx);

    return 0;
}