# User configuration
setopt PROMPT_SUBST

# Basic prompt with hostname and full path
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f $ '
# You may need to manually set your language environment
# export LANG=en_US.UTF-8


# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
unsetopt extended_history

# Enable saving without timestamps
setopt appendhistory
setopt incappendhistory
unsetopt extended_history


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi



# Better tab completion
autoload -U compinit
compinit


# Aliases
alias ll='ls -l'
alias la='ls -al'
alias python='python3'
alias btop='bpytop'
alias speedtest='speedtest-cli'
alias bat='batcat'
alias vi='nvim'
alias paru-clean='paru -Scc --noconfirm && rm -rf ~/.cache/paru/clone/* && echo "🧹 Paru cache fully cleaned!"'



eval "$(zoxide init zsh)"


. "$HOME/.local/bin/env"
