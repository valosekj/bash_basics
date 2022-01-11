#!/usr/bin/python

# Get subject ID subID (e.g., AB-CDE-111 or AB-CDE-111A or sub-01 or sub-001 or sub-0001) from input path
# The script should be BIDS compatible

# USAGE:
#     get_subject_ID /home/some_user/my_data/sub-001/anat
# EXAMPLE OUTPUT:
#     sub-001

# Jan Valosek

import os
import re
import sys


def main():

    # Print help and exit if no argument was passed
    if len(sys.argv) == 1:
        print('Get subject ID from input path.')
        print('USAGE:\n\t{} <input_path>'.format(sys.argv[0].split("/")[-1]))
        sys.exit()

    # Fetch input argument
    input_str = sys.argv[1]

    # If only "." or "./" was passed, use PWD
    if input_str == '.' or input_str == './':
        str_to_search_in = os.getcwd()
    else:
        str_to_search_in = input_str
    # Find subID (e.g., AB-CDE-111 or AB-CDE-111A or sub-01 or sub-001 or sub-0001)
    all_matches = re.findall(r'[A-Z]{2}-[A-Z]{3}-[0-9]{3}A?|sub-[0-9]{2,4}', str_to_search_in)
    # subID was found
    if all_matches:
        subject = all_matches[0]  # re returns list --> it is necessary to get only the first item
        print(subject)


if __name__ == "__main__":
    main()
