#!/bin/bash

# Parse dicom header and fetch specific tags
# USAGE:
#     parse_dicom_header.sh <dicom_file>

# Jan Valosek

# DICOM lookup - http://dicomlookup.com/default.asp

if [[ $# -eq 0 ]] || [[ $1 =~ "-h" ]];then
    echo "Parse dicom header and fetch specific tags"
    echo -e "\nUSAGE:\n\t${0##*/} <dicom_file>"
    exit
else
    dcm=${1}
fi

# declare bash array (https://stackoverflow.com/a/3467959)
declare -A tags_to_keywords

tags_to_keywords=(
          ["Patient's Name"]="0010,0010"
          ["Patient ID"]="0010,0020"
          ["Study Date"]="0008,0020"
#          ["Study Time"]="0008,0030"
          ["ID Modality"]="0008,0060"
          ["Protocol Name"]="0018,1030"
          ["Pulse Sequence Name"]="0018,9005"
          ["Sequence Name"]="0018,0024"
          ["Series Description"]="0008,103e"
          ["ID Image Type"]="0008,0008"
          ["Repetition Time"]="0018,0080"
          ["Echo Time"]="0018,0081"
          ["Effective Echo Time"]="0018,9082"
          ["Contrast/Bolus Agent"]="0018,0010"
          ["Series Number"]="0020,0011"
        )

# "${tags_to_keywords[@]}" to expand the values
# "${!tags_to_keywords[@]}" (notice the !) to expand the keys

# Loop across lines om array
for keyword in "${!tags_to_keywords[@]}";do

      value=$(dcmdump --search "${tags_to_keywords[$keyword]}" "$dcm" | head -1 | awk '{print $3}' | sed 's:\[::g' | sed 's:\]::g')
      # "${tags_to_keywords[$keyword]}" - dicom tag (e.g. 0008,0020)
      # head - 1 - keep only the first line (some tags can be presented multiple times)
      # awk - get the third string (i.e. value for certain tag)
      # sed - remove "[" and "]" if presented

      # INFO - AFNI dicom_hdr does not report values for float double tags (e.g. 0018,9082 - EffectiveEchoTime)
      # see also https://github.com/afni/afni/issues/339

      #value=$(dicom_hdr "$dcm" | grep "${tags_to_keywords[$keyword]}" | awk 'NF{ print $NF }' | sed 's:.*\/\/::g')
      # awk 'NF{ print $NF }' - get the last column; sed 's:.*\/\/::g' - remove everything before //

      # Format output into two columns
      printf "%-30s" "$keyword"
      printf "%-20s\n" "$value"

done

# TODO - preserve original order of keywords in array
