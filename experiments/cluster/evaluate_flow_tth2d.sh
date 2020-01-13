#!/bin/bash

#SBATCH --job-name=e-sf-t2d
#SBATCH --output=log_evaluate_flow_tth2d.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
# #SBATCH --gres=gpu:1

source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u evaluate.py --dataset tth2d --algorithm flow --modellatentdim 2 --dir /scratch/jb6504/manifold-flow
