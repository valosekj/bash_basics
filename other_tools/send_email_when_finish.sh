#!/bin/bash

#########################################################################
# Send email when process(es) finish
# USAGE:
#    send_email_when_finish <list_of_pids> <email_filename> <refresh_time_in_sec>
# EXAMPLES:
#   send_email_when_finish ${list_of_pids} dummy_email.txt
#   send_email_when_finish send_now dummy_email.txt
#
# NB - ${list_of_pids} variable should be defined as list_of_pids=("68106" "68107")
# TIP - PID(s) could be obtained by get_pid() function
#
# TIP - list_of_pids can be replaced by "send_now" if you want to send email immediately
#
# TIP - you can create email_filename by echo, e.g.:
#     echo -e "To: <email_1>,<email_2>\nSubject:My subject\n\nEmail body" >> dummy_email.txt
# Then pass dummy_email.txt as the second argument
#########################################################################

# list_of_pids is an array and is passed as the first argument

# Send email right now - do not monitor any process
if [[ $1 == "send_now" ]];then
    sleep 1
# Print help
elif [[ $1 == "" ]] || [[ $1 == "--help" ]];then
    echo -e "Send email when process(es) finish"
    echo -e "USAGE:"
    echo -e "\tsend_email_when_finish <list_of_pids> <email_filename> <refresh_time_in_sec>"
    echo -e "EXMAMPLES:"
    echo -e "\tsend_email_when_finish \${list_of_pids} dummy_email.txt"
    echo -e "\tsend_email_when_finish send_now dummy_email.txt"
    echo -e "\nNB - \${list_of_pids} variable should be defined as list_of_pids=(\"68106\" \"68107\")"
    echo -e "TIP - individual PID(s) could be obtained by get_pid() function"
    echo -e "TIP - list_of_pids can be replaced by \"send_now\" if you want to send email immediately"
    echo -e "TIP - you can create dummy email by create_email function, e.g.:"
    echo -e "\tcreate_email <process_name> <list_of_emails>"
    exit
else

    if [[ $3 == "" ]];then
      refresh=2     # sleep interval in seconds
    else
      refresh=$3
    fi

    running=true

    while ${running};do

        # initialize new list every while iteration
        # this contains true or false for each process depending if process run or not
        running_list=""

        # Loop across individual processID (pid)
        for pid in "${list_of_pids[@]}";do
            # Check if process runs based on pid
            if $(ps -p ${pid} &>/dev/null);then
                running_list="$running_list true"   # append to the list
                echo "${pid} running"
            else
                running_list="$running_list false"   # append to the list
                echo "${pid} finished"
            fi
        done

        sleep ${refresh}    # wait before next while iteration

        # If list contains only false (i.e., do not contains any running process (true)), switch running variable to
        # false and stop while loop
        if [[ ! $running_list =~ "true" ]];then
            running=false
        else
            running=true
        fi

    done
    echo "All processIDs done."
fi

# filename of dummy email
email_filename=$2
check_input f ${email_filename}

cat ${email_filename} | msmtp --tls-certcheck=off --account fnol -t
# -t -- read additional recipients from the mail
echo "Email ${email_filename} sent"
