#Cria uma árvore de busca binária, ou seja, os filhos de um nó n são iguais a 2n+1 e 2n+2


.data
	list:	.space 1000 	#reserva 1000 bytes da memória
	listsz: .word 250 	#declara um vetor de 250 inteiros
str_inserir:	.asciiz "Digite um elemento para inserir (-1 para sair): "
	
.text

main:
############################################## DECLARAÇÃO DOS REGISTRADORES ##############################################
	
	lw $s0, listsz		#$s0 recebe o tamanho do vetor
	la $s1, list		#$s1 recebe o endereço do vetor
	li $s2, 1		#Utilizado apenas para operações matemáticas
	li $t0, 0		#Inicializa $t0 como zero - contador de elementos do array
	li $t1, 0		#Inicializa $t1 como zero - utilizado para declarar o valor dos elementos
	li $t2, 0		#Inicializa $t2 como zero - contador pra fazer 2t+1 e 2t+2
	li $t3, 0		#Inicializa $t3 como zero - para fazer $t3 = 2*$t2
	move $sp, $s1		
	sw $t1, ($s1)		#salva o valor de #t1 no endereço de $s1
	
##########################################################################################################################
	
initlp:	
	jal insercao
	jal esquerda
	beq $t0, $s0, initdn	#se número de elementos atingir o tamanho do vetor, termina
	jal insercao
	jal direita
	beq $t0, $s0, initdn	#se número de elementos atingir o tamanho do vetor, termina
	addi $t2, $t2, 1	#incrementa contador pro 2*t+1
	b initlp
	
insercao:
	li $v0, 4			#Função para printar a string
	la $a0, str_inserir
	syscall				#
	li $v0, 5			#Função para inserir elementos
	syscall
	move $t1, $v0			#
	beq $t1, -1, initdn		#se o valor for -1, termina
	sw $t1, ($sp)			#salva o valor de $t1 no endereço de $s1
	addi $t1, $t1, 1		#Incrementa $t1
	addi $t0, $t0, 1		#Incrementa o numero de elementos
	jr $ra
	
esquerda:
	mul $t3, $t2, 2		#$t3 = 2 * $t2
	addi $t3, $t3, 1	#$t3 = 2 * $t2 + 1
	move $sp, $s1		#$sp recebe o valor de $s1 (endereço do vetor)
	mul $s2, $t3, 4		#$s2 = (2n+1) * 4 (pula n inteiros)
	add $sp, $sp, $s2	#$sp recebe a quantidade de inteiros a serem pulados
	jr $ra

direita:
	mul $t3, $t2, 2		#$t3 = 2 * $t2
	addi $t3, $t3, 2	#$t3 = 2 * $t2 + 2
	move $sp, $s1		#$sp recebe o valor de $s1
	mul $s2, $t3, 4		#$s2 = (2n+2) * 4 (pula n int)
	add $sp, $sp, $s2	#$sp recebe a quantidade de inteiros a serem pulados
	jr $ra


initdn:
	li $v0, 10
	syscall
