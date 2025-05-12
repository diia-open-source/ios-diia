#!/bin/bash

# Color constants
green_color='\033[0;32m'
red_color='\033[0;31m'
cyan_color='\033[0;36m'
default_color='\033[0m'

echo -e "\n${cyan_color}Adding code generation templates.${default_color}"

# Check the Xcode path
xcode_path="$HOME/Library/Developer/Xcode"
until [ -d "$xcode_path" ]; do
  echo -e "${red_color}The Xcode path isn't correct: ${default_color}$xcode_path"
  read -p "- Please, try again: " xcode_path
done

# Check if a folder with templates exists
xcode_templates_folder="$xcode_path/Templates"
if [ ! -d "$xcode_templates_folder" ]; then
  mkdir "$xcode_templates_folder"
  echo -e "${green_color}Templates folder has been created.${default_color}"
fi

templates_folder_path="$xcode_templates_folder/Code Generation Templates"
templates_folder_name="Code Generation Templates"
if [ -d "$templates_folder_path" ]; then
  rm -r "$templates_folder_path"
fi
cp -r "$templates_folder_name" "$xcode_templates_folder"

if [ -d "$templates_folder_path" ]; then
  echo -e "${green_color}The templates have been added.${default_color}\n"
fi
