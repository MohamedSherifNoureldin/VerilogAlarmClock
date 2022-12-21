# Verilog Alarm Clcok
A Digital Clock/Alarm System implemented using Verilog. This project was created for the Digital Desgin I (CSCE 2301) course. The project was created using Vivado software and implemented on the Basys 3 FPGA board. This readme file is a short summary of the project. For more information like the finite state machines and block diagrams, please refer to the project report.

## Repository Structure
The repository is structured as follows:
- `src/`: Contains the Verilog source code for the project.
- `consts/`: Contains the constraint file for the project.

## Source Files
The source files are as follows:
- `Buzzer.v`: The buzzer module responsible for the alarm sound. Takes as input the clock and enable signal and outputs the sound signal. Adopted from fpga4fun.com.
- `ClockDivider.v`: The clock divider module responsible for dividing the clock signal to the required frequency. Takes as input the clock signal and a reset signal and outputs the divided clock signal. The module has a parameter `n` which is the divider value.
- `CounterModN.v`: The counter module responsible for counting up to a certain value N+1. Takes as input the clock, reset, enable, load, loaded data signals and outputs the count value. The module has a parameter `x` which is the number of bits for the count and parameter `n` which is the maximum value to count to +1.
- `CounterModNUpDown.v`: The counter module responsible for counting up to certain value N+1 or down. Takes as input the clock, reset, up, down, load and loaded data signals and outputs the count value. The module has a parameter `x` which is the number of bits for the count and parameter `n` which is the maximum value to count to +1.
- `Debouncer.v`: The debouncer module responsible for debouncing the input signals comming from a push button. Takes as input the clock, reset, and input signals and outputs the debounced signal.
- `RisingEdgeDetector.v`: The rising edge detector module responsible for detecting the rising edge of a signal. Takes as input the clock, reset, and input signals and outputs the rising edge signal.
- `RisingEdgeDetectorExt.v`: The modified rising edge detector module responsible for detecting the rising edge of a signal but instead of outputing high for only 1 clock cycle, it stays high for an input number of clock cycles. Takes as input the clock, reset, and input signals and outputs the rising edge signal. The module has a parameter `n` which is the number of clock cycles to stay high.
- `Synchronizer.v`: The synchronizer module responsible for synchronizing the input signal to the clock. Takes as input the clock, reset, and input signals and outputs the synchronized signal.
- `PushButtonDetector.v`: The push button detector module responsible for detecting the push of a push button. Takes as input the clock, reset, and input signals and outputs the push signal. This module uses the `Debouncer`, `RisingEdgeDetector.v` and `Synchronizer.v` modules.
- `SegmentDisplay.v`: The segment display module responsible for displaying values on the 7-segment display. Takes as input the value to be displayed, switch indicating which of the 4 seven segment displays to enable, decimal point enable, general enable signals  and outputs the 7-segment display signals along with the anode enables and decimal point output signal to be passed to the Basys 3 board.
- `SystemAdjust.v`: The system adjust module responsible for adjusting the system time. This is the module used when the user is adjusting the time or setting the alarm. Takes as input the clock, reset, enable, push button signals, current time minutes and hours and current alarm minutes and hours and outputs the adjusted time along with the new alarm, LEDs indicating what is being modified, and the adjusted flag indicating whether the time and/or alarm has been adjusted or not.
- `SystemCounter.v`: The system clock module responsible for displaying the current time. This is the module used when the user is not adjusting the time or setting the alarm. Takes as input the clock, reset, enable, load and time to be loaded signals and outputs the current time along.
- `System.v`: The main system module responsible for controlling the system. Takes as input the clock, reset, enable, push button signals, and outputs the 7 segments display signals along with the seven segment enable anodes, LEDs, buzzer signal, and the alarm flag indicating whether the alarm is on or off.

## Team Members
This project was done by the following team members:
- Mohamed Sherif - https://github.com/MohamedSherifNoureldin
- Islam Hassan - https://github.com/islameehassan
- Gehad Salem - https://github.com/GehadSalemFekry
- Reem Said - https://github.com/ReemSaidd