# La Fortuna Makefile
# Adapted from:    Universal Makefile   Version: 07.05.2015
#                  Copyright (c) 2014-2015 Klaus-Peter Zauner
# See the original licence at the end of the file.

### Target Architecture ###
BOARD := LaFortuna
MCU   := at90usb1286
F_CPU := 8000000UL

### Tool Options ###

# -Os       Determines GCC optimisation approach to enable optimizations except those that often
#           increase code size.
# -mmcu     Sets the MicroController Unit (MCU) (the processor) we are using.
# -DF_CPU   Defines 'F_CPU' as a C macro which is used by the avr libaries to understand your CPU
#           frequency is.
CFLAGS    := -Os -mmcu=$(MCU) -DF_CPU=$(F_CPU)

# -Wl,-u,vfprintf   Passes the -u vfprintf option to the linker.
# -lprintf_flt      Tells the linker to search the printf_flt libary when linking.
# -lm               Tells the linker to search the m (Maths) libary when linking.
# CFLAGS    += -Wl,-u,vfprintf -lprintf_flt -lm  # floating point support

# -fno-strict-aliasing  Sets the no-strict-aliasing flag.
CFLAGS    += -fno-strict-aliasing  # FATfs does not adhere to strict aliasing

# -Wno-main     Disables the no-main warning.
CFLAGS    += -Wno-main             # main() will never return

# -Wall     Turns on a number of warnings.
# -Wextra   Turns on some extra warnings.
CFLAGS    += -Wall -Wextra

# -std          Sets which standard of the C language should be used.
# -pedantic     Turns on all warnings required by the specified langage standard.
# CFLAGS    += -std=c99  -pedantic # lcd library is not c99 clean

# -Wstrict-overflow     Sets a level, from 1 to 5, of warnings related to complier optimisations and
#                       the likihood of signed overflow.
# -fstrict-overflow     Tells the complier to assume that signed overflow won't happen in order to
#                       enable optimisations.
# -Winline              Warn if a function that is declared as inline cannot be inlined.
CFLAGS    += -Wstrict-overflow=5 -fstrict-overflow -Winline              

BUILD_DIR := _build

# Ignoring hidden directories; sorting to drop duplicates:
CFILES := $(shell find . ! -path "*/\.*" -type f -name "*.c")
CPPFILES := $(shell find . ! -path "*/\.*" -type f -name "*.cpp")
CPATHS := $(sort $(dir $(CFILES)))
CPPPATHS += $(sort $(dir $(CPPFILES)))
vpath %.c   $(CPATHS)
vpath %.cpp $(CPPPATHS)
HFILES := $(shell find . ! -path "*/\.*" -type f -name "*.h")
HPATHS := $(sort $(dir $(HFILES)))
vpath %.h $(HPATHS)
CFLAGS += $(addprefix -I ,$(HPATHS))
DEPENDENCIES := $(patsubst %.c,$(BUILD_DIR)/%.d,$(notdir $(CFILES)))
DEPENDENCIES += $(patsubst %.cpp,$(BUILD_DIR)/%.d,$(notdir $(CPPILES)))
OBJFILES     := $(patsubst %.c,$(BUILD_DIR)/%.o,$(notdir $(CFILES)))
OBJFILES     += $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(notdir $(CPPFILES)))

.PHONY: upld prom clean show\: usage

upld: $(BUILD_DIR)/main.hex
	$(info )
	$(info =========== ${BOARD} =============)
	dfu-programmer $(MCU) erase
	dfu-programmer $(MCU) flash $(BUILD_DIR)/main.hex

prom: $(BUILD_DIR)/main.eep upld
	$(info ======== EEPROM: ${BOARD} ========)
	dfu-programmer $(MCU) flash-eeprom $(BUILD_DIR)/main.eep

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	@avr-gcc $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR)
	@avr-g++ $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR)/%.elf %.elf: $(OBJFILES)
	@avr-gcc -mmcu=$(MCU) -o $@  $^

$(BUILD_DIR)/%.hex %.hex: $(BUILD_DIR)/%.elf
	@avr-objcopy -R .eeprom -R .fuse -R .lock -R .signature -O ihex  $<  "$@"

$(BUILD_DIR)/%.eep %.eep: $(BUILD_DIR)/%.elf
	@avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $< "$@"

-include $(sort $(DEPENDENCIES))

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

clean:
	@$(RM) -rf $(BUILD_DIR)

show\:%:
	@echo '$*=$($*)'

usage:
	$(info -------------------------------------------------)
	$(info Usage:)
	$(info Source files can be grouped into subdirectories.)
	$(info To build an executable and attempt to upload it,)
	$(info use just "make". If the executable requires EEPROM) 
	$(info initialization, use "make prom".) 
	$(info )
	$(info make mymain.hex --> to build a hex-file for mymain.c)
	$(info make mymain.eep --> for an EEPROM  file for mymain.c)
	$(info make mymain.elf --> for an elf-file for mymain.c)
	$(info make show:CFILES    --> show C source files to be used)
	$(info make show:CPATHS    --> show C source locations)
	$(info make show:CPPFILES  --> show C++ source files to be used)
	$(info make show:CPPPATHS  --> show C++ source locations)
	$(info make show:HFILES    --> show header files found)
	$(info make show:HPATHS    --> show header locations)
	$(info make show:CFLAGS    --> show compiler options)
	$(info )
	$(info -------------------------------------------------)
	@:


# The MIT License (MIT)
# 
# Copyright (c) 2014-2015 Klaus-Peter Zauner
# 
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#=======================================================================

