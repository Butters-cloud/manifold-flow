#!/bin/bash

#SBATCH --job-name=t-sf-l2d
#SBATCH --output=log_train_flow_lhc2d_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

python -u train.py --modelname april --dataset lhc2d --algorithm flow --splinebins 10 --nllfactor 0.1 --sinkhornfactor 1 --modellatentdim 2 -i ${SLURM_ARRAY_TASK_ID}
