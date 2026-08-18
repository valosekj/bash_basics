#!/usr/bin/python

# Get and print center of mass (COM) for each lesion (connected component) in a nii lesion mask

# USAGE from CLI:
#       get_lesion_com.py <lesion_seg_nii_file>
# Example:
#       get_lesion_com.py sub-chicago014_ses-pre_T2w_lesion_seg.nii.gz

# Jan Valosek

import sys
import nibabel as nib
from scipy.ndimage import label, center_of_mass


def main():

    # Print help and exit if no argument or only one was passed
    if len(sys.argv) < 2:
        print('Get center of mass (COM) for each lesion in a nii lesion mask')
        print('USAGE:\n\t{} <lesion_seg_nii_file>'.format(sys.argv[0].split("/")[-1]))
        sys.exit()

    # Fetch input args
    filename = sys.argv[1]

    # Check if file exists
    try:
        data = nib.load(filename).get_fdata()
    except IOError:
        print("ERROR: File {} not found".format(filename))
        sys.exit()

    # Label each connected component (lesion) with a unique integer
    labeled_data, num_lesions = label(data > 0)
    print("Number of lesions: {}".format(num_lesions))

    # Compute and print COM (in voxel coordinates) for each lesion
    # Round to 2 decimals, but print whole numbers as plain integers
    for lesion_id in range(1, num_lesions + 1):
        com = center_of_mass(labeled_data == lesion_id)
        com_rounded = tuple(int(c) if c == round(c) else round(c, 2) for c in com)
        print("Lesion {}: COM (voxel) = {}".format(lesion_id, com_rounded))


if __name__ == "__main__":
    main()
