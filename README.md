# DSP48A1 – Digital IC Design (Spartan-6 FPGA)

## 📌 Overview  
This project is my **first Digital IC Design project**, where I implemented a **parameterized Verilog RTL** model of the **DSP48A1 slice** used in Xilinx Spartan-6 FPGAs.  
The DSP48A1 is a high-performance arithmetic unit that supports **multiply, add, subtract, and accumulation** operations, widely used in digital signal processing applications.  

The design includes:  
- **Fully parameterized** DSP48A1 module  
- **Custom MUX & REG modules**  
- **Pipeline registers** for high-speed operation  
- **Pre-adder, multiplier, and post-adder/subtractor** stages  
- **Comprehensive testbench** with multiple DSP operation mode verifications  
- **Simulation, synthesis, and timing analysis** results  

---

## 🛠 Features  
- **Parameterization** for pipeline stage enable/disable  
- **Configurable reset type** (`SYNC` or `ASYNC`)  
- **Custom data paths** (A, B, C, D inputs)  
- **Carry-in / carry-out support**  
- **Multiple operation modes** via OPMODE control  
- **BCOUT & PCOUT cascading support**  

---

## 📂 Project Structure
```
📁 DSP48A1-Project
│── src/
│   ├── DSP48A1.v        # Main DSP48A1 RTL design
│   ├── MUX.v            # Parameterized multiplexer module
│   ├── REG.v            # Parameterized register module
│
│── tb/
│   ├── DSP48A1_tb.v     # Testbench for DSP48A1
│
│── docs/
│   ├── DSP48A1_Report.pdf  # Full project report
│
│── sim/
│   ├── waveforms/       # Simulation outputs
│   ├── synthesis/       # Synthesis reports
│
└── README.md
```

---

## 🚀 Getting Started

### 1️⃣ Prerequisites  
- **Xilinx ISE** or **Vivado** for synthesis & simulation  
- Basic knowledge of Verilog HDL  

### 2️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/DSP48A1-Project.git
cd DSP48A1-Project
```

### 3️⃣ Run Simulation  
1. Open project in ISE/Vivado  
2. Add `src/` and `tb/` files  
3. Set `DSP48A1_tb.v` as the top module  
4. Run simulation to view waveform results  

---

## 📊 Simulation & Verification  
The testbench verifies:  
- **Reset functionality**  
- **Multiple OPMODE paths** (pre-adder, multiplier, post-adder)  
- **Cascading outputs (BCOUT, PCOUT)**  
- **Carry handling**  

---

## 📈 Synthesis Results  
- Successfully synthesized for **Spartan-6**  
- Meets timing requirements for targeted clock frequency  
- Resource utilization and timing reports included in `/docs`  

---

## 📜 License  
This project is licensed under the **MIT License** – feel free to use and modify.  

---

## 🙌 Acknowledgments  
This is my first **Digital IC Design project** – a major step in my FPGA and RTL design journey.  
