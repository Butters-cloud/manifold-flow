#!/bin/bash

#SBATCH --job-name=aef-s-g
#SBATCH --output=log_generate_gaussian_data.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

source activate madminer
cd /scratch/jb6504/autoencoded-flow/

python -u generate_gaussian_data.py --dir $PWD
