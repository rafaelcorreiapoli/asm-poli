  .text
  .global main

size:  .word 7
lista: .word 13, 15, 8, 3, 1033, 100134, 111111

numero: .word 10
modulo: .space 100

main:
            LDR r5, =lista
            LDR r6, size
            LDR r7, =modulo
            LDR r2, numero
            ADD r6, r6, #1
mod:
            LDR r1, [r5]
            ADD r5, r5, #4
            SUB r6, r6, #1 @ size = size - 1
            CMP r6, #0
            BLNE divide
            STR r1, [r7], #4
            CMP r6, #0
            BEQ done
            B mod
@ Subrotina divide
@ Divide r1 por r2, resto no r1, e quociente no r0
divide:
            STMFD   sp!, {r3, lr}
            CMP     r2, #0
            BEQ     done

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
            LDMFD   sp!, {r3, lr}
            MOV     pc, lr @ retorna da subrotina

done:
  SWI  0x123456
