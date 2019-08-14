#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]] && source "${HOME}/.sdkman/bin/sdkman-init.sh"

# Nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# Ruby version 管理 rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# goenv
export PATH="$HOME/.goenv/bin:$PATH"
eval "$(goenv init -)"
