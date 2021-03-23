export GPG_TTY=$(tty)
alias git='DISPLAY= git' # we unset DISPLAY to make gpg-agent use pinentry-curses instead of pinentry-gtk-2
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gaav='git add --all --verbose'
alias gd='git diff --patience'
alias gdh='gd HEAD'
alias gdh1='gd HEAD~1 HEAD'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpull='git pull'
gcm () { DISPLAY= git commit    -m "$*" }
gcma() { DISPLAY= git commit -a -m "$*" }
alias gst='git status'
alias gsw='git switch'

## Taken from snippet OMZ:plugins/git
#alias glg='git log --stat'
#alias glgp='git log --stat -p'
#alias glgg='git log --graph'
#alias glgga='git log --graph --decorate --all'
#alias glgm='git log --graph --max-count=10'
#alias glo='git log --oneline --decorate'
#alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
#alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
#alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
#alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
#alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
#alias glog='git log --oneline --decorate --graph'
#alias gloga='git log --oneline --decorate --graph --all'

