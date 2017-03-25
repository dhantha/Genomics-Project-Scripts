#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 64
#$ -l h_vmem=220G
#$ -l mem_free=2G
#$ -q all.q@@amdhosts 


. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc

set -e
PATH=$PATH:$HOME/.local/bin

nr=/scratch/fx28/diamond_db/nr.dmnd
prefix_in=/scratch/dag332/kneaddata/kneaddata_output
prefix_out=/scratch/fx28/diamond_out
name_in="pair1/JRKD001_S1_L001_R1_001_kneaddata_paired_2"

file_in=$prefix_in/$name_in.fastq
file_out=$prefix_out/$name_in

mkdir -p $prefix_out
cd $prefix_out

diamond --version

echo "diamond blastx -d $nr -q $file_in -a $file_out -v --block-size 18.0 --index-chunks 2"
printf "\nstarting everything, $(date), $(now)\n"
diamond blastx -d $nr -q $file_in -a $file_out -v --block-size 18.0 --index-chunks 2
printf "\nblastx done with ${d}, $(date), $(now)\n"
diamond view -a $file_out.daa -o $file_out.m8 -v
printf "\nview done with ${d}, $(date), $(now)\n"

exit

