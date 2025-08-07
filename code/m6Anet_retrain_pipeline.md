## Retraining pipeline for m6Anet
## 0.Installation
```sh
$ pip install m6anet
```
-Note: We modified the original m6Anet code to add a new $modification ($modification: one of m1A, m7G, m6A, psU, or m5C) parameter that enables detection of other RNA modifications beyond m6A. To use this enhanced version, please replace the original source code with our modified version provided in m6Anet_modified_code.zip.
## 1.Data preparation
m6Anet dataprep requires eventalign.txt from ``nanopolish eventalign``:
```
    nanopolish eventalign --reads reads.fastq --bam reads.sorted.bam --genome transcript.fa --scale-events --signal-index --summary /path/to/summary.txt  --threads 50 > $EVENTALIGN
```
After running nanopolish eventalign, we need to preprocess the segmented raw signal file using 'm6anet dataprep':
```
m6anet dataprep --eventalign $EVENTALIGN \
                --out_dir $OUT_DIR \
                --n_processes $N_PROCESSES \
                -m $modification 
```
## 2.Feature labeling and dataset generation
