#!/bin/bash

# This script contains some bash functions widely used for analysis
# Jan Valosek, fMRI laboratory Olomouc, Czech Republic, 2018-2021
# Thanks to Pavel Hok and Rene Labounek for contribution on some parts of the code

#########################################################################
# Print current date and time in following human readable format: 25.5.2021 10:34:51
# USAGE inside scripts:
#     echo "Started: $(print_current_date_and_time)"
#########################################################################
print_current_date_and_time(){
  date +'%x %X'
}

#########################################################################
# Print unique b-values from bval file
# USAGE:
#     get_unique_bvals sub-001_dwi.bval
# EXAMPLE OUTPUT:
#     0 1000 2000
#########################################################################
get_unique_bvals(){
  tr ' ' '\n' < "$1" | sort -nu | uniq | tr '\n' ' '
  # first tr replaces spaces to new lines (\n), sort and uniq filter only unique values and the second tr replaces new lines back to spaces

}

#########################################################################
# Get subject ID (in XX-XXX-000 format) from input path
# USAGE:
#     get_subject_ID /home/some_user/AB-CDE/AB-CDE-111
# EXAMPLE OUTPUT:
#     AB-CDE-111
#########################################################################
get_subject_ID(){

    if [[ $1 =~ "." ]];then
        current_path=$(pwd)
    else
        current_path=$1
    fi

    echo $current_path | sed -E 's/.*([A-Z]{2}-[A-Z]{3}-[0-9]{3}).*/\1/'
}

#########################################################################
# Get study ID (in XX-XXX format) from input path
# USAGE:
#     get_study_ID /home/some_user/AB-CDE/AB-CDE-111
# EXAMPLE OUTPUT:
#     AB-CDE
#########################################################################
get_study_ID(){

    if [[ $1 =~ "." ]];then
        current_path=$(pwd)
    else
        current_path=$1
    fi

    echo $current_path | sed -E 's/.*([A-Z]{2}-[A-Z]{3}).*/\1/'
}

#########################################################################
# Get total readout time for diffusion image from its .json file
# You can get .json file by running dcm2niix on your dMRI data
# It is useful for example for FSL's topup config file
# https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/topup/TopupUsersGuide#A--datain
# USAGE:
#     get_readout dwi.json
# EXAMPLE OUTPUT:
#     0.0768363
#########################################################################
get_readout(){

  readout=$(grep "TotalReadoutTime" ${1} | awk '{print $2}' | sed 's/,//')
  echo "${readout}"

}

#########################################################################
# Monitor processes run by condor (e.g. bedpostx_condor)
# Print number of run processed in running / done format
# Refresh is done every 30s
# USAGE:
#     monitor_condor <process_ID> <user>
# EXAMPLE OUTPUT:
#     Process name: 12345 for user: user
#     Running/Done: 42/8
# TIP - run in while loop
#########################################################################
monitor_condor(){

    # Fetch process ID
    if [[ $1 == "" ]];then
        echo "ERROR: Missing process ID. Exitting..."; return
    else
        process_id=$1
    fi

    # Fetch user, if not passed, use current user
    if [[ $2 == "" ]];then
        user=${USER}
    else
        user=$2
    fi

   echo "Process ID: ${process_id} for user: ${user}"
   echo -en "\rRunning/Done: $(condor_q ${user} -wide | grep ${process_id} | awk '{print $6}')/$(condor_q ${user} -wide | grep ${process_id} | awk '{print $5}')";sleep 30

}

