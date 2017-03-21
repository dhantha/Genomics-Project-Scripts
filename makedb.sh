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
export PATH=/home/$USERNAME/software/ncbi-blast-2.2.18+/bin/:$PATH
IN=/home/dag332/software/db/protein/nt
OUT=/home/dag332/software/db/protein/

makeblastdb -in $IN -parse_seqids -dbtype nucl -out $OUT/nucl_db

exit
