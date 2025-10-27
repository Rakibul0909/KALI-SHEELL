#!/usr/bin/env bash
# prompt.sh
# Adds Kali-style prompt to ~/.bashrc
# Automatically deletes old .bashrc if exists and creates a fresh one

BASHRC="$HOME/.bashrc"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP="${BASHRC}.bak.${TIMESTAMP}"

# -------- Colors for output --------
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

# Delete existing .bashrc if exists
if [ -f "$BASHRC" ]; then
    cp "$BASHRC" "$BACKUP"
    echo -e "${GREEN}[+] Backup of old .bashrc saved to:${RESET} $BACKUP"
    rm -f "$BASHRC"
    echo -e "${YELLOW}[+] Old .bashrc removed.${RESET}"
fi

# Create a new .bashrc
touch "$BASHRC"
echo -e "${CYAN}[+] New .bashrc created.${RESET}"

# Prompt block
read -r -d '' PROMPT_BLOCK <<'EOB'
# >>> KALI_PROMPT_START
# -------------- Colors --------------
RED="\[\e[31m\]"
GREEN="\[\e[32m\]"
WHITE="\[\e[1;97m\]"      # Bold White path
BLUE="\[\e[34m\]"
MAGENTA="\[\e[35m\]"
CYAN="\[\e[36m\]"
BOLD="\[\e[1m\]"
RESET="\[\e[0m\]"

prompt_color='\[\033[;32m\]'   # Green
info_color='\[\033[1;34m\]'    # Bold Blue

# -------------- Git Branch Function --------------
parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null | awk '{print " "$0}'
}

# -------------- Prompt Setup --------------
export PS1="${prompt_color}┌──(${info_color}Termux${info_color}㉿${BLUE}localhost${prompt_color})-[${WHITE}\w${prompt_color}]\n${prompt_color}└─${info_color}\$${MAGENTA}\$(parse_git_branch)${RESET} "
# <<< KALI_PROMPT_END
EOB

# Append prompt block to new .bashrc
printf "%s\n" "$PROMPT_BLOCK" >> "$BASHRC"
echo -e "${GREEN}[+] Prompt block added to new .bashrc${RESET}"

# Apply immediately if sourced
sourced=0
if [ -n "${BASH_VERSION:-}" ]; then
    if [ "${BASH_SOURCE[0]}" != "$0" ]; then
        sourced=1
    fi
fi

if [ "$sourced" -eq 1 ]; then
    echo -e "${BLUE}[+] Applying changes to current shell...${RESET}"
    source "$BASHRC"
    echo -e "${GREEN}[+] Prompt applied successfully!${RESET}"
else
    echo -e "${YELLOW}[+] Run 'source $BASHRC' or reopen terminal to see the new prompt.${RESET}"
fi
