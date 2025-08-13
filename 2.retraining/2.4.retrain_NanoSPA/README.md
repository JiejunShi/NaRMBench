## Retraining pipeline for NanoSPA
## 0.Installation
```sh
git clone https://github.com/sihaohuanguc/NanoSPA.git
```
- Notes: Since NanoSPA does not provide training scripts, we implemented new training scripts based on its model architecture, which are included in the `modified_code/NanoSPA_modified_code.zip`.
## 1.Data preprocessing
The required input data here comes from the output files of step 1.preprocessing in our pipeline(fastq)
```
nanospa alignment -i $fq -r $ref -o $OUTPUT_dir
nanospa remove_intron -i $OUTPUT_dir
# Inputs:
#   $fq: Input FASTQ reads
#   $ref: Reference transcriptome (FASTA)
#   $OUTPUT_dir: Directory to store intermediate results
```
## 2.Feature extraction and labeling
```
nanospa extract_features -i $OUTPUT_dir
```
- Based on the ground truth modification sites required for training (`ground_truth_sites`), we append a new column to the extracted feature file indicating the modification status: 1 for modified and 0 for unmodified. The resulting file is used as the training dataset and saved as `$TRAIN`.
## 3.Model training
```
NanoSPA=path_to_modified_nanospa
python $NanoSPA/nanospa_train.py --features_file $TRAIN \
                        --output_dir ./model
```
## 4.Prediction on external data
```
python $NanoSPA/predict_psu.py --features_file $features.csv \
                      --model_file ./model/model.pkl \
                      --output_file predict.csv \
                      --mod $mod_base

# Notes:
#   $mod_base: The modified base of interest (A/T/C/G)
```
