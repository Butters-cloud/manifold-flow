#!/bin/bash

#SBATCH --job-name=t-sf-t2d
#SBATCH --output=log_train_flow_lhc2d.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --modelname small --dataset lhc2d --algorithm flow --modellatentdim 2 --samplesize 100000 --dir /scratch/jb6504/manifold-flow
