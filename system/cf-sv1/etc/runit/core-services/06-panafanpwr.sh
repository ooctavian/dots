if [ "$(cat /sys/class/dmi/id/product_name 2>/dev/null)" = "CFSV1-2" ]; then
    [ -e /proc/acpi/call ] || modprobe -q acpi_call
    if [ -w /proc/acpi/call ]; then
        msg "Setting quiet fan profile (panafanpwr)..."
        for c in \
            '\_SB.PC00.LPCB.EC0.TFN1._FSL 0' \
            '\_SB.PC00.LPCB.EC0.SEFM 0x01' \
            '\_SB.PC00.LPCB.EC0.SEPL 0x01' \
            '\_SB.PC00.LPCB.EC0.EC88 0xB5 0x79 0x05 0x00'
        do
            printf '%s' "$c" > /proc/acpi/call
            cat /proc/acpi/call >/dev/null
        done
    fi
fi
