#######################################################################
# RUN BY:
#   python -m pytest -v tests/tests.py
# or simply by
#   pytest
#######################################################################

import os
import io
import subprocess


def run_count_bvals(bval):
    """
    Run count_bvals.py script and read test bval file from tests directory
    :return:
    """
    # Get the abs path where is this script located
    script_path = os.path.dirname(os.path.realpath(__file__))
    # Call python script
    proc = subprocess.Popen(
        [os.path.join(script_path, '../dwi_tools/count_bvals.py'),
         os.path.join(script_path, 'sub-001_dwi.bval'),
         bval],
        stdout=subprocess.PIPE
    )

    return proc


def run_get_unique_bvals():
    """
    Run get_unique_bvals shell script and read test bval file from tests directory
    :return:
    """
    # Get the abs path where is this script located
    script_path = os.path.dirname(os.path.realpath(__file__))
    # Call python script
    proc = subprocess.Popen(
        [os.path.join(script_path, '../dwi_tools/get_unique_bvals'),
         os.path.join(script_path, 'sub-001_dwi.bval')],
        stdout=subprocess.PIPE
    )

    return proc


def test_count_bvals_1000():
    """
    Count b-values equal to 1000
    """
    proc = run_count_bvals('1000')
    # Read std output
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        assert line == '3\n'       # \n - new line


def test_count_bvals_550():
    """
    Count b-values equal to 550
    """
    proc = run_count_bvals('550')
    # Read std output
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        assert line == '2\n'       # \n - new line


def test_count_bvals_0():
    """
    Count b-values equal to 0
    """
    proc = run_count_bvals('0')
    # Read std output
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        assert line == '2\n'       # \n - new line


def test_count_bvals_100():
    """
    Count b-values equal to 100
    """
    proc = run_count_bvals('100')
    # Read std output
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        assert line == '0\n'       # \n - new line


def test_get_uniqe_bvals():
    """
    Get unique bvals
    """
    proc = run_get_unique_bvals()
    # Read std output
    for line in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        assert line == '0 550 1000 \n'       # \n - new line
