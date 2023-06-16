#!/bin/bash

#SBATCH --job-name=consensus
#SBATCH --account="" 
#SBATCH --cpus-per-task=12 
#SBATCH --nodes=1
#SBATCH --time=05:00:00 
#SBATCH --partition="ct56" 
#SBATCH --mem=96G
#SBATCH -o %j.log           #path to std output
#SBATCH -e %j.err           #path to std err 

set -e

BARCODE=("" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31" "32" "33" "34" "35" "36" "37" "38" "39" "40" "41" "42" "43" "44" "45" "46" "47" "48" "49" "50" "51" "52" "53" "54" "55" "56" "57" "58" "59" "60" "61" "62" "63" "64" "65" "66" "67" "68" "69" "70" "71" "72" "73" "74" "75" "76" "77" "78" "79" "80" "81" "82" "83" "84" "85" "86" "87" "88" "89" "90" "91" "92" "93" "94" "95" "96")

#Usage
# sbatch Service_run.sh /home/ylllab2021/work/temp/20220823MN015-10BC/demulti 18 20 0823_pipeline_test pCCI-4K-SCoV2-orf7a-f2a-eGFP_trim.fa
# Make sure for changing the BARCODE in Snakefile 
# demulti_fold must be full PATH
# enter the number of first barcode in first_bar
# Name of final folder = name_folder

# If over two sample, add bar_2, bar_3..., and add the argument in {Barcode}
demulti_fold=$1
first_bar=$2
final_bar=$3
#final_bar_2=$4
name_folder=$4
ref_fas=$5


mkdir ./${name_folder}
mkdir ./${name_folder}/fasta
mkdir ./${name_folder}/depth

Barcode=("" ${BARCODE[$first_bar]} ${BARCODE[$final_bar]})
#Barcode=("" ${BARCODE[$first_bar]} ${BARCODE[$final_bar]} ${BARCODE[$final_bar_2]})
length=$((${#Barcode[@]}-1))
for ((i=1; i<=$length; i=i+1))
do
cp -R  ${demulti_fold}/barcode${Barcode[i]} ~/work/stand_alone/
done


source activate artic-ncov2019
snakemake -p --cores 12 --reason
conda deactivate

source activate drs-vieh
for ((i=1; i<=$length; i=i+1))
do
Rscript covplot.R ./output/bam/barcode${Barcode[i]}.sorted.bam ./${name_folder}/depth/barcode${Barcode[i]}.pdf
done



for ((i=1; i<=$length; i=i+1))
do
Rscript seq_out.R ./output/fas/barcode${Barcode[i]}.raw.fasta ./${name_folder}/depth/barcode${Barcode[i]}.depth.txt ${ref_fas} >> barcode${Barcode[i]}_seqout.txt
echo "End of the barcode${Barcode[i]}" >> barcode${Barcode[i]}_seqout.txt
mv new_seq.fa barcode${Barcode[i]}_new.fa
done

cat barcode*_new.fa > new_combined_seq.fa
cat barcode*_seqout.txt > new_combined_output.txt

mv barcode*_new.fa ./${name_folder}/fasta
mv new_combined_seq.fa ./${name_folder}/fasta
mv barcode*_seqout.txt ./${name_folder}
mv new_combined_output.txt ./${name_folder}
mv *.err ./${name_folder}
mv *.log ./${name_folder}
mv ./output ./${name_folder}/run_output
mv ./barcode*/ ./${name_folder}
