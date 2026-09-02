#!/usr/bin/python

# Get and print min/max voxel indices (bounding box) for a binary mask, for x, y, z dimensions

# USAGE from CLI:
#       get_mask_bbox.py <mask_nii_file>
# Example:
#       get_mask_bbox.py sub-046_T2w_lesion-manual.nii.gz

# Jan Valosek

import sys
import nibabel as nib
import numpy as np


def main():

    # Print help and exit if no argument or only one was passed
    if len(sys.argv) < 2:
        print('Get min/max voxel indices (bounding box) for a binary mask, for x, y, z dimensions')
        print('USAGE:\n\t{} <mask_nii_file>'.format(sys.argv[0].split("/")[-1]))
        sys.exit()

    # Fetch input args
    filename = sys.argv[1]

    # Check if file exists
    try:
        data = nib.load(filename).get_fdata()
    except IOError:
        print("ERROR: File {} not found".format(filename))
        sys.exit()

    # Get voxel indices of nonzero (mask) values for each dimension
    x, y, z = np.nonzero(data)

    print("X: min = {}, max = {}".format(x.min(), x.max()))
    print("Y: min = {}, max = {}".format(y.min(), y.max()))
    print("Z: min = {}, max = {}".format(z.min(), z.max()))


if __name__ == "__main__":
    main()
