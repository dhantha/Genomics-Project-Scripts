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
module load python/2.7-current

export PATH=~/.local/bin/:$PATH

USERNAME=dag332
SEQ1=/home/$USERNAME/Bio/Project/Data/JRKD001_S1_L001_R1_001.fastq
SEQ2=/home/$USERNAME/Bio/Project/Data/JRKD001_S1_L001_R2_001.fastq
DATABASE1=/home/$USERNAME/Bio/Project/genomes/ant_genome/ant_genome_db
DATABASE2=/home/$USERNAME/Bio/Project/genomes/human_genome/Homo_sapiens_Bowtie2_v0.1/Homo_sapiens
OUT=/home/$USERNAME/Bio/Project/kneaddata_output/ant_db_1
SCRATCH=/scratch/$USERNAME/kneaddata/

mkdir -p $SCRATCH

cp $SEQ1 $SCRATCH
cp $SEQ2 $SCRATCH
#cp $DATABASE $SCRATCH

kneaddata --input $SCRATCH/JRKD001_S1_L001_R1_001.fastq --input $SCRATCH/JRKD001_S1_L001_R2_001.fastq -db $DATABASE1 -db $DATABASE2 --output $SCRATCH/kneaddata_output --threads 24

exit