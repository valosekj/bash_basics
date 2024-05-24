"""
Replace spaces by underscores (' ' -> '_') and dots by dashes ('.' -> '-') in filenames of all files in the input directory

USAGE:
	python remove_spaces_and_dots.py /path/to/directory
"""

import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("path", help="Input path")
args = parser.parse_args()

path = args.path

for filename in os.listdir(path):
    if os.path.isfile(os.path.join(path, filename)):
        new_filename = filename.replace(" ", "_").replace(".", "-", filename.count(".")-1)
        os.rename(os.path.join(path, filename), os.path.join(path, new_filename))
