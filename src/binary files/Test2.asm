begin:
addi x1, x0, 0         # x1 = 0 (inicializar x1)
addi x2, x0, 5         # x2 = 5
jal x3, swapp             # x3 = PC+4, PC = PC+24 (saltar a PC+24)
lw x4, 0(x1)           # x4 = MEM[x1 + 0]
lw x5, 0(x2)           # x5 = MEM[x2 + 0]
slt x6, x4, x5         # x6 = (x4 < x5) ? 1 : 0
beq x0, x0, END         # if (x0 == x0) PC = PC+28 (siempre salta)
addi x7, x0, 99        # x7 = 99
swapp:
lw x8, 0(x1)           # x8 = MEM[x1 + 0]
lw x9, 0(x2)           # x9 = MEM[x2 + 0]
 sw x9, 0(x1)           # MEM[x1 + 0] = x9
sw x8, 0(x2)           # MEM[x2 + 0] = x8 (swap)
jalr x0, 0(x3)        # PC = x3 + 24, x0 = PC+4 (retorno)
END:
addi x0, x0, 0