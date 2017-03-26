## Metagenomic analysis of Army Ant Guts 

### This project was done as a part of the final project for ECES-T 480 winter 2017

## Contributors:
### 1. Ariana Entezari
### 2. Dhantha Gunarathna
### 3. Feiyang Xue

## This project consist of bash scripts to run the following programs 
```
1. FASTQC
2. Kneaddata
3. Bowtie2-build (custom database)
4. MetaPhlAn2
5. HUMAnN2
6. IDBA
7. QUAST
8. BLASTn
9. Diamond
10. Megan 5/6
``` 

![Alt text](/Figures/metagenomics_pipeline.png?raw=true "Pipeline")

## Create a Database 

Use the bowtie2-build to create a custom database. By creating a custom database allows to filter contaminant sequence properly from the data.
Reference genomes to build the custom databse can be downloaded from the NCBI or other source 
```
bowtie2-build /path/to/input.fasta -o /path/to/output/db 
```

## Run Kneaddata

Kneaddata 



