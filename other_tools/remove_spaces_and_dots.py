#!/usr/bin/env python3
"""
Replace spaces by underscores (' ' -> '_') and dots by dashes ('.' -> '-') in filenames.

USAGE:
	python remove_spaces_and_dots.py /path/to/directory
	python remove_spaces_and_dots.py /path/to/directory/*
"""

import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("path", nargs="+", help="Input directory, or files (e.g. a shell '*' glob)")
args = parser.parse_args()


def rename_file(filepath):
    directory, filename = os.path.split(filepath)
    new_filename = filename.replace(" ", "_").replace(".", "-", filename.count(".") - 1)
    if new_filename != filename:
        os.rename(filepath, os.path.join(directory, new_filename))


for path in args.path:
    if os.path.isdir(path):
        for filename in os.listdir(path):
            filepath = os.path.join(path, filename)
            if os.path.isfile(filepath):
                rename_file(filepath)
    elif os.path.isfile(path):
        rename_file(path)
