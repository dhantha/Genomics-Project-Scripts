#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 24
#$ -l h_vmem=8G
#$ -l mem_free=6G
#$ -q all.q 

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load bwa

USERNAME=dag332
INPUT=/scratch/$USERNAME/bwa_out/file5/scaffold.fa
SEQS1=/scratch/$USERNAME/bwa_out/file5/JRKD006_S5_L001_R1_001_kneaddata_paired_1.fastq
SEQS2=/scratch/$USERNAME/bwa_out/file5/JRKD006_S5_L001_R1_001_kneaddata_paired_2.fastq
OUT=/scratch/$USERNAME/bwa_out/file5

##bwa index $INPUT

bwa mem $INPUT $SEQS1 $SEQ2 > $OUT/pair5_samfile

exit
