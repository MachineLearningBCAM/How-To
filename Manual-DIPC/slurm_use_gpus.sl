#!/bin/bash
#SBATCH --job-name=use_gpus
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=16GB
#SBATCH --output=%j_gpu_out.txt
#SBATCH --error=%j_gpu_err.txt

k=$1
m=$2
v=$3
j=$4

module load MATLAB-IKUR/2024b
matlab -nodisplay -nosplash -r "f('$k', $m, $v, $j); exit;"
