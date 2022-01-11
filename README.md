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
 
 Example dMRI analysis with aforementioned scripts for complete AP acquisition and PA acquisition with b0 only can look like:
 
 ```
# Split input AP DWI 4D volume and get _b0 and _dwi files
separate_b0_and_dwi dwi_AP.nii.gz
# Fetch total readout time    
readout_time=$(get_readout dwi_AP.json)
# Create txt topup config file and merge AP and PA b0 files
prepare_topup_files dwi_AP_b0.nii.gz dwi_PA.nii.gz "AP-PA" ${readout_time}
# Run FSL's topup
topup ...

# Merge original complete AP 4D DWI and PA 4D DWI b0
fslmerge -t dwi_merged.nii.gz dwi_AP.nii.gz dwi_PA.nii.gz
# Create .bval and .bvec files for PA b0 DWI
create_dummy_b0_bval_and_bvec dwi_PA.nii.gz
# Merge bval and bvec files for AP and PA acquisitions 
merge_bval_bvec_files dwi_AP.bval dwi_PA.bval
merge_bval_bvec_files dwi_AP.bvec dwi_PA.bvec
# Create index.txt file for eddy
prepare_eddy_file bvals_merged     
# Run FSL's eddy
eddy ...

# At this moment, data are ready for diffusion model fitting (dtifit, bedpostx, ...)
 ```

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
git clone https://github.com/valosekj/bash_basics.git
```

Note - I recommend to clone the repo into `/usr/local/lib` directory

## Usage inside scripts

Include following lines into your script:

```
source <path_to_cloned_repo>/bash_basics/config_bash.sh

export LOGPATH=./log.txt
exec > >(tee -a $LOGPATH) 2>&1
```

## Usage in terminal/CLI

You can `source` this repo within your `bashrc`/`zshrc` file to be able to use functions in CLI:

```
# Add following lines to your /home/<your_username>/.bashrc or /home/<your_username>/.zshrc file
source <path_to_cloned_repo>/bash_basics/config_bash.sh
```

# Contact: 

Jan Valosek, fMRI laboratory, Olomouc, Czechia

2018-2022
