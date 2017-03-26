#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M aae44@drexel.edu
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

DIAMOND=/home/aae44/sample/diamond

$DIAMOND blastx -d /scratch/dag332/nr -q /home/aae44/sample/SP1.fq -a /home/aae44/sample/SP1

exit

