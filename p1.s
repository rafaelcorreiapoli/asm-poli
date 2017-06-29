.text
.global main
lista: .space 100
numero: .word 20
size: .word 1

main:
            LDR   r8, =lista @ ponteiro para lista final
            LDR   r9, size  @ valor do size
            LDR r7, numero @ numero
            BL fatora @ vai pro fatora
            B done  @ depois que fatorar vai pro done

fatora:
  MOV r4, #2    @inicia i
loop:
  CMP r4, r7  @ compara i com numero
  BGT done    @ se for maior, acabou o while
  MOV r1, r7 @  coloca numero no divisor
  MOV r2, r4  @  coloca i no dividendo
  BL divide @ chama rotina de dividir
  CMP r1, #0  @r1 tem o resto, comparo com 0
  MOVEQ r7, r0  @ se for 0, copia o quociente inteiro da divisao pro r7 (que se torna o novo numero)
  STREQ r4, [r8], #4  @ guardo o i na lista e incremento o ponteiro pra lista em #4 (1  word)
  ADDEQ r9, r9, #1  @ somo um no contador de números da lista (size)
  ADDNE r4, r4, #1  @ se o resto da divisão não for 0, incremento 1 no i

  B loop

@ Subrotina divide
@ Divide r1 por r2, resto no r1, e quociente no r0
divide:
            STMFD   sp!, {r3, lr} @ Empilha estado anterior
            CMP     r2, #0
            MOVEQ     pc, lr @ retorna da subrotina

            MOV     r0, #0
            MOV     r3, #1

divide_start:
            CMP     r2, r1
            MOVLS   r2, r2, LSL #1
            MOVLS   r3, r3, LSL #1
            BLS     divide_start

divide_next:
            CMP     r1, r2
            SUBCS   r1, r1, r2
            ADDCS   r0, r0, r3
            MOVS    r3, r3, LSR #1
            MOVCC   r2, r2, LSR #1
            BCC     divide_next
            LDMFD   sp!, {r3, lr} @ Restaura estado anterior
            MOV     pc, lr @ retorna da subrotina

done:
          SUB r9, r9, #1
          STR r9, size  @ guardo total de numeros em size
            SWI         0x123456 @ End
