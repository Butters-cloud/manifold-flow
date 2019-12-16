#!/bin/bash

#SBATCH --job-name=e-gamf-tth
#SBATCH --output=log_evaluate_gamf_tth.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
# #SBATCH --gres=gpu:1

source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u evaluate.py --dataset tth --algorithm gamf --modellatentdim 20 --dir /scratch/jb6504/manifold-flow
