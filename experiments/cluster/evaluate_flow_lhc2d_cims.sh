#!/bin/bash

#SBATCH --job-name=e-sf-l2d
#SBATCH --output=log_evaluate_flow_lhc2d_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
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
python -u evaluate.py --modelname march --dataset lhc2d --algorithm flow --modellatentdim 2 --observedsamples 100 -i $run --skipgeneration --skiplikelihood --burnin 50 --mcmcsamples 400 --chain $chain  --dir $dir
