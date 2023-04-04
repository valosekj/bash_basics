"""
Replace spaces by underscores in filenames of all files in the input directory

USAGE:
	python remove_spaces.py /path/to/directory
"""

import os
import re
import sys

# get the directory path from command-line argument
directory = sys.argv[1]

# iterate over each file in the directory
for filename in os.listdir(directory):
    # use regular expression to replace spaces with underscores
    new_filename = re.sub(r"\s+", "_", filename)
    # rename the file with the new filename
    os.rename(os.path.join(directory, filename), os.path.join(directory, new_filename))
