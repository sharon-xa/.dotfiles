function set_wallpaper --description 'Change wallpaper and update system themes using matugen'
    if test (count $argv) -eq 0
        echo "Error: Please provide a path to a wallpaper image."
        return 1
    end

    set -l wall_path (realpath $argv[1])

    if status is-interactive
        matugen image $wall_path
    else
        matugen image $wall_path -m dark --source-color-index 0
    end

    hyprctl hyprpaper wallpaper "HDMI-A-1,$wall_path,cover"
end
