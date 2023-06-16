#!/bin/bash

#SBATCH --job-name=artic
#SBATCH --account="" 
#SBATCH --cpus-per-task=48 
#SBATCH --nodes=2
#SBATCH --time=72:00:00 
#SBATCH --partition="ct224" # or ctest if time<0.5 hr
#SBATCH --mem=96G
#SBATCH -o %j.log           #path to std output
#SBATCH -e %j.err           #path to std err 

sh mini_cov.sh
