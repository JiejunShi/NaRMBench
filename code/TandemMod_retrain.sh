#!/bin/bash
# Retraining pipeline for TandemMod
#TandemMod origin code(https://github.com/yulab2021/TandemMod)
# Step 0 - Data preprocessing
# Includes: basecalling, multi-fast5 to single-fast5 conversion, resquiggling, and alignment to reference transcripts using minimap2
# (Assumed to be completed before feature extraction)

# Step 1 - Extract raw signal and motif-level features
python scripts/extract_signal_from_fast5.py -p 40 \
       --fast5 $prefix/$mod_guppy_single \
       --reference $ref \
       --sam $sam \
       --output $mod.signal.tsv \
       --clip 10

python scripts/extract_feature_from_signal.py \
       --signal_file $prefix/$mod.signal.tsv \
       --clip 10 \
       --output $prefix/$mod.feature.tsv \
       --motif $MOTIF
# Arguments:
#   $mod: Modification type (e.g., m6A, m1A, m7G, psU, m5C)
#   $MOTIF: Motif pattern (e.g., DRACH for m6A, NNANN for m1A)

# Step 2 - Merge features and split into training/testing sets
# Merge modified and unmodified features
cat Hek293t_mod.feature2_$mod.tsv IVET_$mod.feature.tsv > 292T_IVET_$mod.feature.tsv
cat Hek293t_umod.feature2_$mod.tsv IVET_unmodified_$mod.feature.tsv > 292T_IVET_unmod_$mod.feature.tsv

# Random split (80% train / 20% test) for modified
total_lines=$(wc -l < 292T_IVET_$mod.feature.tsv)
train_lines=$((total_lines * 80 / 100))
test_lines=$((total_lines - train_lines))
shuf 292T_IVET_$mod.feature.tsv | tee \
    >(head -n "$train_lines" > 292T_IVET_$mod.train.feature.tsv) \
    >(tail -n "$test_lines" > 292T_IVET_$mod.test.feature.tsv) > /dev/null

# Random split (80% train / 20% test) for unmodified
total_lines=$(wc -l < 292T_IVET_unmod_$mod.feature.tsv)
train_lines=$((total_lines * 80 / 100))
test_lines=$((total_lines - train_lines))
shuf 292T_IVET_unmod_$mod.feature.tsv | tee \
    >(head -n "$train_lines" > 292T_IVET_unmod_$mod.train.feature.tsv) \
    >(tail -n "$test_lines" > 292T_IVET_unmod_$mod.test.feature.tsv) > /dev/null

# Step 3 - Train TandemMod model
python TandemMod.py --run_mode train \
       --new_model model/293T_IVET_train/$mod.demo.293T_IVET.pkl \
       --train_data_mod $feature/292T_IVET_$mod.train.feature.tsv \
       --train_data_unmod $feature/292T_IVET_unmod_$mod.train.feature.tsv \
       --test_data_mod $feature/292T_IVET_$mod.test.feature.tsv \
       --test_data_unmod $feature/292T_IVET_unmod_$mod.test.feature.tsv \
       --epoch 100

# Step 4 - Predict modifications on external validation set
python TandemMod.py --run_mode predict \
       --pretrained_model model/293T_IVET_train/$mod.demo.293T_IVET.pkl \
       --feature_file $External_validation_set.feature2_$mod.tsv \
       --predict_result predict.tsv
