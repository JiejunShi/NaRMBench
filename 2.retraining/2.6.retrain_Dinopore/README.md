## Retraining pipeline for Dinopore
## 0.Installation
```
unzip Dinopore_modified_code.zip
codedir=path_to_modified_Dinopore
```
## 1.Basecalling, mapping, and signal extraction with nanopolish
```
bash ${codedir}/S1.Basecall_map_nanopolish.sh $exptdir $ref $numcore
# Arguments:
#   $exptdir: Directory containing sample folder (e.g., include fastq,fast5)
#   $ref:     Reference genome (FASTA)
#   $numcore: Number of cores for parallel processing
```
## 2.Convert BAM to TSV and combine signal at 5-mer resolution
```
bash ${codedir}/S2.Process_bam_nnpl.sh $exptdir $ref $numcore
```
## 3.Generate raw feature table by combining signal and sequence information
```
bash ${codedir}/S3.Generate_raw_features.sh $exptdir $numcore
```
## 4.Aggregate read-level features to genomic positions
```
bash ${codedir}/S4.Aggregate_reads_into_pos.sh $exptdir $numcore $agggrp
#   $agggrp: Sample prefix used in naming output
tail -n +2 ./$exptdir/matrix_CNN/${agggrp}.Agg.morefts.10bin.inML.txt >> raw_featrue.txt
```
## 5.Generate training and validation matrices for CNN input
```
Rscript ${codedir}/s5.Train_preprocess_data_matrix_inputCNN_train_val.R \
        -t $numcore -i raw_featrue.txt -o $output -c $classref
#   $output:    Output RDS file name
#   $classref:  Ground truth annotation file for training
```
* `` $classref`` format: contig  position  strand  edit   rate. from ``ground_truth_sites``
## 6.Train classification model
```
Rscript ${codedir}/s6b.Training_classification_model_2class.R \
        -v validation_matrix.rds -t training_matrix.rds -o $output -e $epoch -b $batch
#   $epoch:  Number of training epochs
#   $batch:  Batch size
```
## 7.Predict on test data using trained model
```
Rscript ${codedir}/s7.Predict_test_data_using_trained_models.R \
        -i validation_matrix.rds -t $numcore -M $model2c
#   $model2c: Trained 2-class model file (.h5)
```
## 8.Validate model on external dataset
```
Rscript ${codedir}/s5.Preprocess_data_matrix_inputCNN.R \
        -t $numcore -i $input_feature -o $output
#   $input_feature: Aggregated feature file (Agg.morefts.10bin.inML.txt)

Rscript ${codedir}/s6.Predict_other_data.R \
        -i $output -t $numcore -M $external_model
#   $external_model: Trained model for external validation (e.g., best_pos5_mix_3c_1vs1_resnet.h5)
```
