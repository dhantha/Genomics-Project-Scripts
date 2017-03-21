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
module load python/3.5-current
module load diamond/gcc/0.7.9
module load bowtie2/2.2.5


### Change pair, filename, outdir
USERNAME=dag332
SCRATCH=/scratch/$USERNAME/humann
INPUT=/scratch/$USERNAME/kneaddata/kneaddata_output/pair5/JRKD006_S5_L001_R1_001_kneaddata_paired_2.fastq
DB=/scratch/$USERNAME/humann/chocophlan
PROTEIN=/scratch/$USERNAME/humann/uniref
OUT=$SCRATCH/file10

export PATH=~/.local/bin/:$PATH
export PATH=~/software/metaphlan2/metaphlan2:$PATH

humann2 --input $INPUT --output $OUT --nucleotide-database $DB --protein-database $PROTEIN --threads 4 --verbose

exit
