#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=48:00:00
#$ -P rosenclassPrj
#$ -pe shm 16
#$ -l h_vmem=60G
#$ -l mem_free=2G
#$ -q all.q@@intelhosts 


. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc

set -e
### use a self compiled idba with struct size set for read length of 152
PATH=$PATH:$HOME/.local/bin:/scratch/fx28/idba_mod_152/bin
### module load idba

prefix_in=/scratch/fx28/idba_in
name_in=JRKD001_S1_L001.fasta

prefix_out=/scratch/fx28/idba_out_b3
name_out=pair1

mkdir -p $prefix_out/$name_out
cd $prefix_out/$name_out

top -H -b -d 30 -u fx28 >> top.log &
top_pid=$!

cmd="idba -r $prefix_in/$name_in -o $prefix_out/$name_out --num_threads 16 --mink 20 --maxk 100 --step 20"
echo $cmd
$cmd

kill $top_pid

exit

