#!/bin/bash


WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9")
CURRENT_WORKSPACE="1"
PROGRAMS=()
WALLPAPER="WM-IT"

function draw_wallpaper() {
    clear
    echo -e "\e[44m\e[37m"
    echo "                                                                             "
    echo "                                                                             "
    echo "  _    _   _____   __  Welcome to WM-IT!                                     "
    echo " | |  | | |_   _| |  | WM-IT the best!                                       "
    echo " | |__| |   | |   |  | WM-IT github:                                         "
    echo " |  __  |   | |   |__| https://github.com/CowerDawn/WM-IT                    "
    echo " | |  | |  _| |_   __  Creater: CowerDawn                                    "
    echo " |_|  |_| |_____| |__| WM-IT - This is a Windows manager inside the terminal!"
    echo "                                                                             "
    echo "                                                                             "
    echo -e "\e[0m"      
}

function draw_menu() {
    echo -e "\e[40m\e[37m"
    echo -e "Workspace: $CURRENT_WORKSPACE | Time: $(date +'%H:%M:%S') | Commands: Super+1-9, Super+d, Super+q, Super+Enter, Super+Shift, Super+-, install, remove, help\e[0m"
}

function switch_workspace() {
    CURRENT_WORKSPACE=$1
    draw_wallpaper
    draw_menu
}

function open_program() {
    PROGRAM=$1
    PROGRAMS+=("$PROGRAM")
    draw_wallpaper
    draw_menu
    echo "Opening $PROGRAM..."
    $PROGRAM &
}

function close_program() {
    PROGRAM=$1
    for i in "${!PROGRAMS[@]}"; do
        if [[ "${PROGRAMS[$i]}" == "$PROGRAM" ]]; then
            unset 'PROGRAMS[$i]'
            pkill -f "$PROGRAM"
            draw_wallpaper
            draw_menu
            echo "Closed $PROGRAM."
            return
        fi
    done
    echo "Program $PROGRAM not found."
}

function install_package() {
    PACKAGE=$1
    echo "Installing $PACKAGE..."
    sudo pacman -S $PACKAGE
    echo "$PACKAGE installed."
}

function remove_package() {
    PACKAGE=$1
    echo "Removing $PACKAGE..."
    sudo pacman -R $PACKAGE
    echo "$PACKAGE removed."
}

function show_help() {
    echo "WM-IT Help:"
    echo "Super + 1-9: Switch workspace"
    echo "Super + d: Open program"
    echo "Super + q: Close program"
    echo "Super + Enter: Open command line"
    echo "Super + Shift: Exit WM-IT"
    echo "Super + -: Shutdown PC"
    echo "install [package]: Install package"
    echo "remove [package]: Remove package"
    echo "help: Show this help"
}

function open_command_line() {
    draw_wallpaper
    draw_menu
    echo "Enter command:"
    read -r COMMAND
    eval "$COMMAND"
}

function shutdown_pc() {
    echo "Shutdown PC? (Y/N)"
    read -rsn1 response
    if [[ $response == "Y" || $response == "y" ]]; then
        sudo shutdown now
    else
        echo "Shutdown canceled."
    fi
}

draw_wallpaper
draw_menu

while true; do
    read -rsn1 input
    case $input in
        "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9")
            switch_workspace $input
            ;;
        "d")
            echo "Enter program name to open:"
            read PROGRAM
            open_program $PROGRAM
            ;;
        "q")
            echo "Enter program name to close:"
            read PROGRAM
            close_program $PROGRAM
            ;;
        "i")
            echo "Enter package name to install:"
            read PACKAGE
            install_package $PACKAGE
            ;;
        "r")
            echo "Enter package name to remove:"
            read PACKAGE
            remove_package $PACKAGE
            ;;
        "h")
            show_help
            ;;
        "")
            read -rsn1 -t 0.1 input
            if [[ $input == "" ]]; then
                open_command_line
            fi
            ;;
        "-")
            shutdown_pc
            ;;
        "S")
            echo "Exiting WM-IT..."
            exit 0
            ;;
    esac
    draw_menu
done
