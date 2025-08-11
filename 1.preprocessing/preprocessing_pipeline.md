## DRS data preprocessing scripts.
This script provides a step-by-step pipeline for preprocessing Oxford Nanopore Direct RNA Sequencing data, from basecalling to alignment and signal re-squiggling using Tombo.
## 0.Set Paths
```
# Working directory
ws=/path/to/work_dir

# Software paths
guppy=/path/to/guppy
dorado=/path/to/dorado
ref=/path/to/reference_transcriptome.fa

# Input files
wt_pod5=/path/to/input_pod5_files
wt_raw_fast5=/path/to/input_fast5_files

# Output directories
wt_single=${ws}/wt_single_fast5
wt_basecall=${ws}/wt_basecall
```
## 1.Basecalling
```
#RNA002
$guppy/bin/guppy_basecaller -i $ws/wt_fast5 -s $ws/wt_basecall -c $guppy/data/rna_r9.4.1_70bps_hac.cfg --fast5_out -r  --cpu_threads_per_caller 24
cat $ws/wt_basecall/pass/*fastq > $ws/wt.fastq
#RNA004
$dorado/bin/dorado basecaller $dorado/rna004_130bps_sup@v5.2.0  $wt_pod5 --reference $ref  > $ws/wt_basecall/wt.bam
samtools fastq $ws/wt_basecall/wt.bam  > $ws/wt_basecall/wt.fastq
```
## 2.Alignment
```
minimap2 -ax map-ont --MD -t 16 $ref $ws/wt.fastq > $ws/wt.sam
samtools view -@ 16 -bh -F 2324 $ws/wt.sam | samtools sort -@ 16 -o $ws/wt.bam
samtools index $ws/wt.bam
```
## 3.Convert to Single FAST5 Format
```
multi_to_single_fast5 -i $ws/wt_fast5 -s $ws/wt_single -t 40 --recursive
mkdir -p $ws/wt_single/workspace/
find $ws/wt_single -mindepth 2 -exec cp -t $ws/wt_single/workspace/ {} +
```
## 4.Tombo Re-squiggle
```
tombo resquiggle $ws/wt_single/workspace/ $ref \
--rna \
--corrected-group RawGenomeCorrected_000 \
--basecall-group Basecall_1D_000 \
--overwrite \
--processes 24 \
--fit-global-scale \
--include-event-stdev
```
