#!/bin/bash

#SBATCH --job-name=basecall_gpu
#SBATCH --account=""
#SBATCH --gres=gpu:1
#SBATCH --time=24:00:00
#SBATCH --partition="gp1d" # or gp1d/gp2d/gp4d/gtest
#SBATCH --mem=90G
#SBATCH -o %j.log           #path to std output
#SBATCH -e %j.err           #path to std err

module load cuda

TEMP=/work/ylllab2021/temp

cd $TEMP/LIB/fast5_pass
mkdir fast5_all

cp */*.fast5 ./fast5_all

# ~/app/ont-guppy/bin/guppy_basecaller -i $TEMP/LIB/fast5_pass/fast5_all -s $TEMP/LIB/fastq -q 0 -x cuda:0 --chunks_per_runner 1024 --chunk_size 3000 --gpu_runners_per_device 12 -c dna_r9.4.1_450bps_hac.cfg > basecallreport_gpu.txt

~/app/ont-guppy/bin/guppy_basecaller -i $TEMP/LIB/fast5_pass/fast5_all -s $TEMP/LIB/fastq -q 0 -x cuda:0 --chunks_per_runner 1024 --gpu_runners_per_device 8 -c dna_r9.4.1_450bps_hac.cfg > basecallreport_gpu.txt

# ~/app/ont-guppy/bin/guppy_barcoder -r --min_score_barcode_front 85 --min_score_barcode_rear 85 -i $TEMP/LIB/fastq/pass -s $TEMP/LIB/demulti -x cuda:0  > barcodereport_gpu.txt

