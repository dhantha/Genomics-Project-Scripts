#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -j y
#$ -M dag332@drexel.edu
#$ -P rosenclassPrj
#$ -q all.q
#$ -pe shm 24
#$ -l h_rt=12:00:00
#$ -l h_vmem=8G
#$ -l m_mem_free=4G

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load bowtie2/2.2.5

export PATH=~/software/metaphlan2/metaphlan2:$PATH
export mpa_dir=~/software/metaphlan2/metaphlan2

USERNAME=dag332
MP_LOC=/home/$USERNAME/software/metaphlan2/metaphlan2
SEQS1=/home/$USERNAME/Bio/Project/kneaddata_output/seqs/JRKD001_S1_L001_R1_001_kneaddata_paired_1.fastq
SEQS2=/home/$USERNAME/Bio/Project/kneaddata_output/seqs/JRKD001_S1_L001_R1_001_kneaddata_paired_2.fastq

SCRATCH=/scratch/$USERNAME/metaphlan2
OUT=/home/$USERNAME/Bio/Project/metaphlan_out

#SRAS=($(ls $SEQS/*.fastq*))
#SRRS=($(for sra in ${SRAS[@]};do echo ${sra%_*.fastq};done | uniq))

MP2=$MP_LOC/metaphlan2.py
MMT=$MP_LOC/utils/merge_metaphlan_tables.py
BT2=/mnt/HA/opt/bowtie2/2.2.5/bin/bowtie2
MP2DB=$MP_LOC/db_v20/mpa_v20_m200.pkl
BT2DB=$MP_LOC/db_v20/mpa_v20_m200

mkdir -p $SCRATCH
mkdir -p $OUT

#for srr in ${SRRS[@]}
#do
$MP2 --nproc 24 $SEQS1,$SEQS2 --input_type fastq --mpa_pkl $MP2DB --bowtie2_exe $BT2 --bowtie2db $BT2DB --bowtie2out $SCRATCH/sample1.bowtie2.bz2 -o $SCRATCH/sample1_profile.txt
#done

#$MMT  $SCRATCH/*_profile.txt > $OUT/merged_table.txt

exit
