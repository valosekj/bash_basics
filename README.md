## Information

Bundle of basic bash functions used in routine work.


### Functions:
 - check_input - script for checking existency of directories or files
 - exe - script for execution certain command and prints its output to log
 - show - script for printing messeage or command's output in various ways (e.g. like ERROR in red color)
 - run_matlab - script for running matlab from command line without opening MATLAB desktop


### Usage:

Clone repo:

```
git clone https://github.com/valosekj/bash_basics.git
```

Then include following lines in your script:

```
source bash_basics/bash_basic_functions.sh

export LOGPATH=./log.txt
exec > >(tee -a $LOGPATH) 2>&1
```


### Contact: 

Jan Valosek, fMRI laboratory, Olomouc

2019-2021
