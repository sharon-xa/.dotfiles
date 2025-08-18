function copy --description "pipe some output into the clipboard, support x11 and wayland with multiple tools"
    if test -n "$WAYLAND_DISPLAY"
        # Wayland session detected - try tools in order of preference
        if command -q wl-copy
            $argv | wl-copy
        else if command -q cliphist
            $argv | cliphist store
        else
            echo "Error: No Wayland clipboard tool found (try installing wl-clipboard)" >&2
            return 1
        end
    else if test -n "$DISPLAY"
        # X11 session detected - try tools in order of preference
        if command -q xclip
            $argv | xclip -selection clipboard
        else if command -q xsel
            $argv | xsel --clipboard --input
        else
            echo "Error: No X11 clipboard tool found (try installing xclip or xsel)" >&2
            return 1
        end
    else
        # No display server detected - try available tools
        if command -q wl-copy
            $argv | wl-copy
        else if command -q xclip
            $argv | xclip -selection clipboard
        else if command -q xsel
            $argv | xsel --clipboard --input
        else if command -q pbcopy
            $argv | pbcopy
        else
            echo "Error: No clipboard tool found" >&2
            echo "Install one of: wl-clipboard (Wayland), xclip/xsel (X11)" >&2
            return 1
        end
    end
end
