#!/bin/bash
# Retraining pipeline for EpiNano
Epinano=path_to_EpiNano
#https://github.com/novoalab/EpiNano/tree/master
# Step 0 - Align reads to genome reference
# (This step is assumed completed before running this pipeline)

# Step 1 - Generate sequence and signal features
python $Epinano/Epinano_Variants.py -r $ref -b $bam -c $nthread
# Input:
#   $ref: Reference genome (FASTA)
#   $bam: Aligned reads (BAM)
# Output:
#   Variants table containing mismatch and signal features per position

python $Epinano/Slide_Variants.py $per_site_var $kmer_length
# Input:
#   $per_site_var: Variants table from Epinano_Variants.py
#   $kmer_length: Length of k-mer window (e.g. 5)
# Output:
#   fwd.per.site.${kmer_length}.csv: Feature matrix for model training

# Step 2 - Train prediction model
python $Epinano/Epinano_Predict.py -o $prefix \
                          --kernel linear \
                          -mc 26 \
                          -cl 8,13,23 \
                          -t $TRAIN \
                          -p $PREDICT
# Inputs:
#   $TRAIN: Feature table used for training (CSV)
#   $PREDICT: Feature table for prediction or testing
#   -mc: Number of Monte Carlo simulations
#   -cl: Columns used for training (e.g. mismatch, current_mean, dwell_time)
# Output:
#   Trained model saved as $prefix.model.pkl

# Step 3 - Predict RNA modifications using trained model
python $Epinano/Epinano_Predict.py --model $MODEL \
                          --predict $PREDICT \
                          --columns 8,13,23 \
                          --out_prefix $prefix
# Inputs:
#   $MODEL: Trained model file (.pkl)
#   $PREDICT: Feature table for testing/prediction
# Output:
#   Prediction results written to $prefix.output.csv
