#!/bin/bash

#
# Wrapper for convert command for manipulation with images in terminal
#
# Jan Valosek, 2021, VER=02-05-2021
#

print_help()
	{
	echo -e "Wrapper for convert command for manipulation with images in terminal. Jan Valošek, 2021."
        echo -e "\nUSAGE:\n\t${0##*/} <OPTION> <IMG_1> <IMG_2> <...>\nEXAMPLE:\n\t${0##*/} heic image1.heic image2.heic"
        echo -e "\nOPTIONS:\n\theic - convert heic to jpg\n\tquality - decrease jpg or png quality to 50%"
        exit
	}

if [[ $# -eq 0 ]] || [[ $1 =~ "-h" ]];then
	print_help
fi

option=$1
shift

# Loop across images
for image in "$@";do

	# heic to jpg
	if [[ $option == "heic" ]];then
		convert $image $(echo $image | sed 's/.[hH][eE][iI][cC]/.jpg/g')
    		echo "${image} converted to $(echo $image | sed 's/.[hH][eE][iI][cC]/.jpg/g')"
 	# quality deacrese
  	elif [[ $option == "quality" ]];then
    		convert -quality 50 $image $(echo $image | sed 's/\([.*$]\)/_compressed\1/g')
    		# \( and \) - find a block
    		# \1 - replace with the block between between the \( and the \) above
    		# .*$ - match everything else (.*) to the end of the line ($)
    		echo "${image} quality descreased to 5O%"
  	else
		echo -e "ERROR: Invalid option.\n"; print_help
  	fi

done
