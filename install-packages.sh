#!/bin/bash


function check_root() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "This script must be run as root or with sudo."
        exit 1
    fi
}

check_root



function install_packages() {
    # update apt
    apt update
    if [[ $? -ne 0 ]]; then
        echo "Failed to update package list. Please check your network connection."
        exit 1
    fi

    local packages=("$@")
    for package in "${packages[@]}"; do
        if ! dpkg -l | grep -q "^ii  $package "; then
            echo "Installing $package..."
            apt install -y "$package"
            if [[ $? -ne 0 ]]; then
                echo "Failed to install $package. Please check the package name or your network connection."
                exit 1
            else
                echo "$package installed successfully."
            fi
        else
            echo "$package is already installed."
        fi
    done
}


package_array_list=(
    "ufw"
    "ifmetric"
)

install_packages "${package_array_list[@]}"
if [[ $? -ne 0 ]]; then
    echo "Failed to install one or more packages. Please check the error messages above."
    exit 1
else
    echo "All packages installed successfully."
fi

