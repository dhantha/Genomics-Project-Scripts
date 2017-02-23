#!/bin/bash
#$ -S bin/bash
#$ -j y
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 24
#$ -l mem_free=10G
#$ -l h_vmem=16G
#$ -q all.q


. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load bowtie2/2.2.5

USERNAME=dag332
SEQS=/home/$USERNAME/Bio/Project/genomes/ant_genome/combined_ants.fasta

SCRATCH=/scratch/$USERNAME/ant_genome/

mkdir -p $SCRATCH

OUT=$SCRATCH/ant_genome_db

cp $SEQS $SCRATCH

# build the ant database

bowtie2-build $SEQS $OUT

exit
