#ifndef CHCORE_H
#define CHCORE_H
#define PORT_IRQ_PROLOGUE()
#define PORT_IRQ_EPILOGUE()
#define PORT_IRQ_HANDLER(name) void name(void)
#define PORT_FAST_IRQ_HANDLER(name) void name(void)
#define PORT_IRQ_IS_VALID_KERNEL_PRIORITY(prio) 1
#define PORT_SETUP_CONTEXT(tp, sp, pc, lr) (void)tp
#define PORT_WA_SIZE 128
#endif
#define PORT_CORE_VARIANT_NAME "Cortex-M4"
#define PORT_INFO "Dummy PORT_INFO"
#define PORT_IRQ_IS_VALID_PRIORITY(prio) 1
#define PORT_SUPPORTS_RT             1
#define PORT_NATURAL_ALIGN           4
#define PORT_STACK_ALIGN             8
#define PORT_WORKING_AREA_ALIGN      8
#define PORT_ARCHITECTURE_NAME       "Cortex-M"
#define PORT_COMPILER_NAME           "GCC"
#define PORT_IDLE_THREAD_STACK_SIZE  128
#define PORT_INT_REQUIRED_STACK      128
