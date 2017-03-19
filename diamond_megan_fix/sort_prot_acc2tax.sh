#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -M fx@drexel.edu
#$ -P rosenclassPrj
#$ -q all.q@@intelhosts
#$ -pe shm 2
#$ -l h_rt=1:00:00
#$ -l h_vmem=30G
#$ -l m_mem_free=12G

. /etc/profile.d/modules.sh

### These four modules must ALWAYS be loaded
module load shared
module load proteus
module load sge/univa
module load gcc
module load python/2.7-current

cd /scratch/fx28/ws2
LC_COLLATE=C sort prot.accession2taxid -S 29G > prot.accession2taxid.out

