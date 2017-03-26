## Metagenomic analysis of Army Ant Guts 

### This project was done as a part of the final project for ECES-T 480 winter 2017

## Contributors:
### Ariana Entezari
### Dhantha Gunarathna
### Feiyang Xue

## This project consist of bash scripts to run the following programs. Make sure to change username, and other computing resources accordingly 
```
1. FASTQC
2. Kneaddata
3. Bowtie2-build (custom database)
4. MetaPhlAn2
5. HUMAnN2
6. IDBA
7. QUAST
8. BLASTn
9. BWA
10. Diamond
11. Megan 5/6
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
```

refer the kneaddata_submitter.sh to submit jobs

## Bowtie2-build

Use the bowtie2-build to create a custom database. By creating a custom database allows to filter contaminant sequence properly from the data.
Reference genomes to build the custom databse can be downloaded from the NCBI or other source 

```
bowtie2-build /path/to/input.fasta -o /path/to/output/db 
```

## MetaPhlAn2

MetaPhlAn is a computational tool for profiling the composition of microbial communities (Bacteria, Archaea, Eukaryotes and Viruses) from metagenomic shotgun sequencing data with species level resolution

Source: https://bitbucket.org/biobakery/metaphlan2

To install MetaPhlAn2
```
mkdir -p ~/software/metaphlan2
cd ~/software/metaphlan2

wget https://bitbucket.org/biobakery/metaphlan2/get/default.zip
unzip default.zip
rm default.zip

mv biobakery-metaphlan2* metaphlan2
cd metaphlan2

export PATH=~/software/metaphlan2/metaphlan2:$PATH
export mpa_dir=~/software/metaphlan2/metaphlan2
```

To Run 
```
metaphlan2.py metagenome.fastq --input_type fastq > profiled_metagenome.txt
```
MetaPhlAn2 can take either pair end or combined fastq files. Refer to metaphlan2.sh for pair end submit and metaphaln combined for combined fastq. 
Pair end files can be combines using qiime join_paired_ends.py (http://qiime.org/scripts/join_paired_ends.html)

## HUMAnN2
Source: https://bitbucket.org/biobakery/humann2/wiki/Home

HUMAnN is a pipeline for efficiently and accurately profiling the presence/absence and abundance of microbial pathways in a community from metagenomic or metatranscriptomic sequencing data

To install humann2
```
mkdir -p ~/software/humann2
mkdir -p ~/software/humann2/chocophlan 
cd ~/software/humann2

wget https://pypi.python.org/packages/71/70/9c45436b6dab38706826a822411d6386376205d9c9fa53972e2ff3b7dda8/humann2-0.9.9.tar.gz

tar zxvf humann2-0.9.9.tar.gz
rm humann2-0.9.9.tar.gz
cd humann2-0.9.9

module load python/3.5-current
python setup.py install --bypass-dependencies-install --user

humann2_databases --download chocophlan full ~/software/humann2/chocophlan 

export PATH=~/.local/bin/:$PATH

humann2_test
humann2_test --run-functional-tests-tools
```

Basic usage of HUMAnN2 

```
$ humann2 --input $SAMPLE --output $OUTPUT_DIR
```

Three output files will be created:
```
$OUTPUT_DIR/$SAMPLENAME_genefamilies.tsv
$OUTPUT_DIR/$SAMPLENAME_pathcoverage.tsv
$OUTPUT_DIR/$SAMPLENAME_pathabundance.tsv
```



Refer to humann2.sh on how to submit a job

## IDBA
IDBA-UD is a iterative De Bruijn Graph De Novo Assembler for Short Reads Sequencing data with Highly Uneven Sequencing Depth.
Source: http://i.cs.hku.hk/~alse/hkubrg/projects/idba_ud/

## BLASTn

To run a nucleotide blastn first the NCBI nucleotide database must be download and built in the local environmental 

```
wget ftp://ftp.ncbi.nih.gov/blast/db/nt.??.tar.gz
```

NCBI taxonomy dumps and unpacked 
```
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/gi_taxid_nucl.dmp.gz
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/taxdump.tar.gz
```

In https://github.com/sujaikumar/assemblage By Sujai Kumar has blastn_taxnomy_report.pl which gives individual taxa for each
scaffold. 
```
blast_taxonomy_report.pl \
    -b $assemblyfile.r10000.megablast.nt \
    -nodes /path/to/ncbi/taxdmp/nodes.dmp \
    -names /path/to/ncbi/taxdmp/names.dmp \
    -gi_taxid_file /path/to/ncbi/taxdmp/gi_taxid_nucl.dmp.gz \
    -t genus=1 -t order=1 -t family=1 -t superfamily=1 -t kingdom=1 \
>$assemblyfile.r10000.megablast.nt.taxon
```

## BWA
BWA is a software package for mapping low-divergent sequences against a large reference genome, such as the human genome.
Source: http://bio-bwa.sourceforge.net/bwa.shtml

To run bwa  
```
bwa index scaffold.fa

bwa mem scaffold.fa input_seq1.fastq input_seq2.fastq > samfile
```

### To get the length of the coverage
```
sam_len_cov_gc_insert.pl -s samfile -f scaffold.fa
```