#########################################################################
# Function for checking existency of directories or files
# USAGE:
#   check_input.sh <argument> "DIR_NAME1" "or FILE_NAME2"
# ARGUMENTS:
#   d - check if directory exists
#   dc - check if directory exists, if not create it
#   f - check if file exists
#   b - check if binary exists (e.g. FSL, ANTS, SCT, Matlab,...)
#   e - check if script/function exist and is executable
#########################################################################
check_input()
{

  flag="$1"
  shift

  if [[ $flag =~ "h" ]] || [[ $flag == "" ]]; then
    echo -e "Help for function for checking existency of directories or files.\nUSAGE:\n\tcheck_input <argument> DIR_NAME(s) or FILE_NAME(s) or SCRIPT_NAME(s)"
    echo -e "ARGUMENTS:\n\td - check if directory exists\n\tdc - check if directory exists, if not create it\n\tf - check if file exists\n\tb - check if binary exists (e.g. FSL, ANTS, SCT, Matlab,...)\n\te - check if script/function exist and is executable"
    return
  fi

  while [[ "$1" != "" ]]; do
    case $flag in
      # Check if directory exists
      d)
          if [[ ! -d "$1" ]]; then
            echo "Directory $1 does not exist."
            trap_exit
          fi
          ;;
      # Check if directory exists, if not create it
      dc)
          if [[ ! -d "$1" ]]; then
            echo "Creating $1 directory."
            mkdir $1
            if [[ ! -d "$1" ]]; then
              echo "Directory $1 could not be created."
              trap_exit
            fi
          fi
          ;;
      # Check if file exists
      f)
          if [[ ! -f "$1" ]]; then
            echo "File $1 does not exist."
            trap_exit
          fi
          ;;
      # Check if binary exists
      b)
          if [[ "$(which $1)" == "" ]]; then
            echo "Path to $1 is wrong or $1 is not installed."
            trap_exit
          fi
          ;;
      # Check if script/function exists and is executable, if not, set permissions (to 770)
      e)
          if [[ ! -x "$1" ]]; then
              if [[ ! -f "$1" ]]; then
                  echo "Function/Script $1 does not exist."
                  trap_exit
              else
                  echo "Setting permissions for $1 script/function."
                  chmod 770 $1
                  if [[ ! -x "$1" ]]; then
                      echo "Fuction/Script $1 is not executable and permissions can not be set."
                      trap_exit
                  fi
              fi
          fi
          ;;
      # Invalid option
      *)
          echo "Invalid option"
    esac
    shift
  done
}

#########################################################################
# Function for execution of certain command and printing its output to log
# USAGE:
#   exe "command" [option]
# OPTIONS:
#   [no option] - verbose mode ON (print command' output to both terminal and to log)
#   v - turn OFF verbose (only see which command is executed but all its output is redirected to log)
#   t - turn OFF time mark
#   l - turn OFF print to log
#   k - run process on background, monitor it and kill process if it runs over given time interval

# IMPORTANT: This funtion collaborates and deppends on show function

# Jan Valosek, fMRI laboratory, Olomouc. Inspired by Pavel Hok's function.
#########################################################################
exe()
{
  # Check if dependecy on show function is fullfiled
  if [[ $(which show) == " " ]]; then
      echo -e "Function show was not found. Add path to it to \$PATH variable.\nExiting..."
      trap_exit
  fi

  if [[ $1 == "h" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]] || [[ $1 == "" ]]; then
    echo -e "Help for function for execution of certain command and prints its output to log.\nUSAGE:\n\texe \"command_1\" [option]"
    return
  fi

  # Turn off time mark
  if [[ $2 =~ t ]]; then
    show "Executing: $1" $2       # Print informative message which command is executed to terminal without time mark
  else
    show "Executing: $1"          # Print informative message which command is executed to terminal with time mark
  fi

  # Turn off print to the log
  if [[ $2 =~ l ]]; then
      # Monitor process and kill it after some time
      if [[ $2 =~ k ]]; then
          $1 &                          # Run the command on background
          command_only=${1%% *}         # Get the command only (e.g., fslmaths Mprage.nii.gz -> fslmaths)
          pid=$(ps -eaf -o pid,cmd | awk '/'$command_only'/{ print $1 }' | head -1)
          wait_then_kill $pid           # Wait until the process finish
          exit                          # Exit the parrent script - NB - exit works but trap_exit not
      else
          $1                            # Only run the command
      fi
  else
    $1 | show --stdin $2          # Run the command and redirect output of the command to log (v option) or to terminal (without v option)
  fi

  # Check if command finished with error, if so, call function show with error argument (see help of function show)
  lasterr=${PIPESTATUS[0]}                # get last error
  if [[ $lasterr != 0 ]]; then
      show "Sub-process returned error value $lasterr" e
  fi

}

