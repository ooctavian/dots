function venv --description "Create and activate a new virtual environment"
    echo "Creating virtual environment in "(pwd)"/.venv"
    python3 -m venv .venv --upgrade-deps
    source .venv/bin/activate.fish

    # Append .venv to the Git exclude file, but only if it's not
    # already there.
    if test -e .git
        set line_to_append ".venv"
        set target_file ".git/info/exclude"

        if not grep --quiet --fixed-strings --line-regexp "$line_to_append" "$target_file" 2>/dev/null
            echo "$line_to_append" >> "$target_file"
        end
    end

    # Tell Time Machine that it doesn't need to both backing up the
    # virtualenv directory. (macOS-only)
    # See https://ss64.com/mac/tmutil.html
    # tmutil addexclusion .venv
end
