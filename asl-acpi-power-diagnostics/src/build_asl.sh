#!/usr/bin/env bash
# Compile ACPI Source Language (.asl) into ACPI Machine Language (.aml) using Intel iASL compiler
set -e

echo "=== Compiling ACPI ASL to AML Bytecode via Intel iASL ==="

if command -v iasl &> /dev/null; then
    echo "[iASL] Compiling DSDT.asl..."
    iasl -tc -vr DSDT.asl
    echo "[iASL] Compiling SSDT_POWER.asl..."
    iasl -tc -vr SSDT_POWER.asl
    echo "[SUCCESS] Generated DSDT.aml, SSDT_POWER.aml and C hex table headers."
else
    echo "[WARN] Intel iASL compiler not detected in PATH."
    echo "Install via: sudo apt install iasl (Linux) or choco install iasl (Windows)."
    echo "Executing zero-dependency simulated validation harness..."
    node ../runner/run.js
fi
