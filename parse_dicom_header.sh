#!/bin/bash

# Parse dicom header and fetch specific tags
# USAGE:
#     parse_dicom_header.sh <dicom_file>

# Jan Valosek

# DICOM lookup - http://dicomlookup.com/default.asp

if [[ $# -eq 0 ]] || [[ $1 =~ "-h" ]];then
    echo -e "USAGE:\n\t${0##*/} <dicom_file>"
    exit
else
    dcm=${1}
fi

# declare bash array (https://stackoverflow.com/a/3467959)
declare -A tags_to_keywords

tags_to_keywords=(
          ["Patient's Name"]="0010 0010"
          ["Patient ID"]="0010 0020"
          ["Study Date"]="0008 0020"
#          ["Study Time"]="0008 0030"
          ["ID Modality"]="0008 0060"
          ["Protocol Name"]="0018 1030"
          ["Pulse Sequence Name"]="0018 9005"
          ["Sequence Name"]="0018 0024"
          ["Series Description"]="0008 103e"
          ["ID Image Type"]="0008 0008"
          ["Echo Time"]="0018 0081"
          ["Contrast/Bolus Agent"]="0018 0010"
        )

# "${tags_to_keywords[@]}" to expand the values
# "${!tags_to_keywords[@]}" (notice the !) to expand the keys

# Loop across lines om array
for keyword in "${!tags_to_keywords[@]}";do

      value=$(dicom_hdr "$dcm" | grep "${tags_to_keywords[$keyword]}" | awk 'NF{ print $NF }' | sed 's:.*\/\/::g')
      # awk 'NF{ print $NF }' - get the last column; sed 's:.*\/\/::g' - get text after //
      echo -e "$keyword - $value"

done

# TODO - preserve original order of keywords in array