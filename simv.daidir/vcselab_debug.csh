#!/bin/csh -f

cd /home/ecelrc/students/blui/vlsi1/lab3/rtl

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/usr/local/packages/synopsys_2022/vcs/T-2022.06/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

