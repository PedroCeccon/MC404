
#Nome: Pedro Henrique Peracoli Pereira Ceccon
#RA: 247327
#Turma: MC404 B
 
.text
.globl user_main
user_main:
  jal logica_controle
loop_infinito: 
  j loop_infinito
