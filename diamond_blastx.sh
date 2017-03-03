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

USERNAME=dag332
SEQ=/scratch/$USERNAME/data
NR=/home/$USERNAME/software/diamond_data/nr.dmnd
OUT=/scratch/$USERNAME/diamond
##OUT=/scratch/$USERNAME/matched.m8
DIAMOND=/home/dag332/software/diamond
DATA="JRKD001_S1_L001_R1_001 JRKD001_S1_L001_R2_001 JRKD001_S2_L001_R1_001 JRKD001_S2_L001_R2_001 JRKD001_S3_L001_R1_001 JRKD001_S3_L001_R2_001 JRKD001_S4_L001_R1_001 JRKD001_S4_L001_R2_001 JRKD001_S5_L001_R1_001 JRKD001_S5_L001_R2_001"


for d in ${DATA}
do
	$DIAMOND blastx -d $NR -q $SEQ/${d}.fastq -a $OUT/${d} -t /tmp/
done


for d in ${DATA}
do
	$DIAMOND view -a $OUT/${d}.daa -o $OUT/${d}.m8
done

exit
