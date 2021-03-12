# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

#export PATH="/usr/local/bin:/usr/local/Cellar:/usr/bin:/bin:/usr/sbin:/sbin"
#export PATH="$(brew --prefix homebrew/php/php72)/bin:$PATH"
export PATH=/usr/local/bin:"$(brew --prefix php)/bin:$PATH"
export PATH=~/.composer/vendor/bin:$PATH:~/Library/Python/2.7/bin:~/bin
export PATH=~/.npm-packages/bin:$PATH
export PATH="$PATH:$HOME/.bin"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias phpunit="vendor/bin/phpunit"
alias cda="composer dump-autoload"

alias dh="cd ~/Code/tighten/deadhappy/deadhappy-php-platform"
alias lw="cd ~/Code/tighten/label-worx/lms/labelmanager"

alias nrw="npm run watch"
alias nrs="npm run serve"

alias bs="npm browser-sync start --config .browsersync.js"

#export PATH="$(brew --prefix homebrew/php/php55)/bin:$PATH"
#export PATH="$PATH:/usr/local/opt/php55/bin"
#export PATH="/usr/local/opt/php56/bin:/usr/local/mysql/bin:$PATH"

#export PATH="/usr/local/mysql/bin:$PATH"
#export PATH="/usr/local/php5/bin:/usr/local/mysql/bin:$PATH"
#export PATH=~/.composer/vendor/bin:$PATH

#export PATH="/usr/local/opt/php55/bin:/usr/local/lib/node_modules:$PATH"
#export PATH="/usr/local/lib/node_modules:$PATH"
#export PATH="$/usr/local/Cellar/php55/5.5.17/bin:$PATH"
#export PATH="$(brew --prefix homebrew/php/php55)/bin:$PATH"


# source ~/.xsh
source ~/aliases/github.sh
source ~/aliases/git.sh

# Load NVM
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
