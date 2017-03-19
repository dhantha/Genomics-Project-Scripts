#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -M fx@drexel.edu
#$ -P rosenclassPrj
#$ -q all.q@@intelhosts
#$ -pe shm 1
#$ -l h_rt=1:00:00
#$ -l h_vmem=50G
#$ -l m_mem_free=30G

. /etc/profile.d/modules.sh

### These four modules must ALWAYS be loaded
module load shared
module load proteus
module load sge/univa
module load gcc
module load python/2.7-current

## there should be 3 files ending with .accession2taxid
## prot.accession2taxid
## pdb.accession2taxid
## dead_prot.accession2taxid

cd /scratch/fx28
LC_COLLATE=C sort *.accession2taxid -S 30G > accession2taxid.sorted
echo "done sorting db"
