#!/bin/bash 

#SBATCH -p gpu
#SBATCH -N 1
#SBATCH -w edi08
#SBATCH --gres=gpu:1
#SBATCH --mem=40GB
#SBATCH -J IDUB_esm
eval "$(conda shell.bash hook)"
conda activate esmfold
for fasta in  *.fasta; do
	python /home/nfs/rmadaj/bins/esm/scripts/esmfold_inference.py --num-recycles 5 -i $fasta -o ./
	done
