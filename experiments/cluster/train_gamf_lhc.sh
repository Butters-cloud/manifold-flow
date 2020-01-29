#!/bin/bash

#SBATCH --job-name=t-gamf-lhc
#SBATCH --output=log_train_gamf_lhc.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --modelname ged_largebs_long --dataset lhc --algorithm flow --modellatentdim 9 --genbatchsize 2000 --epochs 1000 --dir /scratch/jb6504/manifold-flow

#python -u train.py --modelname small_ged_largebs --dataset lhc --algorithm gamf --ged --modellatentdim 9 --genbatchsize 2000 --epochs 400 --samplesize 100000 --dir /scratch/jb6504/manifold-flow
#python -u train.py --modelname ged_largebs --dataset lhc --algorithm gamf --ged --modellatentdim 9 --genbatchsize 2000 --epochs 400 --dir /scratch/jb6504/manifold-flow

#python -u train.py --modelname small_largebs --dataset lhc --algorithm gamf --modellatentdim 9 --genbatchsize 1000 --samplesize 100000 --epochs 200 --dir /scratch/jb6504/manifold-flow
#python -u train.py --modelname largebs --dataset lhc --algorithm gamf --modellatentdim 9 --genbatchsize 1000 --epochs 200 --dir /scratch/jb6504/manifold-flow
