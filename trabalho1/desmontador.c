//Nome: Pedro Henrique Peraçoli Pereira Ceccon
//RA: 247327
//Turma: MC404 B

#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

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

typedef struct {
    int shstrtab_offset;
    int header_offset;
    int offset;
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

char *getSectionName(Section shstrtab, Section _section){
    
}

int main(/*int argc, char *argv[]*/){
    int fd = open(/*argv[argc-1]*/"executavel.x", O_RDONLY);
    unsigned char file_header[_HEADER_SIZE];

    read(fd, file_header, _HEADER_SIZE);

    int e_shoff = 0, e_shnum = 0, e_shstrdnx = 0;
    int sizeFile;

    e_shoff = valorMem(file_header, _E_SHOFF, _SIZE_4BYTE);
    e_shnum = valorMem(file_header, _E_SHNUM, _SIZE_2BYTE);
    e_shstrdnx = valorMem(file_header, _E_SHSTRNDX, _SIZE_2BYTE);

    sizeFile = e_shoff + e_shnum*_SECTION_HEADER_SIZE;

    fd = open(/*argv[argc-1]*/"executavel.x", O_RDONLY);
    unsigned char file[_SIZE(sizeFile)];

    read(fd, file, sizeFile);

    Section sections[_SIZE(e_shnum)];

    for(int i = 0; i < e_shnum; i++){
        sections[i].header_offset = e_shoff + i*_SECTION_HEADER_SIZE;
        sections[i].shstrtab_offset = valorMem(file, sections[i].header_offset, _SIZE_4BYTE);
        sections[i].offset = valorMem(file, sections[i].header_offset + 16, _SIZE_4BYTE);
    }

    printf("%c", file[sections[e_shstrdnx].offset + sections[1].shstrtab_offset + 1]);


    return 0;
}