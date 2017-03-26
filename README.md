## Metagenomic analysis of Army Ant Guts 

### This project was done as a part of the final project for ECES-T 480 winter 2017

## Contributors:
### Ariana Entezari
### Dhantha Gunarathna
### Feiyang Xue

## This project consist of bash scripts to run the following programs. Make usre to change username, and other computing 
resources accordingly 
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

![Alt text](./Figures/metagenomics_pipeline.png?raw=true "Pipeline")

## Run Kneaddata
Source: https://bitbucket.org/biobakery/kneaddata/wiki/Home

To install kneaddata
```
mkdir -p ~/software/kneaddata
mkdir -p ~/software/kneaddata/human_genome
cd ~/software/kneaddata

wget https://pypi.python.org/packages/6d/50/dd20a862b2532a476b4837a2b1fe4f9e8131cf554751adb6fd7186ee33e3/kneaddata-0.5.4.tar.gz

tar zxvf kneaddata-0.5.4.tar.gz
rm kneaddata-0.5.4.tar.gz
cd kneaddata-0.5.4

module load python/3.5-current
python setup.py install --bypass-dependencies-install --user

export PATH=~/.local/bin/:$PATH

kneaddata_database --download human_genome bowtie2 ~/software/kneaddata/human_genome
```

Kneaddata is a tool designed to perform qulity control in metagenomic and metatranscriptomic data. Kneaddata can be run either pair end
or single pair input files.

```
kneaddata --input pair1.fastq --input pair2.fastq -db $DATABASE --output $OUT 
```
kneaddata can be run using multiple databases. For help use 

```
kneaddata --help
``
refer the kneaddata_submitter.sh to submit jobs

## Create a Database 

Use the bowtie2-build to create a custom database. By creating a custom database allows to filter contaminant sequence properly from the data.
Reference genomes to build the custom databse can be downloaded from the NCBI or other source 

```
bowtie2-build /path/to/input.fasta -o /path/to/output/db 
```



