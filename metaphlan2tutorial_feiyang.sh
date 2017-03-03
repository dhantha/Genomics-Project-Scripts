#!/bin/bash
#
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -M fx@drexel.edu
#$ -P rosenclassPrj
#$ -l vendor=amd
#$ -q all.q
#$ -pe shm 24
#$ -l h_rt=12:00:00
#$ -l h_vmem=8G
#$ -l m_mem_free=4G

. /etc/profile.d/modules.sh

### These four modules must ALWAYS be loaded
module load shared
module load proteus
module load sge/univa
module load gcc

module load bowtie2/2.2.5

mpa_dir=/home/fx28/genomics_project/metaphlan2
PATH=$PATH:$mpa_dir
export mpa_dir
export PATH

USERNAME=fx28
MP_LOC=$mpa_dir

data_dir=/home/fx28/genomics_project/try_metaphlan
SEQS1=$data_dir/JRKD001_S1_L001_R1_001_kneaddata_paired_1.fastq
SEQS2=$data_dir/JRKD001_S1_L001_R1_001_kneaddata_paired_2.fastq

SCRATCH=/scratch/$USERNAME/metaphlan2
OUT=$data_dir/metaphlan_out


MP2=$MP_LOC/metaphlan2.py
MMT=$MP_LOC/utils/merge_metaphlan_tables.py
BT2=/mnt/HA/opt/bowtie2/2.2.5/bin/bowtie2
MP2DB=$MP_LOC/db_v20/mpa_v20_m200.pkl
BT2DB=$MP_LOC/db_v20/mpa_v20_m200

mkdir -p $SCRATCH
mkdir -p $OUT

$MP2 --nproc 24 $SEQS1,$SEQS2 --input_type fastq --mpa_pkl $MP2DB --bowtie2_exe $BT2 --bowtie2db $BT2DB --bowtie2out $SCRATCH/sample1.bowtie2.bz2 -o $SCRATCH/sample1_profile.txt


exit

