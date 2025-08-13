## Model Evaluation Pipelines
This script provides a comprehensive pipeline to evaluate both original and retrained models across all supported tools.
## Tools to evaluate
```
CHEUI=path_to_CHEUI
Epinano=path_to_EpiNano
DENA=path_to_DENA
differr=path_to_differr
DRUMMER=path_to_DRUMMER
MINES=path_to_MINES
eligos=path_to_eligos2
nanocompare=path_to_Nanocompare
nanom6A=path_to_nanom6A_2022_12_22
nanomud=path_to_NanoMUD
nanoRMS=path_to_nanoRMS
psinanopore=path_to_PsiNanopore
TandemMod=path_to_TandemMod-master
xpore=path_to_xpore
SingleMod=path_to_SingleMod
Dinopore=path_to_Dinopore
pum6a=path_to_pum6a
dorado=path_to_dorado
modkit=path_to_modkit
xron=path_to_xron
```
## 0.INPUT PATH
```
ko_single=path_to_save_single_fast5_files
wt_single=path_to_save_single_fast5_files
wt_pod5=path_to_pod5_files
ko_pod5=path_to_pod5_files
wt_basecall=path_to_save_basecalled_fast5_files
ko_basecall=path_to_save_basecalled_fast5_files

gtf=path_to_reference_gtf
ref=path_to_reference_transcriptome
gene_ref=path_to_reference_genome
```
## 1. CHEUI
```
mkdir ELIGOS m6Anet MINES Nanom6A EpiNano CHEUI Tombo DiffErr DRUMME xPore Nanocompore DENA SingleMod ELIGOS_diff Epinano_delta Tombo_com NanoSPA TandemMod NanoRMS PsiNanopore NanoMUD Dinopore pum6A m6Aiso 
#m6A 
nanopolish index -d $ws/wt_single/workspace $ws/wt.fastq
nanopolish eventalign -t 48 --reads $ws/wt.fastq --bam $ws/wt.bam --genome $ref --scale-events --signal-index  --samples --print-read-names > $ws/CHEUI/wt.nanopolish.txt
python $CHEUI/scripts/CHEUI_preprocess_m6A.py -i $ws/CHEUI/wt.nanopolish.txt -m $CHEUI/kmer_models/model_kmer.csv -o $ws/CHEUI -n 30
python $CHEUI/scripts/CHEUI_predict_model1.py -i $ws/CHEUI/wt.nanopolish_output_signals+IDS.p -m $CHEUI/CHEUI_trained_models/CHEUI_m6A_model1.h5 -o $ws/CHEUI/read_level_m6A_predictions.txt -l WT_rep1
sort -k1  --parallel=15  $ws/CHEUI/read_level_m6A_predictions.txt > $ws/CHEUI/read_level_m6A_predictions_sorted.txt
python $CHEUI/scripts/CHEUI_predict_model2.py -i $ws/CHEUI/read_level_m6A_predictions_sorted.txt -m  $CHEUI/CHEUI_trained_models/CHEUI_m6A_model2.h5 -o $ws/CHEUI/site_level_m6A_predictions.txt
#5mc
python $CHEUI/scripts/CHEUI_preprocess_m5C.py -i $ws/CHEUI/wt.nanopolish.txt -m $CHEUI/kmer_models/model_kmer.csv -o $ws/CHEUI/5mc  -n 30
python $CHEUI/scripts/CHEUI_predict_model1.py -i $ws/CHEUI/5mc/wt.nanopolish_output_signals+IDS.p -m $CHEUI/CHEUI_trained_models/CHEUI_m5C_model1.h5 -o $ws/CHEUI/5mc/read_level_m5C_predictions.txt -l WT_rep1
sort -k1  --parallel=15  $ws/CHEUI/5mc/read_level_m5C_predictions.txt >$ws/CHEUI/5mc/read_level_m5C_predictions_sorted.txt
python $CHEUI/scripts/CHEUI_predict_model2.py -i $ws/CHEUI/5mc/read_level_m5C_predictions_sorted.txt -m  $CHEUI/CHEUI_trained_models/CHEUI_m5C_model2.h5 -o $ws/CHEUI/5mc/site_level_m5C_predictions.txt
```
## 2. EpiNano and EpiNano_delta
```
python $Epinano/Epinano_Variants.py -r $ref -b $ws/wt.bam -c 16 
python $Epinano/Epinano_Variants.py -r $ref -b $ws/ko.bam -c 16
python $Epinano/misc/Slide_Variants.py $ws/EpiNano/wt_gene.fwd.per.site.csv 5
python $Epinano/misc/Slide_Variants.py $ws/EpiNano/ko_gene.fwd.per.site.csv 5
python $Epinano/Epinano_Predict.py \
--model $Epinano/models/rrach.q3.mis3.del3.linear.dump \
--predict $ws/EpiNano/ko.fwd.per.site.5mer.csv \
--columns 8,13,23 \
--out_prefix $ws/EpiNano/$sample
python $Epinano/misc/Epinano_make_delta.py $ws/EpiNano/wt.fwd.per.site.5mer.csv \
$ws/EpiNano/ko.fwd.per.site.5mer.csv \
5 5 > $ws/EpiNano/$sample.wt_ko_delta.5mer.csv

#predict modifications
python $Epinano/Epinano_Predict.py \
--model $Epinano/models/rrach.deltaQ3.deltaMis3.deltaDel3.linear.dump \
--predict $ws/EpiNano/$sample.wt_ko_delta.5mer.csv \
--columns 7,12,22 \
--out_prefix $ws/EpiNano/$sample.delta
```
## 3. DENA
```
cd $ws/DENA
python3 $DENA/step4_predict/LSTM_extract.py get_pos --fasta $ref  --motif 'RRACH' --output $ws/DENA/candidate_predict_pos.txt
python3 $DENA/step4_predict/LSTM_extract.py predict --fast5 $ws/wt_single/workspace/ --bam $ws/wt.bam  --sites $ws/DENA/candidate_predict_pos.txt --processes 32 --label $sample --windows 2 2
python3 $DENA/step4_predict/LSTM_predict.py -i ./ -m $DENA/DENA_LSTM_Model/ -o $ws/DENA/result -p $sample
```
## 4. DiffErr
```
differr -a $ws/wt.bam \
-b $ws/ko.bam \
-r $ref \
-o $ws/DiffErr/differr.bed \
-f 2 \
--median-expr-threshold 0 \
--min-expr-threshold 0 \
-p 16
```
## 5. DRUMMR
```
#txt format
#fasta header
txt=path_to_transcript_list
#txt format
#ENSMUST00000000001.4

python $DRUMMER/DRUMMER.py -r $ref \
-l $txt \
-t $ws/ko.bam \
-c $ws/wt.bam \
-o $ws/DRUMMER \
-m True \
-a isoform
```
## 6. m6Anet
```
nanopolish eventalign --reads $wt.fastq \
--bam $wt.bam \
--genome $ref \
--scale-events \
--summary wt_summary.txt \
--signal-index \
--threads 16 > $ws/m6Anet/wt_eventalign.txt

#dataprep
m6anet dataprep --eventalign $ws/m6Anet/wt.nanopolish.txt \
--out_dir $ws/m6Anet/dataprep \
--n_processes 16 \
--readcount_max 2000000

#detect m6A
m6anet inferencee --input_dir $ws/m6Anet/dataprep \
--out_dir $ws/m6Anet/result \
--n_processes 16
```
## 7.Tombo and Tombo_com
```
# 7.1 Tombo

## for m6A
cd $ws/Tombo
tombo detect_modifications de_novo --fast5-basedirs $ws/wt_single/workspace \
--statistics-file-basename wt_m6A \
--corrected-group RawGenomeCorrected_000 \
--processes 16
#output statistical results
tombo text_output browser_files --fast5-basedirs $ws/wt_single/workspace \
--statistics-filename wt_m6A.tombo.stats \
--browser-file-basename wt.rrach \
--genome-fasta $ref \
--motif-descriptions RRACH:3:m6A \
--file-types coverage dampened_fraction fraction \
--corrected-group RawGenomeCorrected_000

## for m5c
tombo detect_modifications alternative_model --alternate-bases 5mC --processes 16 --fast5-basedirs $ws/wt_single/workspace --statistics-file-basename wt
tombo text_output browser_files --fast5-basedirs $ws/wt_single/workspace \
--statistics-filename wt.5mC.tombo.stats \
--genome-fasta $ref \
--motif-descriptions CG:1:CG_5mC \
--file-types coverage fraction dampened_fraction \
--browser-file-basename wt_CG_5mC

# 7.2 Tombo_com
cd $ws/Tombo_com
tombo detect_modifications model_sample_compare --fast5-basedirs $ws/wt_single/workspace \
--control-fast5-basedirs $ws/ko_single/workspace \
--statistics-file-basename wt_com \
--corrected-group RawGenomeCorrected_000 \
--processes 16

## for m6A
tombo text_output browser_files --fast5-basedirs $ws/wt_single/workspace \
--control-fast5-basedirs $ws/ko_single/workspace \
--statistics-filename wt_com.tombo.stats \
--browser-file-basename wt_com.rrach \
--genome-fasta $ref \
--motif-descriptions RRACH:3:m6A \
--file-types coverage dampened_fraction fraction \
--corrected-group RawGenomeCorrected_000

## for m5c
#CHG:1:CHG_5mC,CHH:1:CHH_5mC
tombo text_output browser_files --fast5-basedirs $ws/wt_single/workspace \
--control-fast5-basedirs $ws/ko_single/workspace \
--statistics-filename wt_com.tombo.stats \
--genome-fasta $ref \
--motif-descriptions CG:1:CG_5mC \
--file-types coverage fraction dampened_fraction \
--browser-file-basename wt_com.CG_5mC
```
## 8. MINES
```
cd $ws/MINES
tombo text_output browser_files --fast5-basedirs $ws/wt_single/workspace \
--statistics-filename $ws/Tombo/wt_m6A.tombo.stats \
--browser-file-basename wt \
--file-types coverage dampened_fraction fraction \
--corrected-group RawGenomeCorrected_000
awk '{if($0!=null){print $0}}' wt.fraction_modified_reads.plus.wig > wt.wig
wig2bed < wt.wig > wt.fraction_modified_reads.plus.wig.bed --multisplit=mines
python $MINES/cDNA_MINES.py --fraction_modified wt.fraction_modified_reads.plus.wig.bed --coverage wt.coverage.plus.bedgraph --output wt.genomic.bed --ref $ref
```
## 9. Eligos and Eligos_diff
```
bed=path_to_detection_region_bed
#bed format
#transcript 1 length * * *

eligos2 rna_mod -i $ws/wt.bam \
-reg $bed \
-ref $ref \
-o $ws/ELIGOS \
--max_depth 2000000 \
--min_depth 5 \
--esb 0 \
--oddR 0 \
--pval 1 \
-t 16
eligos2 pair_diff_mod -tbam $ws/wt.bam \
-cbam $ws/ko.bam \
-reg $bed \
-ref $ref \
-p $sample.com \
-o $ws/ELIGOS \
--max_depth 5000000 \
--min_depth 5 \
--esb 0 \
--oddR 0 \
--pval 1 \
-t 16
```
## 10. Nanocompore
```
nanocompore eventalign_collapse  -i $ws/CHEUI/wt.nanopolish.txtt \
-o $ws/Nanocompore/wt \
-t 16
nanocompore eventalign_collapse  -i $ws/CHEUI/ko.eventalign.txt \
-o $ws/Nanocompore/ko \
-t 16
nanocompore sampcomp --file_list1 $ws/Nanocompore/wt/out_eventalign_collapse.tsv \
--file_list2 $ws/Nanocompore/ko/out_eventalign_collapse.tsv \
--label1 wt --label2 ko \
--fasta $ref \
--outpath $ws/Nanocompore \
--min_coverage 5 \
--min_ref_length 10 \
--allow_warnings \
--nthreads 16
```
## 11. Nanom6a
```
bed=path_to_reference_genome_gene_bed
#bed format
#chr pos0 pos1 gene_symbol base strand
#chr1 3073252	3073253	RP23-271O17.1	A	+
find $ws/wt_single/workspace/ -name "*.fast5" > $ws/Nanom6A/wt_fast5.txt
python $nanom6A/extract_raw_and_feature_fast.py -o $ws/Nanom6A \
--basecall_group=RawGenomeCorrected_000 \
--cpu=48 \
--clip=0 \
--fl=$ws/Nanom6A/wt_fast5.txt
python $nanom6A/predict_sites.py -i $ws/Nanom6A \
-o $ws/Nanom6A/result \
-r $ref \
-g $gene_ref \
-b $bed \
--cpu 32 \
--support 5 \
--model $nanom6A/bin/model
```
## 12. NanoMUD
```
python3 $nanomud/code/feature_extraction.py \
-i $ws/wt_single/workspace/ \
-o $ws/NanoMUD \
-t 20 --group RawGenomeCorrected_000
python3  $nanomud/code/predict_mod_probs.py \
-i $ws/NanoMUD/tmp \
-o $ws/NanoMUD/probs.csv \
--device cuda:0 \
--model $nanomud/models/psi/biLSTM_model \
--scaler $nanomud/models/psi/scaler
python3  $nanomud/code/mod_rate_calibration.py \
-i $ws/NanoMUD/probs.csv \
-o $ws/NanoMUD/sitmod_rate.csv \
--device cuda:0 \
--model $nanomud/models/psi/regression_model
```
## 13. NanoRMS
```
cd $ws/NanoRMS
python3 $nanoRMS/epinano_RMS/epinano_rms.py -R $ref -b $ws/wt.bam -s $nanoRMS/epinano_RMS/sam2tsv.jar
python3 $nanoRMS/epinano_RMS/epinano_rms.py -R $ref -b $ws/ko.bam -s $nanoRMS/epinano_RMS/sam2tsv.jar
Rscript --vanilla $nanoRMS/predict_rna_mod/Pseudou_prediction_pairedcondition_transcript.R -f wt.per.site.baseFreq.csv -s ko.per.site.baseFreq.csv
```
## 14. NanoSPA
```
cd $ws/NanoSPA/
mkdir wt
nanospa alignment -i ./wt/ -r $ref -o ./wt;
nanospa remove_intron -i ./wt;
nanospa extract_features -i ./wt;
nanospa preprocess_m6A -i ./wt/features.csv;
nanospa prediction_psU -i ./wt/features.csv;
nanospa prediction_m6A -i ./wt/features -o ./wt/prediction_m6A.csv
```
## 15. PsiNanopore
```
cd $ws/PsiNanopore
mkdir result
FINAL_OUTPUT=$ws/PsiNanopore/result/psi_candidates_all.csv
SIZE_FILE=path_to_transcript_lengths.tsv
while IFS=$'\t' read -r transcript SIZE; do
  OUTPUT_FILE=$ws/PsiNanopore/result/psi_candidates_${transcript}.csv
  Rscript $psinanopore/PsiDetect.R -f $ws/wt.bam -g $ws/ko.bam -k $psinanopore/data/kmer_summary.csv -r $ref -s 1 -e $SIZE -c $transcript -m 0.05 -o $OUTPUT_FILE
  if [[ ! -s $FINAL_OUTPUT ]]; then
    head -n 1 $OUTPUT_FILE > $FINAL_OUTPUT
  fi
  tail -n +2 $OUTPUT_FILE >> $FINAL_OUTPUT
done < $SIZE_FILE
```
## 16. TandemMod 
```
python $TandemMod/scripts/extract_signal_from_fast5.py -p 40 --fast5 $ws/wt_single/workspace --reference $ref --sam $ws/wt.sam --output $ws/TandemMod/wt.signal.tsv --clip 10
python $TandemMod/scripts/extract_feature_from_signal.py  --signal_file $ws/TandemMod/wt.signal.tsv --clip 10 --output $ws/TandemMod/wt.feature_m6A.tsv --motif DRACH
python $TandemMod/scripts/TandemMod.py --run_mode predict \
    --pretrained_model $TandemMod/models/m6A_train_on_rice_cDNA.pkl \
    --feature_file $ws/TandemMod/wt.feature_m6A.tsv \
    --predict_result $ws/TandemMod/wt.predict_m6A.tsv
```
## 17. Xpore
```
xpore dataprep --eventalign $ws/CHEUI/wt.nanopolish.txt \
--out_dir $ws/xpore/wt \
--n_processes 16 \
--readcount_max 2000000
xpore dataprep --eventalign  $ws/xpore/ko.nanopolish.txt \
--out_dir $ws/xpore/ko \
--n_processes 16 \
--readcount_max 2000000
cd $ws/xpore
xpore diffmod --config $ws/xpore/1.yml \
--n_processes 16
#1.yml
#notes: Pairwise comparison without replicates with default parameter setting.
#data:
#    ko:
#        rep1: ko
#    wt:
#        rep1: wt
#out: diffmod
#criteria:
#    readcount_min: 5
#    readcount_max: 2000000
```
## 18. SingleMod
```
cd $ws/SingleMod
picard SplitSamByNumberOfReads I=$ws/wt.bam SPLIT_TO_N_FILES=25 O=./split_bam_dir
for bam in split_bam_dir/*.bam
do
{
samtools index $bam
}
done
mkdir eventalign_output_dir
for file in split_bam_dir/*.bam; do
{
  filename=$(basename "$file" .bam)

  nanopolish eventalign \
    --reads $ws/wt.fastq \
    --bam "$file" \
    --genome $ref \
    -t 15 \
    --scale-events \
    --samples \
    --signal-index \
    --summary eventalign_output_dir/"${filename}_summary.txt" \
    --print-read-names > eventalign_output_dir/"${filename}_eventalign.txt"
}
done
mkdir tmp_features  
mkdir features
cd split_bam_dir
#convert bam to bed to extract strand informationt
for file in shard*.bam
do
bedtools bamtobed -i "$file" > "${file%.bam}.bed" 
done
cd ..
#running parallelly
batch=(shard_0001 shard_0002 shard_0003 shard_0004 shard_0005 shard_0006 shard_0007 shard_0008 shard_0009 shard_0010 shard_0011 shard_0012 shard_0013 shard_0014 shard_0015 shard_0016 shard_0017 shard_0018 shard_0019 shard_0020 shard_0021 shard_0022 shard_0023 shard_0024 shard_0025)
for i in ${batch[@]}
do
python  $SingleMod/SingleMod/organize_from_eventalign.py -v 002 -b split_bam_dir/${i}.bed -e eventalign_output_dir/${i}_eventalign.txt -o tmp_features -p $i -s 500000 
done
cd tmp_features #required step
wc -l *-extra_info.txt | sed 's/^ *//g' | sed '$d' | tr " " "\t"   > extra_info.txt
cd ..
python $SingleMod/SingleMod/merge_motif_npy.py -v 002 -d tmp_features -s 500000 -p 10 -o features
mkdir prediction
#predicting
for motif in AAACA AAACC AAACT AGACA AGACC AGACT GAACA GAACC GAACT GGACA GGACC GGACT TAACA TAACC TAACT TGACA TGACC TGACT
do
python $SingleMod/SingleMod/SingleMod_m6A_prediction.py -v 002 -d features -k $motif -m $SingleMod/models/RNA002/mammal/model_${motif}.pth.tar -g 0 -b 30000 -o prediction/${motif}_prediction.txt
done
cat prediction/*_prediction.txt > prediction.txt
awk 'BEGIN{OFS=FS="\t"}{split($1,info,"|");s=info[1]"|"info[2]"|"info[3]"|"info[5];t[s]=t[s]+1;if($2 > 0.5){m[s]=m[s]+1}}END{for(i in t){split(i,info,"|");if(i in m){print info[1],info[2]-1,info[2],i,m[i]/t[i],info[3],t[i],m[i],info[4]}else{print info[1],info[2]-1,info[2],i,0,info[3],t[i],0,info[4]}}}' prediction.txt | sort -k1,1 -k2,2n > m6A_predict.bed  
```
## 19. Dinopore
```
cd $ws/Dinopore
bash $Dinopore/code/mainscript1.sh -e $ws/Dinopore/data -r $ref -n 30 -g $sample
bash $Dinopore/code/mainscript2.sh -e $ws/Dinopore/data -r $ref -n 30 -g $sample
```
## 20. pum6A
```
python $pum6a/run.py preprocess --single $ws/wt_single/workspace -o $ws/pum6a -g $gene_ref -r $ref -i $bed -b $ws/ws.bam
python $pum6a/run.py predict --config $ws/pum6a/config.toml
##config.toml
#output="result/pum6a/AGS_Normal_A2"
#
#[dataload]
#    signal="wt.feature.tsv"
#    motif=  ["AAACA", "AAACT", "AGACC", "GAACA", "GAACT", "GGACC", "AAACC", "AGACA", "AGACT", "GAACC", "GGACA", "GGACT"]
#    min_read=5
#    inference=true
#[model]
#    model_path = '$pum6A/result/293T_model/hV0Pn_231228142737_88888888_ran_model.pt'
#    device = 'cuda'
```
## 21. m6Aiso
```
python -m m6Aiso current_signal_abstract_for_m6A_pred --nanopolish_result $ws/m6Anet/wt.nanopolish.txt --number 16 --out_dir $ws/m6Aiso
python -m m6Aiso molecular_m6A_predication --model_path $m6Aiso/module/semi_model_7mer.times_over.epoch_0.pt \
        --using_signal_filename $ws/m6Aiso/Candidatecurrent.tsv --predict_result_filename $ws/m6Aiso/m6A_prob.txt \
        --max_value_filename $m6Aiso/data/merge_max_value_list.txt \
        --min_value_filename $m6Aiso/data/merge_min_value_list.txt
```
## 22. Dorado
```
$dorado/bin/dorado basecaller $dorado/rna004_130bps_sup@v5.2.0  $wt_pod5 --reference $ref --reference $ref --modified-bases m6A_DRACH >  $ws/wt_basecall/wt.bam
$modkit pileup $ws/wt_basecall/wt.bam $ws/wt.dorado.bed
```
## 23. Xron
```
$xron call -i $ws/wt_single/workspace -o $ws/wt_basecall --fast5 -m $xron/models/RNA004 --device cuda --batch_size 200
```
