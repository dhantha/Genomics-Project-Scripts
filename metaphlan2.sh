#!/bin/bash
#$ -S /bin/bash
#$ -cwd
#$ -M dag332@drexel.edu
#$ -l h_rt=24:00:00
#$ -P rosenclassPrj
#$ -pe shm 4
#$ -l h_vmem=64G
#$ -l mem_free=60G
#$ -q all.q 

. /etc/profile.d/modules.sh
module load shared
module load proteus
module load sge/univa
module load gcc/4.8.1
module load bowtie2/2.2.5

##export PATH=~/software/metaphlan2/metaphlan2:$PATH
##export mpa_dir=~/software/metaphlan2/metaphlan2

USERNAME=dag332
MP_LOC=/home/$USERNAME/software/metaphlan2/metaphlan2
##SEQS1=/scratch/$USERNAME/kneaddata/kneaddata_output/pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_1.fastq
##SEQS2=/scratch/$USERNAME/kneaddata/kneaddata_output/pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_2.fastq

SCRATCH=/scratch/$USERNAME/metaphlan2/raw/sample1
##OUT=/scratch/$USERNAME/Bio/Project/metaphlan_out



MP2=$MP_LOC/metaphlan2.py
MMT=$MP_LOC/utils/merge_metaphlan_tables.py
BT2=/mnt/HA/opt/bowtie2/2.2.5/bin/bowtie2
MP2DB=$MP_LOC/db_v20/mpa_v20_m200.pkl
BT2DB=$MP_LOC/db_v20/mpa_v20_m200

##mkdir -p $SCRATCH
##mkdir -p $OUT

##for srr in ${SRRS[@]}
##do
$MP2 --nproc 4 $SEQS1,$SEQS2 --input_type fastq --mpa_pkl $MP2DB --bowtie2_exe $BT2 --bowtie2db $BT2DB --bowtie2out $SCRATCH/sample1.bowtie3.bz2 -o $SCRATCH/pair1.txt
##done

##$MMT  $SCRATCH/*_profile.txt > $OUT/merged_table.txt

exit
