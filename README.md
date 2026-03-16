# HPC-X-AEROSPACE-MODULE-1: NSBSolver (Navier–Stokes–Brinkman Solver)

**Team:** Ettore Cirillo, Mattia Gotti, Giulio Martella, Michele Milani, Stefano Pedretti, Daniele Piano, Federico Pinto

## 📌 Overview

This project was developed for the first Module of the High Performance Scientific Computing in Aerospace Engineering course (A.Y. 2025/2026) and serves as the high-fidelity computational kernel for a topology optimization framework applied to power electronics cooling in Advanced Air Mobility. It implements an MPI-parallelized solver for the incompressible Navier-Stokes-Brinkman equations. To efficiently handle complex internal solid geometries without the computational burden of body-fitted meshing, the solver uses a fixed Cartesian grid and enforces internal boundaries via a Darcy penalty term (porosity field).

## 🛠️ Technologies

* **Languages & Parallelism:** C++, MPI.
* **Core Concepts:** Fractional-Step Method, Douglas Direction-Splitting, Marker-And-Cell (MAC) staggered grids, Schur Complement domain decomposition, Thomas Algorithm (TDMA).

## 🚀 Key Features

* **Direction-Splitting Algorithm:** Reduces complex 3D operators into a sequence of highly efficient 1D problems, drastically reducing computational complexity.
* **Distributed Schur Solver:** Employs the Schur complement method to mathematically decouple sub-domains, allowing globally coupled tridiagonal systems to be solved efficiently across multiple MPI processes with near-linear scalability.
* **Memory-Optimized Numerics:** Features persistent scratchpad memories and compressed tridiagonal storage to minimize dynamic memory allocations and memory footprint during the rigorous time-stepping loop.
* **Robust Validation:** Proven second-order spatial and temporal convergence using the Method of Manufactured Solutions (MMS), significantly outperforming the strict design target of 10⁻⁶ seconds per cell-step.

---

## 💻 Quick Start

### Prerequisites

* **C++ Compiler**: C++17 compliant (GCC, Clang).
* **CMake**: Version 3.10 or higher.
* **MPI Library**: Required for distributed parallel execution.

### Building and Running

Use the provided helper scripts to compile and run the simulation:

```bash
# Build the project
./build.sh

# Run the simulation (Ensure data/config.json is configured properly before running)
./run.sh

# Run Tests for derivatives, linear solvers, and physics steps
./test.sh

```

---

## 📂 Project Structure

```text
.
├── data/                       # Configuration
│   ├── config.json             # Runtime parameters
│   └── configFunctions.hpp     # Boundary Condition definitions
├── include/
│   ├── core/                   # Mesh, Fields, TridiagMat
│   ├── io/                     # VTKWriter, InputReader, LogWriter
│   ├── numerics/               # LinearSys, SchurSequentialSolver, Derivatives
│   └── simulation/             # NSBSolver, ViscousStep, PressureStep
├── src/                        # Source implementation
├── tests/                      # Unit testing suite
└── output/                     # VTK simulation results

```

---

## 🧩 Workflow Architecture

The simulation is orchestrated by the `NSBSolver` class, which manages the lifecycle of the simulation data and the time-stepping loop.

### Main Execution Flow

```text
main()
 └─ NSBSolver solver("config.json")
     ├─ setup()
     │  ├─ InputReader::read()           # Parse JSON
     │  ├─ Initializer::setup()          # Allocate Grids, Fields, and BCs
     │
     └─ solve()                          # Main Time Loop
         ├─ ViscousStep::run()           # Predictor
         ├─ PressureStep::run()          # Corrector
         └─ VTKWriter::write()           # Visualization export

```

---
