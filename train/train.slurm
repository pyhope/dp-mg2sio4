#!/bin/bash
#SBATCH --job-name=m1v4          # create a short name for your job
#SBATCH --nodes=1                # node count
#SBATCH --ntasks=1               # total number of tasks across all nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=64G        # memory per cpu-core (4G is default)
#SBATCH --gres=gpu:1             # number of gpus per node
#SBATCH --time=48:00:00          # total run time limit (HH:MM:SS)

module purge
module load anaconda3/2020.11
conda activate deepmd

dp train mg2sio4.json
