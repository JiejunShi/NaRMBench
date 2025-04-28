#!/bin/bash
# Retraining pipeline for NanoSPA
NanoSPA=path_to_modified_nanospa
#The current directory is the modified NanoSPA
# Step 0 - Data preprocessing
nanospa alignment -i $fq -r $ref -o $OUTPUT_dir
nanospa remove_intron -i $OUTPUT_dir
# Inputs:
#   $fq: Input FASTQ reads
#   $ref: Reference transcriptome (FASTA)
#   $OUTPUT_dir: Directory to store intermediate results

# Step 1 - Feature extraction and labeling
nanospa extract_features -i $OUTPUT_dir

# Label modified and unmodified sites (e.g., A/C/G/T)
awk 'BEGIN{FS=OFS=","} $3 == "'$mod_base'" {print $0, 1}' $OUTPUT_dir_IVET/features.csv > ./IVET_mod.csv
awk 'BEGIN{FS=OFS=","} $3 == "'$mod_base'" {print $0, 0}' $OUTPUT_dir_unmodIVET/features.csv > ./IVET_unmod.csv
# label.py: This script assigns binary modification labels (0 or 1) to each site based on a known list of modified loci (e.g., loci_293T.bed format).

# Combine and generate training dataset
cat IVET_unmod.csv IVET_mod.csv > IVET_train.csv
cat Hek293T_train_basal.csv IVET_train.csv > 293T_IVET_train.csv

# Step 2 - Model training
python $NanoSPA/nanospa_train.py --features_file 293T_IVET_train.csv \
                        --output_dir ./293T_IVET_model

# Step 3 - Prediction on external data
python $NanoSPA/predict_psu.py --features_file hela/features.csv \
                      --model_file ./293T_IVET_model/model.pkl \
                      --output_file ./293T_IVET_predict.csv \
                      --mod $mod_base

# Notes:
#   $mod_base: The modified base of interest (A/T/C/G)

