#!/bin/bash

# Usage
# sbatch seqout_bammix.sh barcode89_seqout.txt *.sorted.bam bammix89

set -e
seq_input=$1
bam_file=$2
output_file=$3

echo "script start"
line_count=0
cat "${seq_input}" | grep "pos.*" | grep -Eo "[0-9]{1,5}" | awk '{ORS=(NR%10==0?RS:FS)}1' | while read -r line;
do
    echo "line count start"
    line_count=$((line_count + 1))
    echo "group${line_count}"
    echo "${line}"
done 

# conda deactivate
