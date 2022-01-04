#!/usr/bin/python

# Count number of DWI volumes acquired with given b-value

# USAGE from CLI:
#       count_bvals.py <bval_file> <bvalue>
# Example:
#       count_bvals.py dmri.bval 1000

# Jan Valosek

import sys


def main():
    # Fetch input args
    filename = sys.argv[1]
    bval_to_count = sys.argv[2]

    # Check if file exists
    try:
        # Read bval file (it is simple text file)
        file = open(filename, "r")
        content = file.read()
        file.close()
    except IOError:
        print("ERROR: File {} not found".format(filename))
        sys.exit()

    # Convert input values into python list
    content_list = content.split(" ")

    # Remove newline character (\n)
    content_list_without_newline_char = []
    for element in content_list:
        content_list_without_newline_char.append(element.strip())

    # Count number of specific b-values and print it to CLI
    number = content_list_without_newline_char.count(bval_to_count)
    print(number)


if __name__ == "__main__":
    main()
