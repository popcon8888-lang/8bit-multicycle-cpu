## Documents

- [ISA Specification](docs/isa.md)

### FSM Diagram
![FSM Diagram](docs/fsm_diagram.png)

### Datapath Diagram
![Datapath Diagram](docs/datapath_diagram.png)

### Simulation Waveforms

#### Test 1: Basic Instruction Flow
MOV, ADD, ST, LD 동작을 검증한 파형입니다.

Expected result:
- R1 = 5
- R2 = 7
- R3 = 12
- data_mem[20] = 12
- R4 = 12

![Simulation Waveform - Basic](docs/simulation_waveform_test1_basic.png)

#### Test 2: JZ Branch
JZ taken 동작을 검증한 파형입니다.

Expected result:
- R1 = 0
- JZ R1, 4 실행
- PC jumps to 4
- R2 = 10

![Simulation Waveform - JZ](docs/simulation_waveform_test2_jz.png)

#### Test 3: ALU Operations
SUB, AND, OR, XOR 동작을 검증한 파형입니다.

Expected result:
- R1 = 12
- R2 = 10
- R3 = 2
- R4 = 8
- R5 = 14
- R6 = 6

![Simulation Waveform - ALU](docs/simulation_waveform_test3_alu.png)