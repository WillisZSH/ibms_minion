#!/bin/bash

set -e

TEMP=/work/ylllab2021/temp
CODE=/home/ylllab2021/script/ibms_minion

Rscript $CODE/post_artic_V4.R $CODE

echo 'clean the script folder'

mv $CODE/*.log $TEMP/LIB
mv $CODE/*.err $TEMP/LIB 
#mv $CODE/*report* $TEMP/LIB 
mv $CODE/*BC* $TEMP/LIB
mv $CODE/combined.fasta $TEMP/LIB
echo 'DONE' 

