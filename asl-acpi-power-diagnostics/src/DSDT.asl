/**
 * ACPI Source Language (ASL)
 * Table: DSDT (Differentiated System Description Table)
 * Purpose: Enterprise Server Power Management, Thermal Zones & _CPC P-State Optimization
 */

DefinitionBlock ("DSDT.aml", "DSDT", 2, "INTEL", "EPCSVR01", 0x00000001)
{
    Scope (_SB)
    {
        // Power Resource PR00 for PCIe Root Complex
        PowerResource (PR00, 0x00, 0x0000)
        {
            Method (_STA, 0, NotSerialized)
            {
                Return (0x01) // Power ON
            }

            Method (_ON, 0, NotSerialized)
            {
                // Transition hardware rail to full power
            }

            Method (_OFF, 0, NotSerialized)
            {
                // Cut power rail to Low-Power Standby
            }
        }

        // Processor Scope: Multi-Core Power Delivery
        Scope (CPUS)
        {
            Device (CPU0)
            {
                Name (_HID, "ACPI0007")
                Name (_UID, 0x00)

                // Collaborative Processor Performance Control (_CPC)
                Name (_CPC, Package (0x17)
                {
                    0x17, // Revision 3
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00000, 1) }, // Highest Performance
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00004, 1) }, // Nominal Performance
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00008, 1) }, // Lowest Non-linear Perf
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED0000C, 1) }, // Lowest Performance
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00010, 1) }, // Guaranteed Perf Register
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00014, 1) }, // Desired Perf Register
                    ResourceTemplate () { Register (SystemMemory, 32, 0, 0xFED00018, 1) }, // Energy Performance Pref
                })

                Method (_PPC, 0, NotSerialized)
                {
                    // Return current performance limit state
                    Return (0x00)
                }
            }
        }

        // Thermal Zone TZ00
        ThermalZone (TZ00)
        {
            Method (_TMP, 0, NotSerialized)
            {
                // Returns temperature in tenths of Kelvin (e.g. 3532 = 80.2 C)
                Return (\_SB.SEN1.RTMP)
            }

            Method (_CRT, 0, NotSerialized)
            {
                // Critical shutdown threshold: 105 C (3782 dK)
                Return (3782)
            }

            Method (_PSV, 0, NotSerialized)
            {
                // Passive throttling threshold: 85 C (3582 dK)
                Return (3582)
            }

            Method (_TC1, 0, NotSerialized) { Return (0x02) }
            Method (_TC2, 0, NotSerialized) { Return (0x03) }
            Method (_TSP, 0, NotSerialized) { Return (0x0A) } // Sampling period 1000ms
        }
    }
}
