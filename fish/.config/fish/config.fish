if status is-interactive
end

set fish_greeting

# PATHs
# ---------------------------------
# Local user bin
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

# Bun
set -U fish_user_paths $HOME/.bun/bin $fish_user_paths
set -x BUN_INSTALL "$HOME/.bun"

# Go
set -U fish_user_paths $HOME/go/bin $fish_user_paths
set -x GOPATH "$HOME/go"

# .NET
set -U fish_user_paths $HOME/.dotnet/tools $fish_user_paths

# Flatpak
set -x FLATPAK_DOWNLOAD_CONCURRENCY 5

# Aliases
# ---------------------------------
alias coverage "go test -coverprofile=coverage.out && go tool cover -html=coverage.out"
alias gitlog="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches"

# run scripts
alias update='~/scripts/update-all.sh'
alias develop="~/scripts/budget-backend.tmux.sh"
alias wall-change="~/scripts/change-wallpaper.i3.sh"

# WiFi
alias wifi-on="nmcli radio wifi on"
alias wifi-off="nmcli radio wifi off"
alias check-wifi="nmcli radio wifi"

# run signal on a different DE or WM
alias signal="run-disown signal-desktop --password-store=\"kwallet6\" && exit"

# apps
alias aliases="pretty-alias"

# vps
alias cdvm="ssh -i ~/.ssh/lightsail-amazon-ubuntu-vps.pem ubuntu@3.71.154.69"

# KDE plasma
alias restart-plasma="systemctl --user restart plasma-plasmashell"

# Bindings
bind \cf run_zi

zoxide init fish | source
