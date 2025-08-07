## Retraining pipeline for Epinano
## 0.Installation
```sh
git clone git@github.com:enovoa/EpiNano.git
```
## 1.Generate sequence and signal features
```
Epinano=path_to_EpiNano
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
```
## 2.Train prediction model
```
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
```
- Note: We use the `fwd.per.site.${kmer_length}.csv` file and assign a binary `Match` value to each site based on the known ground truth modification sites `benchmarking_sites` : 1 for modified and 0 for unmodified. The final output is the training file $TRAIN, with an additional Match column indicating the modification status.
## 3.Predict RNA modifications using trained model
```
python $Epinano/Epinano_Predict.py --model $MODEL \
                          --predict $PREDICT \
                          --columns 8,13,23 \
                          --out_prefix $prefix
# Inputs:
#   $MODEL: Trained model file (.pkl)
#   $PREDICT: Feature table for testing/prediction
# Output:
#   Prediction results written to $prefix.output.csv
```
