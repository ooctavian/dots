#!/bin/bash
was_master()            { grep -x "$n" <<<"$lastmasters" >/dev/null; }
last_master_ct()        { wc -l <<<"$lastmasters"; }
win_ct()                { bspc query -N -d -n .window | wc -l; }
is_last_master_aleaf()  { bspc query -N -n "${!master_area}.leaf" >/dev/null; }
root_split()            { bspc query -T -n @/ | jq -r '.splitType'; }
master_area="${BSPWMMASTER:-west}" west="@/1" east="@/2" north="$west" south="$east"
case "$master_area" in
    west|east) rs_dir="vertical";;&
    west) stack_area="east";;
    east) stack_area="west";;
    north|south) rs_dir="horizontal";;&
    north) stack_area="south";;
    south) stack_area="north";;
esac
while read a m d n _; do
    if [[ "$a" = "node_remove" || "$a" = "node_transfer" ]] && was_master; then
        if [[ $(last_master_ct) -eq 1 && $(win_ct) -gt 1 ]] && ! is_last_master_aleaf; then
            bspc node @/ -p "$master_area"
            bspc node biggest.window.local -n @/
        fi
        if [[ "$(root_split)" != "$rs_dir" ]]; then
            bspc node "${!master_area}" -p "$stack_area"
            bspc node "${!stack_area}" -n "${!master_area}"
        fi
    fi
    bspc node "${!master_area}" -g private=on -B
    bspc node "${!stack_area}" -g private=off -B
    lastmasters="$(bspc query -N "${!master_area}" -n .descendant_of.local.window)"
done <"$(bspc subscribe -f node_add node_transfer node_remove node_swap)"