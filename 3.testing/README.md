## Model testing
We provide a comprehensive testing pipeline to evaluate both original and retrained models across all supported tools.
## Test Tools
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
## 1.CHEUI
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
#apply the same analysis in ko
```
## 2.Epinano
```
```
## 3.DENA
```
```
## 4.differr
```
```
## 5. DRUMMR
```
```
## 6.m6Anet
```
```
## 7.tombo
```
```
## 8. MINES
```
```
## 9.eligos
```
```
## 10.nanocompare
```
```
## 11.Nanom6a
```
```
## 12.nanomud
```
```
## 13. nanoRMS
```
```
## 14.nanoSPA
```
```
## 15. PsiNanopore
```
```
## 16. TandemMod 
```
```
## 17.xpore
```
```
## 18. SingleMod
```
```
## 19. Dinopore
```
```
## 20. pum6A
```
```
## 21.m6Aiso
```
```
## 22.dorado
```
```
## 23.xron
```
```
