#!/bin/bash
set -e

SRC_DIR=~/fprime/Stage3
BACKUP_ROOT=~/fprime_backups
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/Stage3_backup_$TIMESTAMP"

# Backup
mkdir -p "$BACKUP_DIR"
cp -r "$SRC_DIR/"* "$BACKUP_DIR/"
echo "📦 Stage3 backed up at $BACKUP_DIR"

# Ensure src exists
mkdir -p "$SRC_DIR/src"

# --- ChibiOS stubs and minimal types ---
cat > "$SRC_DIR/src/chlicense.h" << 'EOF'
#define CH_LICENSE_CHECK 0
EOF

cat > "$SRC_DIR/src/chconf.h" << 'EOF'
#define CH_CFG_USE_SEMAPHORES        FALSE
#define CH_CFG_USE_CONDVARS          FALSE
#define CH_CFG_USE_EVENTS            FALSE
#define CH_CFG_USE_MESSAGES          FALSE
#define CH_CFG_USE_DYNAMIC           FALSE
#define CH_CFG_USE_MUTEXES           FALSE
#define CH_CFG_USE_REGISTRY          FALSE
#define CH_CFG_USE_MAILBOXES         FALSE
#define CH_CFG_USE_WAITEXIT          FALSE
#define CH_CFG_OS_INSTANCE_INIT_HOOK NULL
#define CH_CFG_OS_INSTANCE_EXTRA_FIELDS NULL
#define CH_CFG_THREAD_EXTRA_FIELDS   NULL
#define CH_CFG_THREAD_INIT_HOOK      NULL
#define CH_CFG_THREAD_EXIT_HOOK      NULL
#define CH_CFG_CONTEXT_SWITCH_HOOK   NULL
#define CH_CFG_IRQ_PROLOGUE_HOOK     NULL
#define CH_CFG_IRQ_EPILOGUE_HOOK     NULL
#define CH_CFG_IDLE_LOOP_HOOK        NULL
#define CH_CFG_SYSTEM_TICK_HOOK      NULL
#define CH_CFG_SYSTEM_HALT_HOOK      NULL
#define CH_CFG_TRACE_HOOK            NULL
#define CH_CFG_RUNTIME_FAULTS_HOOK   NULL
#define CH_DBG_ENABLE_CHECKS         FALSE
#define CH_DBG_ENABLE_ASSERTS        FALSE
#define CH_DBG_THREADS_PROFILING     FALSE
#define CH_DBG_STATISTICS            FALSE
EOF

cat > "$SRC_DIR/src/halconf.h" << 'EOF'
#define HAL_USE_SERIAL FALSE
#define HAL_USE_SPI    FALSE
EOF

cat > "$SRC_DIR/src/mcuconf.h" << 'EOF'
#define STM32F407xx 1
EOF

cat > "$SRC_DIR/src/board.h" << 'EOF'
/* Minimal board stub */
#endif
EOF

cat > "$SRC_DIR/src/chthreads.h" << 'EOF'
typedef unsigned int tprio_t;
#define NORMALPRIO ((tprio_t)128)
#define THD_WORKING_AREA(name, size) char name[size]
#define chThdCreateStatic(wa, sz, prio, fn, arg) ((void*)0)
#define chThdSleepMilliseconds(ms) ((void)0)

static THD_WORKING_AREA(waMotorThread, 256);
static void MotorThread(void *arg) { (void)arg; while(1) {} }
EOF

cat > "$SRC_DIR/src/chtime.h" << 'EOF'
typedef unsigned int sysinterval_t;
typedef unsigned int systimestamp_t;
typedef unsigned int time_conv_t;
#define TIME_MS2I(ms) ((sysinterval_t)(ms))
EOF

# --- Update Makefile ---
MAKEFILE="$SRC_DIR/Makefile"
if [ -f "$MAKEFILE" ]; then
    grep -q "CXXFLAGS" "$MAKEFILE" && \
    sed -i '/^CXXFLAGS/ s/$/ -Isrc -Isrc\/stubs/' "$MAKEFILE" || \
    echo 'CXXFLAGS += -Isrc -Isrc/stubs' >> "$MAKEFILE"
fi

echo "✅ All ChibiOS stubs, minimal types, macros, and configuration files created in src/"
echo "✅ Makefile updated with include paths -Isrc -Isrc/stubs"
