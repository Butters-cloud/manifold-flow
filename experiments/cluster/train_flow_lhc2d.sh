#!/bin/bash

#SBATCH --job-name=t-f-l2d
#SBATCH --output=log_train_flow_lhc2d_%a.log
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=32GB
#SBATCH --time=7-00:00:00
#SBATCH --gres=gpu:1

module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/scandal-mf/experiments

# python -u train.py -c cluster/configs/train_lhc_may.config --dataset lhc2d --modellatentdim 2 --modelname may --algorithm flow -i ${SLURM_ARRAY_TASK_ID}
python -u train.py -c cluster/configs/train_lhc_may.config --dataset lhc2d --modellatentdim 2 --modelname scandal_may --algorithm flow --scandal 5 -i ${SLURM_ARRAY_TASK_ID}
