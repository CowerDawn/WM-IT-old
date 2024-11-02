#!/bin/bash


WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9")
CURRENT_WORKSPACE="1"
WINDOWS=()

BLUE="\033[34m"
RESET="\033[0m"

WALLPAPER=$(cat << "EOF"

                                                      ,----, 
                         ____                       ,/   .`| 
           .---.       ,'  , `.           ,---,   ,`   .'  : 
          /. ./|    ,-+-,.' _ |        ,`--.' | ;    ;     / 
      .--'.  ' ; ,-+-. ;   , ||   ,---,|   :  .'___,/    ,'  
     /__./ \ : |,--.'|'   |  ;| ,'  .' :   |  |    :     |   
 .--'.  '   \' |   |  ,', |  ',---.'   |   :  ;    |.';  ;   
/___/ \ |    ' |   | /  | |  ||   |    '   '  `----'  |  |   
;   \  \;      '   | :  | :  |:   :  .'|   |  |   '   :  ;   
 \   ;  `      ;   . |  ; |--':   |.'  '   :  ;   |   |  '   
  .   \    .\  |   : |  | ,   `---'    |   |  '   '   :  |   
   \   \   ' \ |   : '  |/             '   :  |   ;   |.'    
    :   '  |--";   | |`-'              ;   |.'    '---'      
     \   \ ;   |   ;/                  '---'                 
      '---"    '---'                                         
                                                             
                                       
EOF
)

switch_workspace() {
    local workspace=$1
    if [[ " ${WORKSPACES[@]} " =~ " ${workspace} " ]]; then
        CURRENT_WORKSPACE=$workspace
        echo "Switched to workspace $CURRENT_WORKSPACE"
    else
        echo "Workspace $workspace does not exist"
    fi
}

open_program() {
    local program=$1
    if command -v $program &> /dev/null; then
        WINDOWS+=("$CURRENT_WORKSPACE:$program")
        echo "Opening $program on workspace $CURRENT_WORKSPACE"
        $program &
    else
        echo "Program $program not found"
    fi
}

close_program() {
    local program=$1
    for i in "${!WINDOWS[@]}"; do
        if [[ "${WINDOWS[$i]}" == *":$program" ]]; then
            echo "Closing $program"
            kill $(pgrep -f $program)
            unset WINDOWS[$i]
        fi
    done
}

install_package() {
    local package=$1
    echo "Installing $package..."
    sudo pacman -S $package
}

remove_package() {
    local package=$1
    echo "Removing $package..."
    sudo pacman -R $package
}

display_help() {
    echo "WM-IT: Terminal-based Window Manager"
    echo "-----------------------------------"
    echo "Commands:"
    echo "  [1-9] - Switch to workspace"
    echo "  d - Open a program"
    echo "  q - Close a program"
    echo "  s - Display state"
    echo "  i - Install a package"
    echo "  r - Remove a package"
    echo "  h - Display help"
    echo "  e - Exit WM-IT"
    echo "  p - Close TTY"
    echo "  - - Shutdown PC"
    echo "  shift - Exit WM-IT"
}

display_state() {
    echo "Current Workspace: $CURRENT_WORKSPACE"
    echo "Windows:"
    for window in "${WINDOWS[@]}"; do
        echo "  $window"
    done
}

display_wallpaper() {
    clear
    echo -e "${BLUE}$WALLPAPER${RESET}"
    echo "WM-IT: Terminal-based Window Manager"
    echo "-----------------------------------"
}

display_menu() {
    while true; do
        clear
        display_wallpaper
        display_state
        echo "Time: $(date +"%T")"
        echo "Commands: [1-9] d q s i r h e p - shift"
        read -rsn1 input
        case $input in
            [1-9])
                switch_workspace $input
                ;;
            d)
                read -p "Enter program name: " program
                open_program $program
                ;;
            q)
                read -p "Enter program name to close: " program
                close_program $program
                ;;
            s)
                display_state
                ;;
            i)
                read -p "Enter package name to install: " package
                install_package $package
                ;;
            r)
                read -p "Enter package name to remove: " package
                remove_package $package
                ;;
            h)
                display_help
                ;;
            e)
                exit 0
                ;;
            p)
                echo "Closing TTY..."
                exit 0
                ;;
            -)
                read -p "Shutdown PC? (Y/N): " answer
                if [[ $answer == "Y" || $answer == "y" ]]; then
                    sudo shutdown now
                fi
                ;;
            shift)
                echo "Exiting WM-IT..."
                exit 0
                ;;
            *)
                echo "Unknown command"
                ;;
        esac
    done
}

display_menu
