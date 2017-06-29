.text
.global main
lista: .space 100
numero: .word 20
size: .word 1

main:
            LDR   r1, =0x1E @ 30 em hexa
            LDR   r8, =lista @ ponteiro para a fila de primos

            LDR r7, numero
            BL fatora
            B done

fatora:
  MOV r4, #2


loop:
  CMP r4, r7
  BGT done
  MOV r1, r7 @  20
  MOV r2, r4  @  i
  BL divide
  CMP r1, #0
  MOVEQ r7, r0
  STREQ r4, [r8], #4
  ADDNE r4, r4, #1

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
          MOV r0, #3
            SWI         0x123456 @ End
