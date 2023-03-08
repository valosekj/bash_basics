#!/bin/bash

# Fetch specific keys from BIDS compatible JSON sidecar file
# USAGE:
#     fetch_info_from_json.sh <JSON_FILE>

# Jan Valosek

if [[ $# -eq 0 ]] || [[ $1 =~ "-h" ]];then
    echo "Fetch specific keys from BIDS compatible JSON sidecar file"
    echo -e "\nUSAGE:\n\t${0##*/} <JSON_FILE>"
    exit
else
    fname=${1}
fi

grep "SeriesDescription" ${fname}
grep "ProtocolName" ${fname}

