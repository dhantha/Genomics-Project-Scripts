#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M fx28@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 64
#$ -l h_vmem=3.5G
#$ -l mem_free=2G
#$ -q all.q@@amdhosts 


. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc

SEQ=/scratch/dag332/data
NR=/scratch/fx28/diamond_db/nr.dmnd
OUT_DIR=/scratch/fx28/diamond_out
## DATA="JRKD001_S1_L001_R1_001 JRKD001_S1_L001_R2_001 JRKD001_S2_L001_R1_001 JRKD001_S2_L001_R2_001 JRKD001_S3_L001_R1_001 JRKD001_S3_L001_R2_001 JRKD001_S4_L001_R1_001 JRKD001_S4_L001_R2_001 JRKD001_S5_L001_R1_001 JRKD001_S5_L001_R2_001"
DATA="JRKD003_S3_L001_R1_001 "
PATH=$PATH:$HOME/.local/bin
set -e

cd $OUT_DIR

diamond --version

printf "starting everything, $(date), $(now)\n"

for d in ${DATA}
do
	THIS_DATA=$SEQ/${d}.fastq
	THIS_OUT=$OUT_DIR/${d}
	diamond blastx -d $NR -q $THIS_DATA -a $THIS_OUT -t $TMP -v --block-size 16.0 --index-chunks 2
	printf "blastx done with ${d}, $(date), $(now)\n"
done


for d in ${DATA}
do
	diamond view -a $OUT_DIR/${d}.daa -o $OUT_DIR/${d}.m8 -t $TMP -v
	printf "view done with ${d}, $(date), $(now)\n"
done


exit

