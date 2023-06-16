#!/bin/bash
# This command can check the gpu usage in specific job

# jobid must be change

job_id=$1

srun --jobid=$job_id nvidia-smi
