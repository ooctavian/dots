#!/bin/bash
get_icon() {
    case "$1" in
    LOAD) echo "" ;;
    CPUTEMP) echo "" ;;
    WIFI) echo "" ;;
    VOLUME) echo "" ;;
    BATTERY) echo "" ;;
    TIME) echo "" ;;
    *) echo "" ;;
    esac
}

# Print i3bar protocol header
echo '{"version": 1, "click_events": true}'
echo '['

first_line=true

i3status | while IFS= read -r line; do
    # Skip empty lines
    [ -z "$line" ] && continue

    # Parse each module (format: █MODULE█text)
    output="["
    index=0
    colors=("#212121" "#303030")
    prev_color=""

    # Split on the block character
    IFS='█' read -ra parts <<<"$line"

    # Process pairs of module name and text
    i=1
    while [ $i -lt ${#parts[@]} ]; do
        module="${parts[$i]}"
        ((i++))
        if [ $i -lt ${#parts[@]} ]; then
            text="${parts[$i]}"
            ((i++))

            # Get icon
            icon=$(get_icon "$module")

            # Alternate background colors
            bg_color="${colors[$((index % 2))]}"

            # Add separator if not first block
            if [ $index -gt 0 ]; then
                output="$output,"
                output="$output{\"full_text\":\"\",\"separator\":false,\"separator_block_width\":0,\"color\":\"$bg_color\",\"background\":\"$prev_color\",\"_decorator\":true}"
            fi

            text="${text// | / }"

            # Add extra space for the last module
            extra_space=""
            if [ $i -ge ${#parts[@]} ]; then
                extra_space=" "
            fi

            # Add main block
            output="$output,{\"full_text\":\" $icon $text$extra_space \",\"separator\":false,\"separator_block_width\":0,\"color\":\"#FFFFFF\",\"background\":\"$bg_color\",\"name\":\"$module\"}"

            prev_color="$bg_color"
            ((index++))
        fi
    done

    # Only output if we found modules
    if [ $index -gt 0 ]; then
        output="$output]"
        # Remove the first comma after opening bracket
        output="${output/[,/[}"

        # Print with proper comma handling
        if [ "$first_line" = true ]; then
            first_line=false
            echo "$output"
        else
            echo ",$output"
        fi
    fi
done

echo ']'
