#!/bin/bash 

#SBATCH -p gpu
#SBATCH -n 7
#SBATCH --exclude=edi0[0,1,2,3,4,5] 
#SBATCH -N 1
#SBATCH --gres=gpu:1
#SBATCH --mem=24GB
#SBATCH -J ache
source /opt/miniconda3/bin/activate cf_1.5 
export LD_LIBRARY_PATH=/usr/local/cuda-11.4/lib64:$LD_LIBRARY_PATH

colabfold_batch insulin.csv . --num-models 1 --num-recycle 5

