# La Fortuna

Back when I was studying at the University of Southampton as part of one module I was gifted a small iPod like device powered by a ATMEL AT90USB1286 microprocessor. It's called the La Ruota Della Fortuna - I call it La Fortuna for short. This repository contains all my messing about with it.

## Requirements

In order to compile code and flash it to the ROM of the La Fortuna you will need the following tools:
- avr-gcc (Complier)
- dfu-programmer (Writes to the board)
- Cygwin (To use make & find tools)

## Windows setup

1. [Download avr-gcc toolchain](https://www.microchip.com/mplab/avr-support/avr-and-arm-toolchains-c-compilers).
2. Create a "Tools" folder in your user directory Eg. `C:\Users\Adam\Tools`.
3. Unzip the folder and place the `avr8-gnu-toolchain-win32_x86` it contains inside your `Tools` folder.
4. Rename it something more sensible such as `avr-toolchain`.
5. [Download dfu-programmer](https://dfu-programmer.github.io/).
6. Unzip the folder and copy to your `Tools` folder.
7. Rename it something more sensible such as `dfu-programmer`.
8. Next [download Cygwin](https://cygwin.com/).
9. Run the installer. When you get to the "Select packages" screen find `make` in the "Devel" folder and set it's dropdown to the latest version.
10. Now add the following paths to you system wide `PATH` variable (replace my username with yours):
    - `C:\Users\Adam\Tools\avr-toolchain\bin`
    - `C:\Users\Adam\Tools\dfu-programmer`
    - `C:\cygwin64\bin` (ensure this appears before `C:\Windows\system32`)
11. Plug your La Fortuna board in via USB.
12. Open Powershell.
13. Switch on your La Fortuna and then press reset button (top left).
14. Run `make` command in Powershell terminal.