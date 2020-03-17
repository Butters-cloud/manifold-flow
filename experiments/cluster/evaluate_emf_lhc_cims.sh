#!/bin/bash

#SBATCH --job-name=e-emf-l
#SBATCH --output=log_evaluate_emf_lhc_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64GB
#SBATCH --time=2-00:00:00
# #SBATCH --gres=gpu:1

conda activate ml
export PATH="/home/brehmer/miniconda3/envs/ml/bin/:$PATH"
export OMP_NUM_THREADS=1
dir=/home/brehmer/manifold-flow

run=$((SLURM_ARRAY_TASK_ID / 5))
chain=$((SLURM_ARRAY_TASK_ID % 5))

cd $dir/experiments
python -u evaluate.py --modelname alternate_april --dataset lhc --algorithm emf --modellatentdim 14 --splinebins 10 --observedsamples 50 -i ${run} --skiplikelihood --burnin 50 --mcmcsamples 400 --chain $chain --dir $dir