#########################################################################
# Monitor pid and kill it after some time
# USAGE:
#    wait_then_kill <pid>
# EXAMPLE:
#    wait_then_kill 12345
#########################################################################
wait_then_kill()
{

    limit=36000    # in seconds

    pid=$1      # fetch pid from the first argument

    while true;do

      elapsed_time=$(get_elapsed_time ${pid})   # get elapsed time
      echo -ne "\rRunning: ${elapsed_time}s"               # print elapsed time in terminal

      if [[ ${elapsed_time} -gt ${limit} ]];then
          kill_process ${pid}
          break
      fi
      sleep 3600   # sleep for 3600 seconds
    done
}

#########################################################################
# Get elapsed time based on processID (pid)
# USAGE:
#    get_elapsed_time 12345
# EXAMPLE OUTPUT - time in seconds
#    123
#########################################################################
get_elapsed_time()
{
    pid=$1
    ps -p ${pid} -o etimes | awk '{ print $1 }' | sed -n 2p
    # ps -p ${pid} -o etime retunrs:
    #    ELAPSED
    #    123
    # thus, awk and sed are used to extract only the time itself (123)
}


#########################################################################
# Kill process based on processID (pid)
# USAGE:
#    kill_process 12345
#########################################################################
kill_process()
{
    pid_to_kill=$1
    echo -e "\nKilling pid: ${pid_to_kill}"
    kill -9 ${pid_to_kill}
    #if [[ $(ps -eaf -o pid,cmd | awk '/'$pid_to_kill'/{ print $1 }' | head -1) == "" ]]; then
    #  echo "Process $(ps -eaf -o pid,cmd | awk '/'$pid_to_kill'/{ print $3 }' | head -1) killed."
    #fi
}

#########################################################################
# Function for printing message or command's output in various ways
# USAGE:
#    show "message" [option]
# OPTIONS:
#       [no option] - verbose mode on (print output to both terminal and to log with time stamp)
#       v - turn OFF verbose (print message only to log with time stamp)
#       e - error (print message in red color to both terminal and log and exit)
#       w - warning (print message in blue color to both terminal and log but stil continue)
#       y - print standard message in yellow color
#       g - print standard message in green color
#       t - turn OFF time mark
# EXAMPLE USAGE:
#       show "Hello world"      - print "Hello world" to both terminal and log with time stamp
#       show "Hello world" t    - print "Hello world" to both terminal and log without time stamp
#       show "Hello world" g    - print "Hello world" in green color to both terminal and log with time stamp
#       show "Hello world" gt   - print "Hello world" in green color to both terminal and log without time stamp
#       show "Hello world" v    - print "Hello world" only to log (verbose off) with time stamp
#       show "Hello world" vt   - print "Hello world" only to log (verbose off) without time stamp
#       show "Hello world" e    - print "Hello world" as error in red color to both terminal and log and exit main script

# IMPORTANT: This funtion collaborates with exe function

# Jan Valosek, fMRI laboratory, Olomouc. Inspired by Pavel Hok's function.
#########################################################################
# Colors definition
red=$(tput setaf 1)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
green=$(tput setaf 6)
normal=$(tput sgr0)

