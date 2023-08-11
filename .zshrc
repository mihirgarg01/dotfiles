# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.zsh/zsh-autosuggestions/git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

clear() {
    ~/.zsh/clear.sh
}

typeset -g POWERLEVEL9K_INSTANeT_PROMPT=quiet
# neofetch
# alias clear='clear'; 'neofetch'

power() {
  upower -i /org/freedesktop/UPower/devices/battery_BAT0
}

cloudflare() {
  cloudflared tunnel --url http://localhost:3000
}

alias myip='curl http://ipecho.net/plain; echo'
alias distro='cat /etc/*-release'
alias reload='source ~/.zshrc'

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
