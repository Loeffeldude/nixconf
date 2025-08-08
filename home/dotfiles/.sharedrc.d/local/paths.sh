export SSH_AUTH_SOCK=/home/loeffel/.var/app/com.bitwarden.desktop/data/.bitwarden-ssh-agent.sock
export DOTNET_ROOT=$HOME/.dotnet
export BUN_INSTALL="$HOME/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

alias claude="/home/loeffel/.claude/local/claude"
export ANDROID_HOME=$HOME/Android/Sdk
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
# Local environment sourcing
. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"
