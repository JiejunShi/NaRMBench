# Benchmarking the computational models detecting multitype RNA modifications from Nanopore Direct RNA Sequencing (DRS)

## Authors
- Tingting Luo
- Jiejun Shi

## dependence
![](https://img.shields.io/badge/software-version-blue)  
[![](https://img.shields.io/badge/Guppy-v6.2.1-green)](https://community.nanoporetech.com/downloads)
[![](https://img.shields.io/badge/Minimap2-v2.24-green)](https://github.com/lh3/minimap2)
[![](https://img.shields.io/badge/Nanopolish-v0.8.4-green)](https://github.com/jts/nanopolish)
[![](https://img.shields.io/badge/samtools-v1.6-green)](https://github.com/samtools/samtools)  
[![](https://img.shields.io/badge/Tombo-v1.5.1-orange)](https://github.com/nanoporetech/tombo)
[![](https://img.shields.io/badge/MINES-v0.0-orange)](https://github.com/YeoLab/MINES.git)
[![](https://img.shields.io/badge/Nanom6A-v2.0-orange)](https://github.com/gaoyubang/nanom6A)
[![](https://img.shields.io/badge/m6Anet-v1.1-orange)](https://github.com/GoekeLab/m6anet)
[![](https://img.shields.io/badge/Nanocompore-v1.0.3-orange)](https://github.com/tleonardi/nanocompore_paper_analyses)
[![](https://img.shields.io/badge/DInoPORE-v0.0-orange)](https://github.com/darelab2014/Dinopore)
[![](https://img.shields.io/badge/DENA-v0.0-orange)](https://github.com/weir12/DENA/tree/release)
[![](https://img.shields.io/badge/PsiNanopore-v0.0-orange)](https://github.com/RouhanifardLab/PsiNanopore)
[![](https://img.shields.io/badge/SingleMod-v1.0-orange)](https://github.com/xieyy46/SingleMod-v1)
[![](https://img.shields.io/badge/CHEUI-v1.0-orange)](https://github.com/comprna/CHEUI?tab=readme-ov-file#identify-differential--rna-modifications-between-two-conditions)
[![](https://img.shields.io/badge/DiffErr-v0.2-blue)](https://github.com/bartongroup/differr_nanopore_DRS)
[![](https://img.shields.io/badge/DRUMMER-v0.0-blue)](https://github.com/DepledgeLab/DRUMMER/)
[![](https://img.shields.io/badge/ELIGOS-v2.1.0-blue)](https://gitlab.com/piroonj/eligos2)
[![](https://img.shields.io/badge/Epinano-v1.2.0-blue)](https://github.com/novoalab/EpiNano)
[![](https://img.shields.io/badge/NanoRMS-v0.0-blue)](https://github.com/novoalab/nanoRMS/tree/master)
[![](https://img.shields.io/badge/NanoSPA-v0.0-blue)](https://github.com/sihaohuanguc/NanoSPA/tree/master)
[![](https://img.shields.io/badge/TandemMod-v1.1.0-blue)](https://github.com/yulab2021/TandemMod)
[![](https://img.shields.io/badge/NanoMUD-v0.0-blue)](https://github.com/ABOMSBI/NanoMUD/tree/main)
[![](https://img.shields.io/badge/m6Aiso-v0.0-blue)](https://github.com/SYSU-Wang-LAB/m6Aiso)
[![](https://img.shields.io/badge/xPore-v2.0-blue)](https://github.com/GoekeLab/xpore)  
[![](https://img.shields.io/badge/pum6a-v0.0-blue)](https://github.com/liuchuwei/pum6a) 

## 1. Preprocess:
basecalling, alignment and nanopolish eventalign `preprocess_pipeline.bash`
## 2. Model retrain:
This repository contains modified versions and retraining scripts for 5 RNA modification detection tools (m6Anet, SingleMod, Epinano, TandemMod, Dinopore). 
To retrain a model: `m6Anet_retrain_pipeline.sh` .
Modified source code for each tool is provided as a ZIP file (e.g. m6Anet_modified_code.zip)

The retrained models are saved in: `./retrained_model/`
## 3. RNA modification detection:
These models were executed with appropriate parameters to output results of all sites. `model_test_pipeline.sh`
## 4. Model Evaluation
Generates ROC and PR curves `ROC_curve.py`. 

The optimal cut-off of each model for RNA modification detection was determined by varing cut-offs and calculated F1 scores `optimal_cut-off_selection.py`.
