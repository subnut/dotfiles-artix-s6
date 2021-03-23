## Show completion dots
expand_or_complete_with_dots() {
    # print -Pn "%F{red}…%f"
    print -Pn "%F{9}...%f"
    zle expand-or-complete
    zle redisplay
  }
zle -N expand_or_complete_with_dots
bindkey "^I" expand_or_complete_with_dots

## Fancy Ctrl-Z
fancy_ctrl_z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  fi
}
zle -N fancy_ctrl_z
bindkey '^Z' fancy_ctrl_z
