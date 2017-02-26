#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -M fx@drexel.edu
#$ -P rosenclassPrj
#$ -l vendor=amd
#$ -q all.q
#$ -pe shm 1
#$ -l h_rt=1:00:00
#$ -l h_vmem=8G
#$ -l m_mem_free=4G

. /etc/profile.d/modules.sh

### These four modules must ALWAYS be loaded
module load shared
module load proteus
module load sge/univa
module load gcc

# add bin to path
PATH=$PATH:/home/fx28/.local/bin
export PATH


