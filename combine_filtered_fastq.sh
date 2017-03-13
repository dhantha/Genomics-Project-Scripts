#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=10:00:00
#$ -P rosenclassPrj
#$ -l mem_free=30G
#$ -l h_vmem=32G
#$ -q all.q

. /etc/profile.d/modules.sh

module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load qiime/gcc/64/1.9.1

USERNAME=dag332
SCRATCH=/scratch/$USERNAME
SEQ1=$SCRATCH/kneaddata/kneaddata_output/pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_1.fastq
SEQ2=$SCRATCH/kneaddata/kneaddata_output/pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_2.fastq
OUT=$SCRATCH/qiime/sample5


join_paired_ends.py -f $SEQ1 -r $SEQ2 -o $OUT/sample1_joined

exit
