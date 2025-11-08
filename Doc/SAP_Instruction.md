# Instruction Code

| Instruction      | Mnemonic | Opcode | (Hex) | MAI |
| :--------------- | -------: | -----: | ----: | :-: |
| Load Accumulator |      LDA |   0000 |    0H |  H  |
| Addition         |      ADD |   0001 |    1H |  H  |
| Subtruction      |      SUB |   0010 |    2H |  H  |
| Output           |      OUT |   0011 |    3H |  X  |
| Halt             |      HLT |   1111 |    FH |  X  |


# Control Instructions

```python
# Program Counter
CE = "Program Counter INC"
CO = "Counter Output Enable"

# MAR (Memory Address Register)
MI = "MAR Input Enable"

# RAM
RO = "RAM Output Enable"

# Instruction Register
II = "Instruction Input Enable"
IO = "Instruction Output Enable"

# Accumulor (Register A)
AI = "Accumulator Input Enable"
AO = "Accumulator Output Enable"

# ALU
SU = "Adder SUB Enable"
EO = "ALU Output Enable"

# Register B
BI = "Register B Input Enable"

# Output Register
OI = "Output Register's Input Enable"

# Controller (!CLK)
Con_Out_12_bit = { CE, CO, MI, RO, II, IO, AI, AO, SU, EO, BI, OI }

```


# Instruction Cycle

Full Cycle = 6 T Cycle

1. Fetch Cycle

   * T1: Address State = CO, MI
   * T2: Increment State = CE
   * T3: Memory State = RO, II
2. Execution Cycle

   | States |   T4   |   T5   |     T6     |
   | ------ | :----: | :----: | :--------: |
   | LDA    | IO, MI | AI, RO |     x     |
   | ADD    | IO, MI | RO, BI |   EO, AI   |
   | SUB    | IO, MI | RO, BI | EO, AI, SU |
   | OUT    | AO, OI |   x   |     x     |
   | HALT   |   x   |   x   |     x     |

# Clock Triggering

* Module = `Positive Edge`
* Controller = `Negative Edge`
