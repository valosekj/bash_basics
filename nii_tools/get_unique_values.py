#!/usr/bin/python

# Get and print unique values in nii file

# USAGE from CLI:
#       get_unique_values.py <nii_file>
# Example:
#       get_unique_values.py /path/to/file.nii

# Jan Valosek

import sys
import nibabel as nib
import numpy as np


def main():

    # Print help and exit if no argument or only one was passed
    if len(sys.argv) < 2:
        print('Get unique values in nii file')
        print('USAGE:\n\t{} <nii_file>'.format(sys.argv[0].split("/")[-1]))
        sys.exit()

    # Fetch input args
    filename = sys.argv[1]

    # Check if file exists
    try:
        # Read nii file
        unique_values = np.unique(nib.load(filename).get_fdata())
        print(unique_values)
    except IOError:
        print("ERROR: File {} not found".format(filename))
        sys.exit()


if __name__ == "__main__":
    main()
