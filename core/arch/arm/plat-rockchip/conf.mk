PLATFORM_FLAVOR ?= rk322x

$(call force,CFG_GIC,y)
$(call force,CFG_SECURE_TIME_SOURCE_CNTPCT,y)
$(call force,CFG_8250_UART,y)

CFG_DT ?= y
CFG_WITH_STATS ?= y
CFG_NUM_THREADS ?= 4
CFG_EARLY_CONSOLE ?= n

ifneq ($(PLATFORM_FLAVOR),rk322x)
CFG_DTB_MAX_SIZE ?= 0x60000
endif

ifeq ($(PLATFORM_FLAVOR),rk322x)
include ./core/arch/arm/cpu/cortex-a7.mk
$(call force,CFG_TEE_CORE_NB_CORE,4)
$(call force,CFG_PSCI_ARM32,y)
$(call force,CFG_BOOT_SECONDARY_REQUEST,y)

CFG_TZDRAM_START ?= 0x68400000
CFG_TZDRAM_SIZE ?= 0x00200000
CFG_SHMEM_START ?= 0x68600000
CFG_SHMEM_SIZE ?= 0x00100000

CFG_EARLY_CONSOLE_BASE ?= UART2_BASE
CFG_EARLY_CONSOLE_SIZE ?= UART2_SIZE
CFG_EARLY_CONSOLE_BAUDRATE ?= 1500000
CFG_EARLY_CONSOLE_CLK_IN_HZ ?= 24000000
endif

ifeq ($(PLATFORM_FLAVOR),rk3399)
include core/arch/arm/cpu/cortex-armv8-0.mk
$(call force,CFG_TEE_CORE_NB_CORE,6)
$(call force,CFG_ARM_GICV3,y)
CFG_CRYPTO_WITH_CE ?= y

CFG_TZDRAM_START ?= 0x30000000
CFG_TZDRAM_SIZE  ?= 0x02000000
CFG_SHMEM_START  ?= 0x32000000
CFG_SHMEM_SIZE   ?= 0x00400000

CFG_EARLY_CONSOLE_BASE ?= UART2_BASE
CFG_EARLY_CONSOLE_SIZE ?= UART2_SIZE
CFG_EARLY_CONSOLE_BAUDRATE ?= 1500000
CFG_EARLY_CONSOLE_CLK_IN_HZ ?= 24000000
endif

ifeq ($(PLATFORM_FLAVOR),px30)
include core/arch/arm/cpu/cortex-armv8-0.mk
$(call force,CFG_TEE_CORE_NB_CORE,4)
CFG_CRYPTO_WITH_CE ?= y

CFG_TZDRAM_START ?= 0x30000000
CFG_TZDRAM_SIZE  ?= 0x02000000
CFG_SHMEM_START  ?= 0x32000000
CFG_SHMEM_SIZE   ?= 0x00400000
endif

ifeq ($(PLATFORM_FLAVOR),rk3588)
include core/arch/arm/cpu/cortex-armv8-0.mk
$(call force,CFG_TEE_CORE_NB_CORE,8)
$(call force,CFG_ARM_GICV3,y)
$(call force,CFG_AUTO_MAX_PA_BITS,y)
$(call force,CFG_CRYPTO_WITH_CE,y)
$(call force,CFG_ROCKCHIP_OTP,y)

CFG_RK_SECURE_BOOT ?= y
# Disable CFG_RK_SECURE_BOOT_SIMULATION to actually fuse the hash into the OTP.
# Enabling this option is necessary to actually enable secure boot, but may
# potentially brick your device.
CFG_RK_SECURE_BOOT_SIMULATION ?= y

CFG_TZDRAM_START ?= 0x30000000
CFG_TZDRAM_SIZE ?= 0x02000000
CFG_SHMEM_START ?= 0x32000000
CFG_SHMEM_SIZE ?= 0x00400000

CFG_EARLY_CONSOLE_BASE ?= UART2_BASE
CFG_EARLY_CONSOLE_SIZE ?= UART2_SIZE
CFG_EARLY_CONSOLE_BAUDRATE ?= 1500000
CFG_EARLY_CONSOLE_CLK_IN_HZ ?= 24000000
endif

ifeq ($(PLATFORM_FLAVOR),rk3576)
include core/arch/arm/cpu/cortex-armv8-0.mk
$(call force,CFG_TEE_CORE_NB_CORE,8)
$(call force,CFG_AUTO_MAX_PA_BITS,y)
$(call force,CFG_CRYPTO_WITH_CE,y)

CFG_TZDRAM_START ?= 0x70000000
CFG_TZDRAM_SIZE  ?= 0x02000000
CFG_SHMEM_START  ?= 0x72000000
CFG_SHMEM_SIZE   ?= 0x00400000

# Enable the shared Rockchip Secure OTP driver (read path).
# ROCKCHIP_OTP_HUK_INDEX = 0x80 (OTP_S words 0x80–0x83, bytes 512–527)
# confirmed for RK3576 — differs from RK3588 (0x104).  Writing (OTP
# provisioning) is gated by CFG_RK3576_PERSIST_HUK which defaults to n.
$(call force,CFG_ROCKCHIP_OTP,y)

# RKRNG_S hardware TRNG (0x2a440000).
# Set CFG_RK3576_RKRNG=y to provide hw_get_random_bytes() using real hardware
# entropy.  When enabled, plat_get_random_stack_canaries() is also overridden
# to read RKRNG directly (core_init_mmu_map runs before thread_init_canaries,
# so the IO mapping is already live), allowing CFG_WITH_SOFTWARE_PRNG=n.
CFG_RK3576_RKRNG ?= n
ifeq ($(CFG_RK3576_RKRNG),y)
$(call force,CFG_WITH_SOFTWARE_PRNG,n)
endif

# Debug UART -- match TF-A's RK_DBG_UART_BASE (UART0 @ 0x2ad40000) so the
# OP-TEE banner appears on the same serial cable as the BL31 log.
CFG_EARLY_CONSOLE := y
CFG_EARLY_CONSOLE_BASE ?= UART0_BASE
CFG_EARLY_CONSOLE_SIZE ?= UART0_SIZE
CFG_EARLY_CONSOLE_BAUDRATE ?= 1500000
CFG_EARLY_CONSOLE_CLK_IN_HZ ?= 24000000
endif

ifeq ($(platform-flavor-armv8),1)
$(call force,CFG_ARM64_core,y)
$(call force,CFG_WITH_ARM_TRUSTED_FW,y)
ta-targets = ta_arm64
endif
