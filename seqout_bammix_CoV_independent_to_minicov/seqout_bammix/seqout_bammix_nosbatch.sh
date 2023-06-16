#!/bin/bash

# Usage
# sbatch seqout_bammix.sh barcode89_seqout.txt *.sorted.bam bammix89

set -e
seq_input=$1
bam_file=$2
output_file=$3

mkdir ${output_file}
source activate artic-ncov2019
line_count=0
cat "${seq_input}" | grep "pos.*" | grep -Eo "[0-9]{1,5}" | awk '{ORS=(NR%10==0?RS:FS)}1' | while read -r line;
do
    line_count=$((line_count + 1))
    echo "group${line_count}"
    echo "${line}"
    bammix -b "${bam_file}" -p ${line}
    mv position_base_counts.csv position_base_counts_${line_count}.csv
    mv position_base_counts.pdf position_base_counts_${line_count}.pdf
done

mv position_base_counts* ${output_file}/

conda deactivate
