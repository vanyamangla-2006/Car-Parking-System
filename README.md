# Automated Car Parking System

An RTL implementation of an automated car parking system designed in Verilog HDL. The system features password-secured entry authentication, automatic gate control, and real-time tracking of available parking spaces managed via a Finite State Machine (FSM).

---

## 🚀 Features

*   **Secured Password Entry:** Rejects unauthorized vehicles with an embedded 4-bit password security mechanism[cite: 3].
*   **Intelligent Gate Control:** Automatically opens the entry gate upon successful authentication and closes it safely once the vehicle clears the sensor[cite: 3].
*   **Real-Time Space Management:** Dynamically tracks and updates available capacity (supports up to 100 parking spots)[cite: 3].
*   **Failsafe Counter:** Blocks entry and resets state after two consecutive incorrect password attempts[cite: 3].
*   **FSM-Driven Architecture:** Robust, cycle-accurate state transitions mapping out exact field operational parameters[cite: 3].

---

## 🛠️ Architecture & FSM Design

The system relies on a structural design governed by an internal Finite State Machine (FSM) operating across 4 core states[cite: 3]:

| State | Binary Code | Description |
| :--- | :--- | :--- |
| `IDLE` | `2'b00` | Monitors sensors; waiting for vehicle entry or exit[cite: 3]. |
| `PASSWORD_CHECK` | `2'b01` | Verifies user password; tracks incorrect attempts[cite: 3]. |
| `VEHICLE_ENTRY` | `2'b10` | Holds gate open until vehicle fully clears the entry sensor[cite: 3]. |
| `VEHICLE_EXIT` | `2'b11` | Registers vehicle removal and increments space availability[cite: 3]. |

### System Specifications
*   **Default Master Password:** `4'b1010`[cite: 3]
*   **Maximum Spaces Available:** `100` (`MAX_SPACES`)[cite: 3]

---

## 📁 Repository Structure

```text
├── car_parking_system.v     # Core RTL Design (FSM Module)
├── car_parking_system_tb.v  # Comprehensive Verification Testbench
└── car_parking.vcd          # Value Change Dump (VCD) Simulation Waveform File
