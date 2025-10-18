# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git composer ssh zoxide zsh-autosuggestions zsh-syntax-highlighting)

# Plugins (if applicable in zsh)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh


# Improved completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format "%F{yellow}%d%f"
export PATH="$HOME/tools/node-v14.15.4-linux-x64/bin:$PATH"
eval "$(zoxide init --cmd cd bash)"

# Ruby
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"

# Go setup
export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

# NVM (Node Version Manager) setup
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH=$HOME/.npm-global/bin:$PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Utils
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export LC_TIME=da_DK.UTF-8
export BROWSER=firefox

# Personal Bins
export PATH="$HOME/.local/bin:$PATH"

# IDF env
alias idfenv='source /opt/esp-idf/export.sh'

alias tmux="tmux -f ~/.config/tmux/tmux.conf"
# Aliases for ls and grep with color
alias grep='grep --color=auto'
# Aliases for utilities
alias cat='bat'
alias ls="lsd"

# Tmux
if [ -z "$TMUX" ] && [ "$PS1" ]; then
  tmux attach-session -t main || tmux new-session -s main
fi


if [[ $- == *i*  ]]; then

  cow_choices=(actually alpaca beavis.zen blowfish bong bud-frogs bunny cheese cower cupcake daemon default dragon dragon-and-cow elephant elephant-in-snake eyes flaming-sheep fox ghostbusters head-in hellokitty kiss kitty koala kosh llama luke-koala mech-and-cow meow milk moofasa moose mutilated ren sheep skeleton small stegosaurus stimpy supermilker surgery sus three-eyes turkey turtle tux udder vader vader-koala www)
  cow_choice=${cow_choices[RANDOM % ${#cow_choices[@]}]}
  eye_choices=(-b -d -g -p -s -t -w -y)
  eye_choice=${eye_choices[RANDOM % ${#eye_choices[@]}]}
  fortune | cowsay "$eye_choice" -f "$cow_choice" | lolcat
fi

source <(fzf --zsh)
