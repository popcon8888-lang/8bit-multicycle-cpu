# 8-bit Multi-cycle CPU ISA

## 1. CPU Specification

### Item - Description

Data Width - 8-bit 
Instruction Width - 16-bit 
Register Count - 8 registers, R0~R7 
R0 - Hardwired zero 
PC Width - 8-bit 
Instruction Memory - 16-bit x 256 
Data Memory - 8-bit x 256 
Control Type - FSM-based multi-cycle control 

---

## 2. Instruction Format

### R-type

Used by: ADD, SUB, AND, OR, XOR

[15:12] - opcode - Operation code 
[11:9] - rd - Destination register 
[8:6] - rs1 - Source register 1 
[5:3] - rs2 - Source register 2 
[2:0] - unused - Not used 

### I-type

Used by: MOV, LD, ST

[15:12] - opcode - Operation code
[11:9] - rd - Destination register or store source register
[8:0] - imm - Immediate value / memory address

### JZ-type

Used by: JZ

[15:12] - opcode - Operation code
[11:9] - rs1 - Condition register
[8:0] - imm - Jump target address

## 3. Opcode Table

4'h0 - ADD - R - rd = rs1 + rs2
4'h1 - SUB - R - rd = rs1 - rs2
4'h2 - AND - R - rd = rs1 & rs2
4'h3 - OR - R - rd = rs1 | rs2
4'h4 - XOR - R - rd = rs1 ^ rs2
4'h5 - MOV - I - rd = imm
4'h6 - LD - I - rd = data_mem[imm]
4'h7 - ST - I - data_mem[imm] = rd
4'h8 - JMP - J - PC = imm
4'h9 - JZ - JZ - if(rs1 == 0) PC = imm

## 4. ALU Control Table

4'h1 - ADD
4'h2 - SUB
4'h3 - AND
4'h4 - OR
4'h5 - XOR

## 5. Example Program

mem[0] = {4'h5, 3'd1, 9'd5};                // MOV R1, 5
mem[1] = {4'h5, 3'd2, 9'd7};                // MOV R2, 7
mem[2] = {4'h0, 3'd3, 3'd1, 3'd2, 3'b000};  // ADD R3, R1, R2
mem[3] = {4'h7, 3'd3, 9'd20};               // ST R3, 20
mem[4] = {4'h6, 3'd4, 9'd20};               // LD R4, 20
mem[5] = {4'h8, 12'd5};                     // JMP 5

Expected result:
R1 = 5
R2 = 7
R3 = 12
data_mem[20] = 12
R4 = 12


```text