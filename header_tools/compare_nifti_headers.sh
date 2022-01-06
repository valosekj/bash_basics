#!/bin/bash

# Compare headers of two input nifti files
# Jan Valosek

if [[ $1 == "" ]] || [[ $1 == "--help" ]];then
  echo "Compare nifti header of two files"
  echo -e "\nUSAGE:\n\t${0##*/} <file1> <file2>"
  echo -e "EXAMPLE:\n\t${0##*/} T1_run-01.nii.gz T1_run-02.nii.gz"
  exit
fi

first_file=$1
second_file=$2

fslhd ${first_file} >> firstfile_header.txt
fslhd ${second_file} >> secondfile_header.txt

diff --color firstfile_header.txt secondfile_header.txt
#diff --old-group-format=$'\e[0;31m%<\e[0m' --new-group-format=$'\e[0;33m%>\e[0m' --unchanged-group-format=$'\e[0;32m%=\e[0m' firstfile_header.txt secondfile_header.txt

rm firstfile_header.txt secondfile_header.txt
