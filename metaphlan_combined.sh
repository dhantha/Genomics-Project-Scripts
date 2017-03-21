#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 4
#$ -l h_vmem=8G
#$ -l mem_free=6G
#$ -q all.q 

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load bowtie2/2.2.5

USERNAME=dag332
MP_LOC=/home/$USERNAME/software/metaphlan2/metaphlan2
SCRATCH=/scratch/$USERNAME
##INPUT=$SCRATCH/qiime/sample2/sample1_joined/fastqjoin.join.fastq
INPUT=/scratch/$USERNAME/bwa_out/file2/scaffold.fa
OUT=$SCRATCH/metaphlan_combined/assemble/file2

MP2=$MP_LOC/metaphlan2.py

$MP2 --nproc 4 $INPUT --input_type fasta > $OUT/sample2_profile.txt

exit
