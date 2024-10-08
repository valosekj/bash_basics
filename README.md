# Information

Bundle of bash, python and matlab scripts and functions used in routine work.


## General functions:

Used within another scripts for checking input, running commands, logging etc.
 
 `check_input` - script for checking existency of directories or files
 
 `exe` - script for execution certain command and prints its output to log
 
 `show` - script for printing messeage or command's output in various ways (e.g. like ERROR in red color)
 
## Functions for monitoring of running processes:
 
Used for monitoring of running processes.
 
 `get_elapsed_time` - get elapsed time based on processID (pid)
 
 `exe_kill` - execute certain command, monitor it and kill if it runs over time limit
 
 `wait_then_kill` - monitor process based on its pid and kill it if the process run longer than set time limit (can be called from `exe_kill`)
 
 `kill_process` - kill process based on processID (pid)
 
 `get_pid_and_name` - get pid and full process name based on process name
 
 `get_pid` - get pid based on process name
 
## Functions for working with DWI data:

Used for manipulation with diffusion-weighted MRI data (dMRI/DWI)

 `prepare_topup_file` - create a text file for FSL's topup function
 
 `prepare_eddy_file` - create a text file for FSL's eddy function
 
 `get_unique_bvals` - get unique b-values from input bval file
 
 `count_bvals.py` - python script for counting number of DWI volumes acquired with given b-value
 
 `separate_b0_and_dwi` - separate b0 and DWI volumes from 4D diffusion image
 
 `create_dummy_b0_bval_and_bvec` - create dummy bval and bvec files with zeros
  
 `merge_bval_bvec_files` - merge bval/bvec files into one
  
 `parse_SliceTiming_from_json.m` - matlab function for fetching of SliceTiming parameter from .json (used for --slspec flag of FSL's eddy)
 
 `display_bvecs.m` - matlab function for simple 3D visualisation of gradient vectors based on bvec file
 
## Functions for working with MRI data headers:

 `parse_dicom_header.sh` - parse dicom header and fetch specific tags (this script requires [AFNI dicom_hdr](https://afni.nimh.nih.gov/pub/dist/doc/program_help/dicom_hdr.html) function)
 
 `compare_nifti_headers.sh` - compare headers of two input nifti files
    

## Some other functions/scripts:

 `get_ip_adress` - print hostname and IP adress to CLI
 
 `run_matlab` - script for running matlab from command line without opening MATLAB desktop
  
 `send_email_when_finish` - send email when process finish
 
 and some others, see `other_tools` folder

# Usage:

## Clone (download) repo:

```
cd ${HOME}/code
git clone https://github.com/valosekj/bash_basics.git
```

Note: I recommend to clone the repo into `${HOME}/code` directory

## Usage inside scripts

Include following lines into your script:

```
source ${HOME}/code/bash_basics/config_bash.sh

export LOGPATH=./log.txt
exec > >(tee -a $LOGPATH) 2>&1
```

## Usage in terminal/CLI

You can `source` this repo within your `bashrc`/`zshrc` file to be able to use functions in CLI:

```
# Add following lines to your ${HOME}/.bashrc or ${HOME}/.zshrc file
source ${HOME}/code/bash_basics/config_bash.sh
```

# Contact: 

[Jan Valosek](https://janvalosek.com)
