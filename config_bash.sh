#!/bin/bash

# Script for environment configuration

# Run this configuration script from your .bashrc/.zshrc file or within any another script by:
#     source /usr/local/lib/bash_basics/config_bash.sh

# Jan Valosek, fMRI laboratory, Olomouc, 2019-2022

path_to_repo="/usr/local/lib"

# Load functions
source ${path_to_repo}/bash_basics/bash_basic_functions.sh
# Add scripts into PATH variable
export PATH=${PATH}:${path_to_repo}/bash_basics/dwi_tools
export PATH=${PATH}:${path_to_repo}/bash_basics/header_tools
export PATH=${PATH}:${path_to_repo}/bash_basics/other_tools

