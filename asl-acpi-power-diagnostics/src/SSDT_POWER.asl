/**
 * ACPI Source Language (ASL)
 * Table: SSDT (Secondary System Description Table - Power Capping & DVFS)
 */

DefinitionBlock ("SSDT_POWER.aml", "SSDT", 2, "INTEL", "PWR_CAP", 0x00000002)
{
    Scope (\_SB.CPUS.CPU0)
    {
        // Dynamic Power Cap Envelope (Watts)
        Name (PCAP, 0x000000FA) // 250W TDP Cap

        Method (SETP, 1, Serialized)
        {
            // Arg0 = Requested TDP Limit in Watts
            Store (Arg0, PCAP)
            If (LLessEqual (Arg0, 100))
            {
                // Force Energy Efficient C-State entry
                Notify (\_SB.CPUS.CPU0, 0x80)
            }
        }
    }
}
