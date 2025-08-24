if status is-interactive
end

set fish_greeting

# PATHs
# ---------------------------------
set -U fish_user_paths $HOME/.local/bin $fish_user_paths

# Go executables
set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

# Environment Variables
set -gx EDITOR vim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# csharp bullshit
set -x DOTNET_ROOT $HOME/.dotnet
set -gx PATH $DOTNET_ROOT $DOTNET_ROOT/tools $PATH

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

# Bindings
bind \cf run_zi

zoxide init fish | source
