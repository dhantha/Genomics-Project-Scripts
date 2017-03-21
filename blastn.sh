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

USERNAME=dag332
export PATH=/home/$USERNAME/software/ncbi-blast-2.2.18+/bin/:$PATH

DB=/home/dag332/software/db/protein
IN=/scratch/$USERNAME/bwa_out/file2/scaffold.fa
OUT=/scratch/$USERNAME/blastn/sample1

blastn -task megablast -query /scratch/dag332/bwa_out/file5/scaffold.fa -db /home/dag332/software/db/nucl/nt -max_target_seqs 1 -outfmt 6 -num_threads 4 > sample5_assembly.megablast.nt

exit
