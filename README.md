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

![Alt text](https://github.com/dhantha/Genomics-Project-Scripts/blob/master/Figures/metagenomics%20pipeline.png)

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

## Unassembled data pipeline

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

## Assembled Data Pipeline

## IDBA
IDBA-UD is a iterative De Bruijn Graph De Novo Assembler for Short Reads Sequencing data with Highly Uneven Sequencing Depth.
Source: http://i.cs.hku.hk/~alse/hkubrg/projects/idba_ud/

dependencies: automake and autoconf
check if they are installed by the following command
if no error rises, then they are in place
if error does show up, you need to install them before building IDBA
```
autoconf --help
automake --help
```

download and install autoconf, with example of 2.69
```
wget http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz
tar -xf autoconf-2.69.tar.gz
cd autoconf-2.69
./configure --prefix=$home_local
make -j
make install
cd ..
```

download and install automake, with example of 1.15
```
wget http://ftp.gnu.org/gnu/automake/automake-1.15.tar.gz
tar -xf automake-1.15.tar.gz
cd automake-1.15
./configure --prefix=$home_local
make -j
make install
cd ..
```

download idba from github
```
git clone https://github.com/loneknightpy/idba
```

build and install idba
```
cd idba
aclocal
autoconf
automake --add-missing
./configure --prefix=$home_local
make -j
make install
cd ..
```

IDBA usage: fq2fa
if input is fastq format, use this to convert to fasta format
if input is pair ended, then use the merge flag
```
fq2fa --merge $path_to_input_1.fastq $path_to_input_2.fastq $path_to_output.fasta
```

if input is pair ended with maximum read length more than 128, 
then source of IDBA need to modified accordingly
edit this file in IDBA source:
src\sequence\short_sequence.h
line 102 where it has "static const uint32_t kMaxShortSequence = 128;"
change the numerical value to match the longest read of the input fasta file
for finding out the longest read length, you can call the following to input file
```
idba -l $path_to_input.fasta -o $path_to_a_temp_dir
```
then break the process by Ctrl+C once you see something like:
"read_length 151"
longest read length is this numerical value PLUS ONE (+1)
i.e. if it shows as 151, then the longest length is 152
after the source code is changed, navigate to the idba folder where it was built
then rebuild and reinstall idba by the following
```
make clean
make -j
make install
```
 
use IDBA for pair ended input or non pair ended short reads (read length < 128)
```
idba -r $path_to_input_file.fasta -o $path_to_output_directory --num_threads 16 --mink 20 --maxk 100 --step 20
```

use IDBA for non pair ended long reads (>128)
note that this does not apply to pair ended long reads. 
```
idba -l $path_to_input_file.fasta -o $path_to_output_directory --num_threads 16 --mink 20 --maxk 100 --step 20
```

## QUAST
Source: http://bioinf.spbau.ru/en/quast

To install
```
wget https://github.com/ablab/quast/archive/quast_4.5.zip
unzip quast_4.5.zip
cd quast-quast_4.5

./setup.py install

quast $path_to_idba_output_directory/scaffold.fa
```


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

```
blastn -task megablast -query $ASSEMBLY -db $BLASTDB/nt -max_target_seqs 1 -outfmt 6 > $ASSEMBLY.megablast.nt
```

### BLASTn Taxonomic Report

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

### BWA summary report
In https://github.com/sujaikumar/assemblage By Sujai Kumar 
```
sam_len_cov_gc_insert.pl -s samfile -f scaffold.fa
```


## GC Plots

![Alt text](https://github.com/dhantha/Genomics-Project-Scripts/blob/master/Figures/GC%20Plots/gc.PNG)

## Diamond
To get Diamond

```
wget https://github.com/bbuchfink/diamond/releases/download/v0.8.36/diamond-linux64.tar.gz
tar -xf diamond-linux64.tar.gz
```
download and extract the latest release executable binary from https://github.com/bbuchfink/diamond/releases
example with v0.8.36

run diamond
note that the values of block-size and index-chunks can be adjusted for increase or reduce memory usage
smaller index-chunks uses more memory, and its minimum is 1
larger block-size uses more memory
these 2 arguments can be left blank so it will use default value
the values in this example leads to memory usage about 200GB

```
diamond blastx -d $path_to_nr_database -q $path_to_input_file -a $path_to_output_file --block-size 18.0 --index-chunks 2
```
## Megan 6

dependencies: java runtime environment (JRE)
type in the command below. if it returns an error, then JRE needs to be downloaded and installed
```
java -version
```

download: http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html
download the one ends with "linux-x64.tar.gz"
then tar -xf path_to_the_jre.tar.gz
then navigate to, for example, jre1.8.0_121/bin
add this path to environment path by "export PATH=$PWD:$PATH"

example with MEGAN 6 community edition
download the corresponding edition of megan 6 from https://ab.inf.uni-tuebingen.de/software/megan6

navigate to the downloaded file, and install it by calling:
```
sh MEGAN_Community_unix_6_7_10.sh
```
follow the installation
start megan by type in:
```
MEGAN
```

## Megan 5 workaround
note: this should be avoided unless absoutely necessary
download NCBI accession2taxid dump for protein
```
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/prot.accession2taxid.gz
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/pdb.accession2taxid.gz
wget ftp://ftp.ncbi.nih.gov/pub/taxonomy/accession2taxid/dead_prot.accession2taxid.gz
```
extract these files
```
tar -xf *.accession2taxid.gz
```
sort them for binary search
note the value after -S tells the sort how many memory it's allowed to use
```
LC_COLLATE=C sort *.accession2taxid -S 30G > accession2taxid.sorted
```

use diamond view to convert diamond DAA file to (tab) m8 file
```
diamond view -a $path_to_input.daa -o $path_to_output.m8
```
run the script to the m8 file
```
python add_taxid_v5.py --map $path_to_accession2taxid_dot_sorted $path_to_diamond_output.m8
```
