#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 16
#$ -l h_vmem=8G
#$ -l mem_free=4G
#$ -q all.q 

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc

USERNAME=dag332
SEQ=/scratch/$USERNAME/data
NR=/scratch/fx28/diamond_db/nr.dmnd
OUT=/scratch/fx28/diamond_out
## OUT=/scratch/$USERNAME/matched.m8
## DIAMOND=/home/dag332/software/diamond
## DATA="JRKD001_S1_L001_R1_001 JRKD001_S1_L001_R2_001 JRKD001_S2_L001_R1_001 JRKD001_S2_L001_R2_001 JRKD001_S3_L001_R1_001 JRKD001_S3_L001_R2_001 JRKD001_S4_L001_R1_001 JRKD001_S4_L001_R2_001 JRKD001_S5_L001_R1_001 JRKD001_S5_L001_R2_001"
DATA="$SEQ/JRKD001_S1_L001_R1_001.fastq"
PATH=$PATH:$HOME/.local/bin
set -e



## for d in ${DATA}
## do
	diamond blastx -d $NR -q $DATA -a $OUT -v --log
## done


## for d in ${DATA}
## do
##	$DIAMOND view -a $OUT/${d}.daa -o $OUT/${d}.m8
## done

exit
