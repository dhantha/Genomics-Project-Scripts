#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 64
#$ -l h_vmem=230G
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
prefix_in=/scratch/fx28/idba_out_b3
prefix_out=/scratch/fx28/diamond_out_asse
name_in="pair3/scaffold.fa"
name_out="pair3"

file_in=$prefix_in/$name_in
file_out=$prefix_out/$name_out

mkdir -p $prefix_out
cd $prefix_out

diamond --version

cmd="diamond blastx -d $nr -q $file_in -a $file_out -v --block-size 16.0 --index-chunks 1"
echo $cmd
printf "\nstarting everything, $(date), $(now)\n"
$cmd
printf "\nblastx done with ${d}, $(date), $(now)\n"
diamond view -a $file_out.daa -o $file_out.m8 -v
printf "\nview done with ${d}, $(date), $(now)\n"

exit

