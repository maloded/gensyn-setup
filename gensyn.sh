#!/bin/bash

# Formatting colors
STRONG="\e[1m"
INFO="\e[34m"      # Blue
SUCCESS="\e[32m"   # Green
WARN="\e[33m"      # Yellow-Orange
ERROR="\e[31m"     # Red
RESET="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

cd $HOME

if [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${STRONG}${WARN}An existing ${INFO}swarm.pem${WARN} file has been found.${RESET}\n"
    echo -e "${STRONG}${WARN}Please select an option:${RESET}"
    echo -e "${STRONG}1) Use the existing swarm.pem${RESET}"
    echo -e "${STRONG}${ERROR}2) Delete existing swarm.pem and start fresh${RESET}"

    while true; do
        read -p $'\e[1mEnter your selection (1 or 2): \e[0m' choice
        if [ "$choice" == "1" ]; then
            echo -e "\n${STRONG}${SUCCESS}[✔] Preserving current swarm.pem...${RESET}"
            mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/"
            mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/" 2>/dev/null
            mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/" 2>/dev/null

            rm -rf "$SWARM_DIR"

            echo -e "${STRONG}${SUCCESS}[✔] Cloning latest rl-swarm repository...${RESET}"
            cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git > /dev/null 2>&1

            mv "$HOME_DIR/swarm.pem" rl-swarm/
            mv "$HOME_DIR/userData.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            mv "$HOME_DIR/userApiKey.json" rl-swarm/modal-login/temp-data/ 2>/dev/null
            break
        elif [ "$choice" == "2" ]; then
            echo -e "${STRONG}${WARN}[✔] Removing existing rl-swarm folder and starting fresh...${RESET}"
            rm -rf "$SWARM_DIR"
            sleep 2
            cd $HOME && git clone https://github.com/gensyn-ai/rl-swarm.git > /dev/null 2>&1
            break
        else
            echo -e "\n${STRONG}${ERROR}[✗] Invalid input. Please type 1 or 2.${RESET}"
        fi
    done
else
    echo -e "${STRONG}${SUCCESS}[✔] No swarm.pem found. Proceeding with repository clone...${RESET}"
    cd $HOME && [ -d rl-swarm ] && rm -rf rl-swarm
    git clone https://github.com/gensyn-ai/rl-swarm.git > /dev/null 2>&1
fi

cd rl-swarm || { echo -e "${STRONG}${ERROR}[✗] Could not access rl-swarm directory. Exiting.${RESET}"; exit 1; }

echo -e "${STRONG}${SUCCESS}[✔] Preparing and launching rl-swarm...${RESET}"
sleep 2
./run_rl_swarm.sh
