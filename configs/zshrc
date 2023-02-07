# Rebind autocomplete/search key
bindkey "''${key[Up]}" up-line-or-search
bindkey "''${key[Down]}" down-line-or-search

# Start sway
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  exec sway -d &> ~/.sway.log
fi

# Initialise micromamba
eval "$(micromamba shell hook --shell=zsh)"
