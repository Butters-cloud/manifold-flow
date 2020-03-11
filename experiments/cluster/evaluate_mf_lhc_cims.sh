#!/bin/bash

#SBATCH --job-name=e-mf-l
#SBATCH --output=log_evaluate_mf_lhc_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=256GB
#SBATCH --time=2-00:00:00
##SBATCH --gres=gpu:1

source /home/brehmer/miniconda3/etc/profile.d/conda.sh
conda activate ml
export OMP_NUM_THREADS=1
dir=/home/brehmer/manifold-flow

cd $dir/experiments
python -u evaluate.py --modelname alternate_march --dataset lhc --algorithm mf --modellatentdim 14 --splinebins 10 --observedsamples 100 -i ${SLURM_ARRAY_TASK_ID} --dir $dir
