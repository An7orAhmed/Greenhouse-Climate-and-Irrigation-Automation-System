```markdown
# Greenhouse Climate and Irrigation Automation System

## Description  
An embedded system for automated greenhouse management using temperature, humidity, and soil moisture sensors. Controls ventilation fans, irrigation pumps, and grow lights through relay outputs. Implements real-time environmental monitoring via LCD display using a PIC microcontroller with C/Proton Basic code.

## Features
- DHT11 temperature/humidity sensor integration
- Soil moisture sensing via analog input
- Relay control for climate systems:
  - Cooling fans (RH >60% activation)
  - Grow lights (temp >30°C cutoff)
  - Water pumps (soil <30% activation)
- 16x2 LCD status display
- Adaptive control loops with hysteresis

## Hardware Configuration (Pin Map)
| Component       | Microcontroller Pin |
|-----------------|---------------------|
| LCD RS          | RB2                 |
| LCD EN          | RB3                 |
| LCD D4-D7       | RB4-RB7             |
| DHT11 Data      | RC0                 |
| Fan Relay       | RC1                 |
| Pump Relay      | RC2                 |
| Light Relay     | RC3                 |
| Soil Sensor     | AN0 (RA0)           |

*Note: Physical wiring diagram may require adjustments based on specific hardware implementation.*

## Code Structure
1. **Sensor Interface**
   - DHT11 protocol handling with timer interrupts
   - 8-bit checksum validation
   - ADC soil moisture conversion (0-100% scale)

2. **Control Logic**
   ```c
   // Temperature control
   if(T_Byte1 > 30) light_rly = 0;  // Disable lights
   if(T_Byte1 < 30) light_rly = 1;  // Enable lights 
   
   // Humidity control
   if(RH_Byte1 > 60) fan_rly = 0;   // Activate fans
   if(RH_Byte1 < 50) fan_rly = 1;   // Deactivate fans
   
   // Irrigation control
   if(soil > 70) motor_rly = 0;     // Stop pump
   if(soil < 30) motor_rly = 1;     // Start pump
   ```

3. **Display System**
   - Custom LCD number formatting
   - Continuous parameter update (2Hz refresh rate)

## Dependencies
- Proprietary LCD library (included)
- MPLAB XC8 compiler
- PIC16F877A microcontroller
- DHT11 sensor library

## Usage
1. Upload compiled firmware to microcontroller
2. Connect sensors per pin mapping
3. Power 12V relay module separately
4. System starts automatic control sequence on boot
```

This README focuses on functional implementation while omitting community/legal elements as requested. The pin map reflects actual code usage from provided snippets, with warnings about potential hardware variations.