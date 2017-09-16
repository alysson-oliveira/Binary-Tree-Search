#Cria uma árvore de busca binária, ou seja, os filhos de um nó n são iguais a 2n+1 e 2n+2


.data
	list:	.space 1000 	#reserva 1000 bytes da memória
	listsz: .word 250 	#declara um vetor de 250 inteiros
str_raiz:	.asciiz "Digite o valor da raiz: "
str_inserir:	.asciiz "Digite um elemento para inserir (-1 para sair): "
	
.text

main:
############################################## DECLARAÇÃO DOS REGISTRADORES ##############################################
	
	lw $s0, listsz		#$s0 recebe o tamanho do vetor
	la $s1, list		#$s1 recebe o endereço do vetor
	li $s2, 1		#Utilizado apenas para operações matemáticas
	li $t0, 0		#Inicializa $t0 como zero - contador de elementos do array
	li $t1, 0		#Inicializa $t1 como zero - utilizado para declarar o valor dos elementos
	li $t3, 0		#Inicializa $t3 como zero - para fazer $t3 = 2*t + 1 e 2*t + 2
	li $t4, 0		#Inicializa $t4 como zero - para receber o valor do nó pai do nó a ser implementado
	move $sp, $s1
	sw $t1, ($s1)		#salva o valor de #t1 no endereço de $s1
	
##########################################################################################################################
init_raiz:
	li $v0, 4		#printa string de início
	la $a0, str_raiz
	syscall			#
	li $v0, 5		#recebe inteiro do teclado
	syscall			#
	move $t1, $v0		#$t1 recebe o valor a ser inserido
	sw $t1, ($sp)		#insere o elemento como raiz
	
initlp:	
	jal insercao
	addi $t0, $t0, 1		#Incrementa o numero de elementos
	beq $t0, $s0, initdn		#se número de elementos atingir o tamanho do vetor, termina
	j initlp
	
insercao:
	move $sp, $s1
	li $v0, 4			#Função para printar a string
	la $a0, str_inserir
	syscall				#
	li $v0, 5			#Função para inserir elementos
	syscall
	move $t1, $v0			#$t1 recebe o valor do usuário
	beq $t1, -1, initdn		#se o valor for -1, termina
	lw $t4, ($sp)			#recebe o valor do nó atual
	slt $s2, $t1, $t4		#if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita
	b insercao
	
esquerda:
	mul $t3, $t3, 2			#$t3 = 2 * $t2
	addi $t3, $t3, 1		#$t3 = 2 * $t2 + 1
	mul $s2, $t3, 4			#$s2 = (2n+1) * 4 (pula n inteiros)
#	addi $t2, $t2, 1		#incrementa o contador
	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#$sp pula para o filho da esquerda
	lw $t4, ($sp)			#recebe o valor do nó atual
	beq $t4, 0, armazena
	#####
	slt $s2, $t1, $t4		#if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita
	#####

direita:
	mul $t3, $t3, 2			#$t3 = 2 * $t2
	addi $t3, $t3, 2		#$t3 = 2 * $t2 + 2
	mul $s2, $t3, 4			#$s2 = (2n+2) * 4 (pula n int)
#	addi $t2, $t2, 2		#incrementa o contador
	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#pula para a poscao do vetor que recebera o novo valor
	lw $t4, ($sp)			#recebe o valor do nó atual
	beq $t4, 0, armazena
	#####
	slt $s2, $t1, $t4		#if (valor digitado < nó atual) $s2 = 1	    else $s2 = 0
	beq $s2, 1, esquerda
	beq $s2, 0, direita
	#####

armazena:
	move $sp, $s1			#retorna para o no raiz
	add $sp, $sp, $s2		#pula para a poscao do vetor que recebera o novo valor
	sw $t1, ($sp)			#salva o valor de $t1 no endereço de $s1
	li $t3, 0			#zera o contador
	j initlp


initdn:
	li $v0, 10
	syscall
