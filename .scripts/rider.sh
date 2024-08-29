#!/bin/bash

# ANSI color codes
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"
# Emoji codes
CHECK_MARK="\xE2\x9C\x85"
WARNING="\xE2\x9A\xA0"
ROCKET="\xF0\x9F\x9A\x80"


# Function to prompt user to select solution files to open
select_sln_files() {
    echo "Enter the file number you want to open."
    echo "Enter 0 to exit without opening any files."
    read -p "Your choice: " choice
}

# Store the path to rider in a variable
rider_path=$(which rider)

# Check if the rider_path variable is empty (rider not found)
if [ -z "$rider_path" ]; then
  echo -e "${WARNING} Error: rider not found in PATH ${WARNING}"
  exit 1
fi

# Check if the current directory is inside a git repository and store the repository root path
git_root=$(git -C "$(pwd)" rev-parse --show-toplevel 2>/dev/null)

# If inside a Git repository, search for .sln files relative to the repository root
if [ -n "$git_root" ]; then
  sln_files=($(find "$git_root" -type f -name "*.sln" -exec realpath --relative-to="$git_root" {} \;))
  num_sln_files=${#sln_files[@]}

  if [ $num_sln_files -eq 0 ]; then
    nohup rider sln "." >/dev/null 2>&1 &
    echo -e "${GREEN}${ROCKET} Rider started in the background.${RESET}"
  elif [ $num_sln_files -eq 1 ]; then
    # Automatically open the single found .sln file
    full_sln_path="$git_root/${sln_files[0]}"
    nohup rider sln "$full_sln_path" >/dev/null 2>&1 &
    echo -e "${GREEN}${ROCKET} Rider started for: $full_sln_path${RESET}"
  else
    # List all found .sln files relative to the repository root
    echo -e "${GREEN}${CHECK_MARK} Found the following .sln files in the repository:${RESET}"
    for ((i=0; i<$num_sln_files; i++)); do
      echo -e "${GREEN}$((i + 1)): ${sln_files[$i]}${RESET}"
    done

    # Prompt user to select a file
    select_sln_files

    if [ "$choice" -eq 0 ]; then
      echo "Exiting without opening any files."
      exit 0
    elif [ "$choice" -gt 0 ] && [ "$choice" -le $num_sln_files ]; then
      selected_index=$(( choice - 1 ))
      selected_sln="${sln_files[$selected_index]}"
      full_sln_path="$git_root/$selected_sln"
      nohup "$rider_path" sln "$full_sln_path" >/dev/null 2>&1 &
      echo -e "${GREEN}${ROCKET} Rider started for: $selected_sln${RESET}"
    else
      echo -e "${YELLOW}${WARNING} Invalid index $choice. Please select a valid number or 0 to exit.${RESET}"
    fi
  fi
else
  # If not inside a Git repository, simply run "nohup rider" in the background
  nohup "$rider_path" >/dev/null 2>&1 &
  echo -e "${GREEN}${ROCKET} Rider started in the background.${RESET}"
fi
