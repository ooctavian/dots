#!/bin/sh
for b in /sys/class/power_supply/BAT*; do
    [ -e "$b/capacity" ] || continue
    case $(cat "$b/status") in
        Charging) s=CHR ;;
        Discharging) s=BAT ;;
        Full) s=FULL ;;
        *) s=UNK ;;
    esac
    echo "  $s: $(cat "$b/capacity")% "
    exit
done
echo "  No Battery "
