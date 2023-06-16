#!/bin/bash

#SBATCH --job-name=consensus
#SBATCH --account="" 
#SBATCH --cpus-per-task=48 
#SBATCH --nodes=2
#SBATCH --time=05:00:00 
#SBATCH --partition="ct224" 
#SBATCH --mem=96G
#SBATCH -o %j.log           #path to std output
#SBATCH -e %j.err           #path to std err 

set -e

Barcode=("" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44" "45" "46" "47" "48" "49" "50" "51" "52" "53" "54" "55" "56" "57" "58" "59" "60" "61" "62" "63" "64" "65" "66" "67" "68" "69" "70" "71" "72" "73" "74" "75" "76" "77" "78" "79" "80" "81" "82" "83" "84" "85" "86" "87" "88" "89" "90" "91" "92" "93" "94" "95" "96")

#Usage
# sbatch Service_run.sh /home/ylllab2021/work/temp/20220823MN015-10BC/demulti 18 20 0823_pipeline_test pCCI-4K-SCoV2-orf7a-f2a-eGFP_trim.fa
# Make sure for changing the BARCODE in Snakefile 
# demulti_fold must be full PATH
# enter the number of first barcode in first_bar
# Name of final folder = name_folder


CoV_folder=$1
CoV_name=$2
first_bar=$3
final_bar=$4
name_folder=$5
ref_fas=$6





mkdir ./${name_folder}
mkdir ./${name_folder}/fasta
mkdir ./${name_folder}/depth

source activate drs-vieh
for ((i=$first_bar; i<=$final_bar; i=i+1))
do
Rscript ./seqout_bammix/covplot.R ~/work/temp/${CoV_folder}/${CoV_name}${Barcode[i]}/${CoV_name}${Barcode[i]}.sorted.bam ./${name_folder}/depth/barcode${Barcode[i]}.pdf
done



for ((i=$first_bar; i<=$final_bar; i=i+1))
do
awk -v seq_name="BC${Barcode[i]}.edit" '/^>/ {flag = ($0 ~ seq_name)} flag {print} ' ~/work/temp/${CoV_folder}/combined.fasta > barcode${Barcode[i]}_edit_only.fasta
Rscript ./seqout_bammix/seq_out.R barcode${Barcode[i]}_edit_only.fasta ./${name_folder}/depth/barcode${Barcode[i]}.depth.txt ${ref_fas} >> barcode${Barcode[i]}_seqout.txt
echo "End of the barcode${Barcode[i]}" >> barcode${Barcode[i]}_seqout.txt
mv new_seq.fa barcode${Barcode[i]}_new.fa
done

conda deactivate

cat barcode*_new.fa > new_combined_seq.fa
cat barcode*_seqout.txt > new_combined_output.txt

mv barcode*_new.fa ./${name_folder}/fasta
mv new_combined_seq.fa ./${name_folder}/fasta
mv barcode*_seqout.txt ./${name_folder}
mv new_combined_output.txt ./${name_folder}
mv *.err ./${name_folder}
mv *.log ./${name_folder}
mv ./barcode* ./${name_folder}

for ((i=$first_bar; i<=$final_bar; i=i+1))
do
sh ./seqout_bammix/seqout_bammix_nosbatch.sh ./${name_folder}/barcode${Barcode[i]}_seqout.txt ~/work/temp/${CoV_folder}/${CoV_name}${Barcode[i]}/${CoV_name}${Barcode[i]}.sorted.bam bammix${Barcode[i]}
mv bammix${Barcode[i]} ./${name_folder}/
done


