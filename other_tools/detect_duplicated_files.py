#!/usr/bin/env python
#
# Detect duplicated files using fdupes command.
# Duplicated files are moved to `duplicated_files` directory
#
# Authors: Jan Valosek

# fdupes examples:
# https://www.tecmint.com/fdupes-find-and-delete-duplicate-files-in-linux/

import os
import sys
import shutil
import subprocess
import argparse


def get_parser():
    """
    parser function
    """

    parser = argparse.ArgumentParser(
        description='Detect duplicated files using fdupes command.',
        prog=os.path.basename(__file__).strip('.py')
    )
    parser.add_argument(
        '-i',
        metavar="<folder>",
        required=True,
        type=str,
        help='Path to the folder with files.'
    )

    return parser


def main():
    # Parse the command line arguments
    parser = get_parser()
    args = parser.parse_args()

    dir_path = os.path.abspath(args.i)

    if not os.path.isdir(dir_path):
        print(f'ERROR: {args.i} does not exist.')

    # Get all duplicated files using fdupes command
    #  -f     omit the first file in each set of matches
    output = subprocess.check_output('fdupes -f ' + dir_path, shell=True)

    # parse stdout output into python list
    #   remove b\' at the beginning
    #   remove \' at the end
    #   split str into list by \\n\\n
    duplicated_files = str(output).replace('b\'', '').replace('\'', '').split('\\n\\n')[:-1]

    if not duplicated_files:
        sys.exit(f'There are no duplicated files in {dir_path}.')

    # Create a directory where the duplicated files will be moved (it is safer than their deletion)
    os.makedirs(os.path.join(dir_path, 'duplicated_files'), exist_ok=True)

    for file_in in duplicated_files:
        file_out = file_in.replace(dir_path, os.path.join(dir_path, 'duplicated_files'))
        shutil.move(file_in, file_out)
        print(f'{file_in} moved to {file_out}')


if __name__ == '__main__':
    main()
