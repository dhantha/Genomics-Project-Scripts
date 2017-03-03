#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 64
#$ -l h_vmem=16G
#$ -l mem_free=12G
#$ -q all.q 

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1

USERNAME=dag332
SEQ=/scratch/$USERNAME/data
NR=/scratch/$USERNAME/nr
OUT=/scratch/$USERNAME/diamond
##OUT=/scratch/$USERNAME/matched.m8
DIAMOND=/home/dag332/software/diamond
TEMP=/scratch/$USERNAME/temp
DATA="JRKD001_S1_L001_R1_001 JRKD001_S1_L001_R2_001 JRKD002_S2_L001_R1_001 JRKD002_S2_L001_R2_001 JRKD003_S3_L001_R1_001"


for d in ${DATA}
do
	$DIAMOND blastx -d $NR -q $SEQ/${d}.fastq -a $OUT/${d} -t $TEMP --threads 64
done


for d in ${DATA}
do
	$DIAMOND view -a $OUT/${d}.daa -o $OUT/${d}.m8
done

exit