show()
{

  if [[ $1 == "h" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]]; then
    echo -e "Help for printing message or command's output in various ways.\nUSAGE:\n\tshow \"message\" [option]"
    echo -e "OPTION:\n\t[no option] - verbose mode on (print output to both terminal and to log with time stamp)\n\tv - turn OFF verbose (print message only to log with time stamp)\n\te - error (print message in red color to both terminal and log and exit)"
    echo -e "\tw - warning (print message in blue color to both terminal and log but stil continue)\n\ty - print standard message in yellow color\n\tg - print standard message in green color\n\tt - turn OFF time mark"
    return
  fi

  # Switch off time mark
  if [[ $2 =~ "t" ]]; then
      print_date=""
  else
      print_date="$(date "+%T_%Y-%m-%d"): "
  fi


  # ERROR - print message in red color to both terminal and log with time stamp and exit
  if [[ $2 =~ "e" ]]; then

          echo -e "${red}${print_date}ERROR: $1\nExiting...${normal}" 1>&2
          trap_exit

  # WARNING - print message in red color to both terminal and log  with time stamp but stil continue
  elif [[ $2 =~ "w" ]]; then

          #echo -e "${blue}${print_date}WARNING: $1\nContinuing...${normal}" 1>&2
          echo -e "${blue}${print_date}WARNING: $1${normal}" 1>&2

  # Standard message in yellow color to both terminal and log with time stamp
  elif [[ $2 =~ "y" ]]; then

          echo -e "${yellow}${print_date}${1}${normal}" 1>&2

  # Standard message in green color to both terminal and log with time stamp
  elif [[ $2 =~ "g" ]]; then

          echo -e "${green}${print_date}${1}${normal}" 1>&2

  # NO OPTION - output from command or message to screen and to log (= verbose mode)
  elif [[ ! ( $2 =~ "v" ) ]]; then

          # message
          if [[ "$1" != "--stdin" ]]; then
                  echo -e "${print_date}${1}"
          # Command
          else
              while read line; do
                      echo -e "$line"
              done
          fi

  # TURN OFF verbose - output from command or message only to log
  elif [[ $2 =~ "v" ]]; then

      if [[ $LOGPATH == "" ]]; then
          echo -e "Path to log is empty. Fix it (e.g. by setting LOGPATH variable as a global in your script (export \$LOGPATH=\"log.txt\")).\nExiting..."
          trap_exit
      fi

          # message
          if [[ "$1" != "--stdin" ]]; then
                  echo -e "${print_date}${1}" >> $LOGPATH
          # Command
          else
                  while read line; do
                          echo -e "$line" >> $LOGPATH
                  done
          fi

  fi
}

#########################################################################
# Function for running matlab from command line without opening MATLAB desktop
# Explanation:
#   https://www.mathworks.com/help/matlab/ref/matlablinux.html
# USAGE:
#   run_matlab "command_1,...,command_X,exit"
# e.g.
#   run_matlab "addpath('$MATLAB_SCRIPT'),NODDI_analysis('$subdir','$SUB'),exit"

# Jan Valosek, Rene Labounek, fMRI laboratory, Olomouc.
#########################################################################
run_matlab()
{
  if [[ $(which matlab) == "" ]]; then
      echo "Matlab was not found."
      trap_exit
  fi

  if [[ $1 == "h" ]] || [[ $1 == "-h" ]] || [[ $1 == "--help" ]] || [[ $1 == "" ]]; then
    echo -e "Help for function for running matlab from command line without opening MATLAB desktop.\nUSAGE:\n\trun_matlab \"command_1,...,command_X,exit\""
    echo -e "EXAMPLE:\n\trun_matlab \"addpath('\$MATLAB_SCRIPT'),NODDI_analysis('\$subdir','\$SUB'),exit\""
    return
  fi

  COMMAND=$1

  if [[ $HOSTNAME == emperor ]];then
     /usr/local/MATLAB/R2014b/bin/matlab -nosplash -nodisplay -nodesktop -r "$COMMAND"           #JV 11.5.18 (R2016B does not contain Image Processing Toolbox)
  elif [[ $HOSTNAME == king ]];then
    /usr/local/MATLAB/R2016b/bin/matlab -nosplash -nodisplay -nodesktop -r "$COMMAND"           #JV 27.5.2019 (R2018B does not contain Image Processing Toolbox)
  else
    matlab -nosplash -nodisplay -nodesktop -r  "$COMMAND"
  fi
}

#########################################################################
# Function telling to the parent process that something happened (e.g. file/binary/script does not exist)
# Function finds parent process ID (ppid) and set user defined signal (SIGUSR1)
# In the parent script has to be following line for catching SIGUSR1:
#     trap "echo Exitting>&2;exit" SIGUSR1
# Inspiration:
#     https://stackoverflow.com/questions/16215196/bash-exit-parent-script-from-child-script
#########################################################################
trap_exit()
{
    OS_name=$(uname -a | awk '{print $1}')  # get OS name (Darwin or Linux)

    if [[ $OS_name == "Linux" ]]; then
        sleep 1;kill -SIGUSR1 `ps --pid $$ -o ppid=`#;exit   # Find parent process ID (ppid) and set user defined signal (SIGUSR1)
    elif [[ $OS_name == "Darwin" ]]; then
        sleep 1;kill -SIGUSR1 `ps $$ -o ppid=`#;exit         # Find parent process ID (ppid) and set user defined signal (SIGUSR1)
    fi
}
