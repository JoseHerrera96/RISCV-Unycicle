begin:
addi x1, x0, 7        # x1 = 0 + 7 = 7
addi x2, x0, -10      # x2 = 0 + (-10) = -10
lw x4, 1(x0)          # x4 = MEM[0 + 1] (load word from address 1)
lw x5, 3(x0)          # x5 = MEM[0 + 3] (load word from address 3)
addi x0, x0, 0        # NOP (no operation)
add x6, x4, x5        # x6 = x4 + x5
sw x6, 1(x0)          # MEM[0 + 1] = x6 (store word to address 1)
beq x6, x1, begin      # if (x6 == x1) PC = PC - 28 (branch backward)
 addi x8, x0, 10       # x8 = 0 + 10 = 10
