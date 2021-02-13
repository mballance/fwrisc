
MKDV_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR := $(dir $(MKDV_MK))
MKDV_TOOL ?= vlsim
MKDV_PLUGINS += cocotb pybfms
RISCV_CC=riscv32-unknown-elf-gcc

MKDV_TEST ?= instr.arith.add

MKDV_TIMEOUT ?= 10ms

TOP_MODULE = fwrisc_rv32i_tb

PYBFMS_MODULES += generic_sram_bfms riscv_debug_bfms gpio_bfms

VLSIM_CLKSPEC = clock=10ns

ifeq (,$(SW_IMAGE))
    ifneq (,$(findstring instr,$(subst ., ,$(MKDV_TEST))))
	SW_IMAGE = $(subst .,_,$(subst instr.,,$(MKDV_TEST))).elf
    endif
    ifneq (,$(findstring instr_irq,$(subst ., ,$(MKDV_TEST))))
	SW_IMAGE = $(subst .,_,$(subst instr_irq.,,$(MKDV_TEST))).elf
    endif
    ifneq (,$(findstring riscv_compliance,$(subst ., ,$(MKDV_TEST))))
	SW_IMAGE = $(subst .,_,$(subst riscv_compliance.,,$(MKDV_TEST))).elf
    endif
    ifneq (,$(findstring zephyr,$(subst ., ,$(MKDV_TEST))))
	SW_IMAGE = $(MKDV_RUNDIR)/$(subst .,_,$(subst zephyr.,,$(MKDV_TEST)))/zephyr/zephyr.elf
    endif
endif

ifeq (,$(MKDV_COCOTB_MODULE))
    ifneq (,$(findstring instr,$(subst ., ,$(MKDV_TEST))))
	MKDV_COCOTB_MODULE = fwrisc_tests.rv32i_instr
    endif
    ifneq (,$(findstring instr_irq,$(subst ., ,$(MKDV_TEST))))
	MKDV_COCOTB_MODULE = fwrisc_tests.rv32i_instr_irq
    endif
    ifneq (,$(findstring riscv_compliance,$(subst ., ,$(MKDV_TEST))))
	MKDV_COCOTB_MODULE = fwrisc_tests.rv32i_compliance
	REF_FILE=$(subst .,_,$(subst riscv_compliance.,,$(MKDV_TEST))).reference_output
    endif
    ifneq (,$(findstring zephyr,$(subst ., ,$(MKDV_TEST))))
	MKDV_COCOTB_MODULE = fwrisc_tests.rv32i_zephyr
	endif
endif

ifneq (,$(REF_FILE))
MKDV_RUN_ARGS += +ref.file=$(PACKAGES_DIR)/riscv-compliance/riscv-test-suite/rv32i_m/I/references/$(REF_FILE)
endif

MKDV_RUN_DEPS += $(SW_IMAGE)
MKDV_RUN_ARGS += +sw.image=$(SW_IMAGE)

MKDV_VL_SRCS += $(TEST_DIR)/fwrisc_rv32i_tb.sv

VLSIM_OPTIONS += -Wno-fatal

include $(TEST_DIR)/../../common/defs_rules.mk
ZEPHYR_BASE=$(PACKAGES_DIR)/zephyr

RULES := 1

include $(TEST_DIR)/../../common/defs_rules.mk

%.elf : %.S
	$(Q)$(RISCV_CC) -o $@ $^ -march=rv32i \
		-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
		-T$(TEST_DIR)/tests/unit/unit.ld

%.elf : $(PACKAGES_DIR)/riscv-compliance/riscv-test-suite/rv32i_m/I/src/%.S
	$(Q)$(RISCV_CC) -o $@ $^ -march=rv32i \
		-I$(TEST_DIR)/../../common/include \
		-I$(PACKAGES_DIR)/riscv-compliance/riscv-test-env \
		-static -mcmodel=medany -fvisibility=hidden -nostdlib -nostartfiles \
		-T$(TEST_DIR)/../../common/include/linkmono.ld

#		-T$(PACKAGES_DIR)/riscv-compliance/riscv-test-env/p/link.ld

$(MKDV_RUNDIR)/%/zephyr/zephyr.elf : $(ZEPHYR_BASE)/samples/%/src/main.c
	rm -rf $*
	mkdir $*
	cd $* ; cmake $(abspath $(^)/../..) \
		-DBOARD=fwrisc_test \
		-DBOARD_ROOT=$(FWRISC_DIR)/zephyr \
		-DSOC_ROOT=$(FWRISC_DIR)/zephyr \
		-DDTS_ROOT=$(FWRISC_DIR)/zephyr \
		-DCMAKE_C_FLAGS="-DSIMULATION_MODE -march=rv32i"
	cd $* ; $(MAKE)
	

vpath %.S $(TEST_DIR)/tests/unit
