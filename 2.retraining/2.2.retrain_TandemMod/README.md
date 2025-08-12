## Retraining pipeline for TandemMod
## 0.Installation
```sh
TandemMod origin code(https://github.com/yulab2021/TandemMod)
```
## 1.Extract raw signal and motif-level features
The required input data here comes from the output files of step 1.preprocessing in our pipeline(sam,single_fast5).
```
python scripts/extract_signal_from_fast5.py -p 40 \
       --fast5 $prefix/$mod_guppy_single \
       --reference $ref \
       --sam $sam \
       --output $mod.signal.tsv \
       --clip 10

python scripts/extract_feature_from_signal.py \
       --signal_file $prefix/$mod.signal.tsv \
       --clip 10 \
       --output $mod.feature.tsv \
       --motif $MOTIF
# Arguments:
#   $mod: Modification type (e.g., m6A, m1A, m7G, psU, m5C)
#   $MOTIF: Motif pattern (e.g., DRACH for m6A, NNANN for m1A)
```
- Note: Based on the known ground truth modification sites from`ground_truth_sites`, we split the extracted `feature.tsv` file into two separate files: mod (modified) and unmod (unmodified). Each of these files is then further divided into training and testing sets in a 4:2 ratio, resulting in four files: `mod.train`, `mod.test`, `unmod.train`, and `unmod.test`.
## 2.Train TandemMod model
```
python TandemMod.py --run_mode train \
       --new_model new.model.pkl \
       --train_data_mod mod.train.feature.tsv \
       --train_data_unmod unmod.train.feature.tsv \
       --test_data_mod mod.test.feature.tsv \
       --test_data_unmod unmod.test.feature.tsv \
       --epoch 100
```
## 3.Predict modifications on external validation set
```
python TandemMod.py --run_mode predict \
       --pretrained_model new.model.pkl \
       --feature_file $External_validation_set.feature.tsv \
       --predict_result predict.tsv
```
