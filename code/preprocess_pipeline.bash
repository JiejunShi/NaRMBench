#!/bin/bash
ws=path_to_work
guppy=path_to_guppy_software
ref=path_to_reference_transcriptome

wt_raw_fast5=path_to_input_fast5_files
ko_raw_fast5=path_to_input_fast5_files

ko_single=path_to_save_single_fast5_files
wt_single=path_to_save_single_fast5_files

wt_basecall=path_to_save_basecalled_fast5_files
ko_basecall=path_to_save_basecalled_fast5_files

#basecalling
$guppy/bin/guppy_basecaller -i $ws/wt_fast5 -s $ws/wt_basecall -c $guppy/data/rna_r9.4.1_70bps_hac.cfg --fast5_out -r  --cpu_threads_per_caller 24
cat $ws/wt_basecall/pass/*fastq > $ws/wt.fastq

##alignment
minimap2 -ax map-ont --MD -t 16 $ref $ws/wt.fastq > $ws/wt.sam
samtools view -@ 16 -bh -F 2324 $ws/wt.sam | samtools sort -@ 16 -o $ws/wt.bam
samtools index $ws/wt.bam

##trans to single fast5
multi_to_single_fast5 -i $ws/wt_fast5 -s $ws/wt_single -t 40 --recursive
mkdir -p $ws/wt_single/workspace/
find $ws/wt_single -mindepth 2 -exec cp -t $ws/wt_single/workspace/ {} +
##tombo
tombo resquiggle $ws/wt_single/workspace/ $ref \
--rna \
--corrected-group RawGenomeCorrected_000 \
--basecall-group Basecall_1D_000 \
--overwrite \
--processes 24 \
--fit-global-scale \
--include-event-stdev

#apply the same operation in ko
