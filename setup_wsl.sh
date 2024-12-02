#!/bin/bash

# Check if running in WSL
if ! grep -q Microsoft /proc/version; then
    echo "This script must be run in WSL"
    exit 1
fi

# Update and upgrade system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt install -y zsh fzf

# Change default shell to zsh
echo "Changing default shell to zsh..."
chsh -s $(which zsh)

# Configure sudo without password
echo "Configuring sudo privileges..."
# Note: Replace $USER with your actual username if this doesn't work
# For example: echo "john ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR='tee -a' visudo

# Install starship
echo "Installing starship prompt..."
curl -sS https://starship.rs/install.sh | sh

# Create starship config directory and file
mkdir -p ~/.config
touch ~/.config/starship.toml

# Configure starship
cat > ~/.config/starship.toml << 'EOL'
# Your starship configuration here
[status]
style = "red bold"
symbol = "💥 "
format = '[\[$symbol$status\]]($style) '
disabled = false

[helm]
format = 'via [$symbol($version )]($style)'
symbol = '⎈ '
style = 'bold white'
disabled = false
detect_extensions = []
detect_files = [
    'helmfile.yaml',
    'Chart.yaml',
]
detect_folders = []


[jobs]
symbol = '✦ '
threshold = 1
format = "[$symbol$number]($style) "
style = 'bold blue'

[terraform]
format = 'via [$symbol$workspace]($style) '
symbol = '💠 '
style = 'bold 105'
disabled = false
detect_extensions = [
    'tf',
    'hcl',
]
detect_files = []
detect_folders = ['.terraform']



[nodejs]
symbol = "⬢ "
style = "bold green"
disabled = false


[python]
pyenv_version_name = false
pyenv_prefix = 'pyenv '
python_binary = [
    'python',
    'python3',
    'python2',
]
format = 'via [${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
version_format = 'v${raw}'
style = 'yellow bold'
symbol = '🐍 '
disabled = false
detect_extensions = ['py']
detect_files = [
    'requirements.txt',
    '.python-version',
    'pyproject.toml',
    'Pipfile',
    'tox.ini',
    'setup.py',
    '__init__.py',
]
detect_folders = []

[vagrant]
format = 'via [$symbol($version )]($style)'
symbol = '⍱ '
style = 'cyan bold'
disabled = false
detect_extensions = []
detect_files = ['Vagrantfile']
detect_folders = []

[aws]
disabled = true

[username]
style_user = "purple bold"
style_root = "red bold"
format = "[$user]($style) "
disabled = true
show_always = true

[docker_context]
format = "[🐋 $context ](blue bold)"
disabled = false

[kubernetes]
symbol = '☸ '
format = '[$symbol$context \($namespace\)|](bold cyan) '
disabled = false

[gcloud]
disabled = true

[memory_usage]
format = "$symbol [${ram}( | )]($style) "
disabled = false
threshold = -1
symbol = "💾"
style = "bold dimmed green"

[git_branch]
format = " [$symbol$branch]($style) "
symbol = "🌱 "
style = "bold yellow"

[git_commit]
commit_hash_length = 8
style = "bold white"

[git_state]
format = '[\($state( $progress_current of $progress_total)\)]($style) '

[git_status]
conflicted = "🏳"
ahead = "🏎💨"
behind = "😰"
diverged = "😵"
untracked = "🤷"
stashed = "📦"
modified = "📝"
staged = '[++\($count\)](green)'
renamed = "👅"
deleted = "🗑"

[character]
success_symbol = "[➜](bold green) "
error_symbol = "[✗](bold red) "

[battery]
full_symbol = "🔋"
charging_symbol = "⚡️"
discharging_symbol = "💀"

[[battery.display]]
threshold = 15
style = "bold red"

[directory]
truncation_length = 5
format = "📂️ [$path]($style)[$read_only]($read_only_style) | "
read_only_style = 'red'
read_only = '🔒'
EOL

# Install zsh-autosuggestions
echo "Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.zsh}/zsh-autosuggestions

# Configure .zshrc
cat > ~/.zshrc << 'EOL'
eval "$(starship init zsh)"
# Check if the current user is not root, then switch to root
if [[ $(id -u) -ne 0 ]]; then
    sudo -i
fi
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/google-cloud-sdk/path.zsh.inc' ]; then . '/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/google-cloud-sdk/completion.zsh.inc' ]; then . '/google-cloud-sdk/completion.zsh.inc'; fi

alias k='kubectl'

# Ensure that the history is saved and shared across all sessions
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory

# Useful keybindings for fzf
#export FZF_DEFAULT_COMMAND='fd --type f'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#export FZF_ALT_C_COMMAND='fd --type d'
#export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Enable fuzzy completion
#autoload -U compinit && compinit
#autoload -U bashcompinit && bashcompinit
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
EOL

# Configure .bashrc to auto-start zsh
echo "Configuring .bashrc..."
cat >> ~/.bashrc << 'EOL'

# Auto-start zsh
if [ ! -z "$PS1" ]; then
    exec /bin/zsh $*
fi
EOL

echo "Setup complete! Please restart your terminal." 