#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=1:00:00
#$ -P rosenclassPrj
#$ -pe shm 1
#$ -l h_vmem=8G
#$ -l mem_free=2G
#$ -q all.q@@intelhosts 


. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc

set -e
PATH=$PATH:$HOME/.local/bin:$HOME/idba/bin

prefix_in=/scratch/dag332/kneaddata/kneaddata_output/pair3
name_in_1=JRKD003_S3_L001_R1_001_kneaddata_paired_1.fastq
name_in_2=JRKD003_S3_L001_R1_001_kneaddata_paired_2.fastq

prefix_out=/scratch/fx28/idba_in
name_out=JRKD003_S3_L001.fasta

mkdir -p $prefix_out
cd $prefix_out

printf "\nstarting fq2fa, $(date), $(now)\n"
fq2fa --merge $prefix_in/$name_in_1 $prefix_in/$name_in_2 $prefix_out/$name_out

printf "\nfa2fa done , $(date), $(now)\n"

exit

