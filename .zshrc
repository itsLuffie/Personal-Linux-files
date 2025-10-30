# ───────────────────────────────
# COMPILATION FLAGS
# ───────────────────────────────
# export ARCHFLAGS="-arch $(uname -m)"# ═══════════════════════════════════════════════════
# ZSH Configuration - Luffie Edition
# ═══════════════════════════════════════════════════
#
# ───────────────────────────────
# COMPLETION SYSTEM (Load before plugins)
# ───────────────────────────────
autoload -Uz compinit

# Speed up compinit by checking only once per day
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Colored completion (directories, files, etc.)
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Enable menu selection for tab completion
zstyle ':completion:*' menu select

# Enable completion for hidden files
setopt globdots

# Completion options
setopt COMPLETE_IN_WORD    # Complete from both ends of a word
setopt ALWAYS_TO_END       # Move cursor to end of completed word
setopt PATH_DIRS           # Perform path search even on command names with slashes
setopt AUTO_MENU           # Show completion menu on successive tab press
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH    # Add trailing slash for directories

# ───────────────────────────────
# ZINIT PLUGIN MANAGER
# ───────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if not present
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ───────────────────────────────
# PLUGINS
# ───────────────────────────────

# Completions (load first)
zinit light zsh-users/zsh-completions

# Autosuggestions - suggests commands as you type
zinit light zsh-users/zsh-autosuggestions

# Syntax highlighting (load after autosuggestions)
zinit light zdharma-continuum/fast-syntax-highlighting

# History substring search (search with arrow keys)
zinit light zsh-users/zsh-history-substring-search

# Sudo plugin - press ESC twice to add/remove sudo
zinit snippet OMZP::sudo

# Git plugin - adds git aliases
zinit snippet OMZP::git

# Command-not-found - suggests package to install
zinit snippet OMZP::command-not-found

# Extract plugin - universal extract command
zinit snippet OMZP::extract

# Colored man pages
zinit snippet OMZP::colored-man-pages

# FZF tab completion (disabled - uncomment if needed)
# zinit light Aloxaf/fzf-tab

# ───────────────────────────────
# PLUGIN CONFIGURATIONS
# ───────────────────────────────

# Autosuggestions style
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6c7086"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Accept autosuggestion with Ctrl+Space or Right Arrow
bindkey '^ ' autosuggest-accept
bindkey '^[[C' forward-char  # Right arrow moves cursor
bindkey '^f' autosuggest-accept  # Ctrl+f accepts suggestion

# History substring search key bindings (no color highlighting)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# Delete key
bindkey "^[[3~" delete-char

# Disable color highlighting for history search
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''

# ───────────────────────────────
# USER CONFIGURATION
# ───────────────────────────────
setopt PROMPT_SUBST

# Basic prompt with hostname and full path (disabled - using Starship)
# PROMPT='%F{green}%n@%m%f:%F{blue}%~%f $ '

# Language environment
# export LANG=en_US.UTF-8

# ───────────────────────────────
# HISTORY SETTINGS
# ───────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
unsetopt extended_history

# Enable saving without timestamps
setopt appendhistory
setopt incappendhistory
unsetopt extended_history

# ───────────────────────────────
# TRANSIENT PROMPT
# ───────────────────────────────
setopt PROMPT_CR PROMPT_SP

# Add newline after command output for better readability
preexec() { 
    print -rn -- $terminfo[el]
}


FIRST_PROMPT=true
precmd() {
    if [[ $FIRST_PROMPT == true ]]; then
        FIRST_PROMPT=false
    else
        print ""
    fi
}


# Enhanced transient prompt with Starship
zle-line-init() {
    emulate -L zsh
    [[ $CONTEXT == start ]] || return 0
    
    while true; do
        zle .recursive-edit
        local -i ret=$?
        [[ $ret == 0 && $KEYS == $'\4' ]] || break
        [[ -o ignore_eof ]] || exit 0
    done
    
    local saved_prompt=$PROMPT
    local saved_rprompt=$RPROMPT
    PROMPT='❯ '
    RPROMPT=''
    zle .reset-prompt
    PROMPT=$saved_prompt
    RPROMPT=$saved_rprompt
    
    if (( ret )); then
        zle .send-break
    else
        zle .accept-line
    fi
    return ret
}

zle -N zle-line-init

# ───────────────────────────────
# COMPILATION FLAGS
# ───────────────────────────────
# export ARCHFLAGS="-arch $(uname -m)"

# ───────────────────────────────
# ALIASES
# ───────────────────────────────
alias ll='eza -l'
alias la='eza -al'
alias lsa='eza -a --icons'
alias tree='eza -T'
alias ls='eza --icons'
alias python='python3'
alias speedtest='speedtest-cli'
alias vi='nvim'
alias anime='ani-cli'
alias paru-clean='paru -Scc --noconfirm && rm -rf ~/.cache/paru/clone/* && echo "🧹 Paru cache fully cleaned!"'

# Additional useful aliases
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias grep='grep --color=auto'

# Git aliases (if you prefer shorter versions)
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'

# Ollama aliases
alias ollama-start='systemctl start ollama && podman-compose -f ~/.local/share/open-webui/open-webui-compose.yaml up -d'
alias ollama-stop='podman-compose -f ~/.local/share/open-webui/open-webui-compose.yaml down && systemctl stop ollama'
alias ollama-status='systemctl status ollama && podman ps -a | grep open-webui'


# ───────────────────────────────
# STARSHIP & ZOXIDE
# ───────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# ───────────────────────────────
# CUSTOM FUNCTIONS
# ───────────────────────────────

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# ───────────────────────────────
# ENVIRONMENT
# ───────────────────────────────
. "$HOME/.local/bin/env"

# Wine controller support
export SDL_GAMECONTROLLER_ALLOW_STEAM_VIRTUAL_GAMEPAD=1
export WINE_GAMEPAD=1
export SDL_JOYSTICK_DEVICE=/dev/input/event30

# CUDA Environment - Zsh compatible
if [[ -d /opt/cuda/bin ]]; then
    export PATH="/opt/cuda/bin${PATH:+:${PATH}}"
    export LD_LIBRARY_PATH="/opt/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
    export CUDA_HOME="/opt/cuda"
fi
