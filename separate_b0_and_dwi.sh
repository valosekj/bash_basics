#!/bin/bash

# Separate b0 and DWI volumes from 4D diffusion image. The output files will
# have a suffix (_b0 and _dwi) appended to the input file name.

# Jan Valosek, fMRI laboratory Olomouc, Czechia, 2021

if [[ $# -eq 0 ]] || [[ $1 =~ "-h" ]];then
  echo "Separate b0 and DWI volumes from 4D diffusion image. The output files will"
  echo "have a suffix (_b0 and _dwi) appended to the input file name."
  echo -e "\nUSAGE:\n\t${0##*/} <input 4D diffusion image>\nExample:\n\t${0##*/} dmri.nii.gz"
  exit
fi

# Uncomment for debug
#set -x

# Immediately exit if error
set -e -o pipefail


# Global variables
input_image=${1/.nii*/}     # Strip out .nii or .nii.gz sufix if passed
bvalmin=10                  # b-value threshold
volume_number=0
list_of_b0=""               # b0 volumes indexes
list_of_dwi=""              # dwi volumes indexes
merge_command_b0="fslmerge -t ${input_image}_b0.nii.gz"    # concatenate 3D b0 volumes in time to single 4D volume
merge_command_dwi="fslmerge -t ${input_image}_dwi.nii.gz"    # concatenate 3D dwi volumes in time to single 4D volume

# ----
# Script starts here
# ----

echo "Input image: ${input_image}.nii.gz"
echo "Total number of volumes: $(fslval ${input_image}.nii.gz dim4)"
echo ""

# Split 4D volume in time into individual 3D volumes
fslsplit ${input_image}.nii.gz vol -t

# Loop across individual b-values in .bval file
for bvalue in $(cat ${input_image}.bval);do

    # Check if currently processed b-values is lower than bvalmin, if so assume it is b0
    if [[ ${bvalue} -lt ${bvalmin} ]];then
        current_volume="vol$(printf %04d ${volume_number}).nii.gz"
        merge_command_b0="${merge_command_b0} ${current_volume}"
        list_of_b0="${list_of_b0} ${volume_number}"
    # All other b-values are assumed as a dwi volumes
    else
        current_volume="vol$(printf %04d ${volume_number}).nii.gz"
        merge_command_dwi="${merge_command_dwi} ${current_volume}"
        list_of_dwi="${list_of_dwi} ${volume_number}"

    fi

    volume_number=$((${volume_number}+1))  # increment volume_number

done

echo "b0 volume(s) found at position(s):${list_of_b0}"
echo "dwi volume(s) found at position(s):${list_of_dwi}"

${merge_command_b0}
${merge_command_dwi}

# Remove individual 3D volumes created by fslsplit command
rm vol*.nii.gz

echo ""
echo "Done"
