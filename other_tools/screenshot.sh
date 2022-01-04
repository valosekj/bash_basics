#!/bin/bash

# Function for taking arbitrary large screenshot, JV 2018-2021
# You can use the script as a launcher

echo "Type name of the screenshot (including suffix): "
read name

if [ -f "/home/$USER/Obrázky/$name" ];then
	echo "Image $name already exist. Renaming it to _${name}"
	mv /home/$USER/Obrázky/${name} /home/$USER/Obrázky/_${name}
fi

echo "Now, take your screenshot!"
sleep 2
import /home/$USER/Obrázky/$name
echo -e "Screenshot has been sucesfully saved into /home/$USER/Obrázky/\nExiting..."
sleep 3
