# Benchmarking the computational models detecting multitype RNA modifications from Nanopore Direct RNA Sequencing (DRS)

## Dependency
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
[![](https://img.shields.io/badge/Dinopore-v0.0-orange)](https://github.com/darelab2014/Dinopore)
[![](https://img.shields.io/badge/DENA-v0.0-orange)](https://github.com/weir12/DENA/tree/release)
[![](https://img.shields.io/badge/PsiNanopore-v0.0-orange)](https://github.com/RouhanifardLab/PsiNanopore)
[![](https://img.shields.io/badge/SingleMod-v1.0-orange)](https://github.com/xieyy46/SingleMod-v1)
[![](https://img.shields.io/badge/CHEUI-v1.0-orange)](https://github.com/comprna/CHEUI?tab=readme-ov-file#identify-differential--rna-modifications-between-two-conditions)
[![](https://img.shields.io/badge/DiffErr-v0.2-blue)](https://github.com/bartongroup/differr_nanopore_DRS)
[![](https://img.shields.io/badge/DRUMMER-v0.0-blue)](https://github.com/DepledgeLab/DRUMMER/)
[![](https://img.shields.io/badge/ELIGOS-v2.1.0-blue)](https://gitlab.com/piroonj/eligos2)
[![](https://img.shields.io/badge/EpiNano-v1.2.0-blue)](https://github.com/novoalab/EpiNano)
[![](https://img.shields.io/badge/NanoRMS-v0.0-blue)](https://github.com/novoalab/nanoRMS/tree/master)
[![](https://img.shields.io/badge/NanoSPA-v0.0-blue)](https://github.com/sihaohuanguc/NanoSPA/tree/master)
[![](https://img.shields.io/badge/TandemMod-v1.1.0-blue)](https://github.com/yulab2021/TandemMod)
[![](https://img.shields.io/badge/NanoMUD-v0.0-blue)](https://github.com/ABOMSBI/NanoMUD/tree/main)
[![](https://img.shields.io/badge/m6Aiso-v0.0-blue)](https://github.com/SYSU-Wang-LAB/m6Aiso)
[![](https://img.shields.io/badge/xPore-v2.0-blue)](https://github.com/GoekeLab/xpore)
[![](https://img.shields.io/badge/pum6a-v0.0-blue)](https://github.com/liuchuwei/pum6a)
[![](https://img.shields.io/badge/Xron-v0.0-blue)](https://github.com/haotianteng/Xron/tree/master)
[![](https://img.shields.io/badge/Dorado-v1.1-blue)](https://github.com/nanoporetech/dorado)

## 1. Preprocess
- Code for basecalling, read align and nanopolish-eventalign are in `./code/preprocess_pipeline.bash`.

## 2. Model retraining
- This repository contains modified code and retraining scripts for six RNA modification detection tools (m6Anet, SingleMod, EpiNano, TandemMod, Dinopore, NanoSPA). 
- Modified source code (when applicable): For each tool where we've made source code modifications, the updated version is provided as a ZIP file (e.g., `./code/m6Anet_modified_code.zip`). The original code is used when no modifications are needed.
- Step-by-step retraining tutorials: Each model includes a detailed retraining script (e.g., `./code/m6Anet_retrain_pipeline.sh`) that guides users through the complete retraining process.
- Benchmarking datasets: Standardized RNA modification sites for model evaluation are available in `./benchmarking_sites/`.
- All retrained models are saved in `./retrained_model/` for direct use or further customization.

## 3. Model testing
- We provide a standardized testing pipeline to evaluate the performance of both original and retrained models can be found in: `./code/model_test_pipeline.sh`.

## 4. Model Evaluation
- Code for generating ROC and PR curves: `./code/ROC_curve.py`.
- Code for selecting the optimal classification cut-off of each model:  `./code/optimal_cut-off_selection.py`.

## Authors
- Tingting Luo
- Moping Xu
- Miao Wang
- Faying Chen
- Jiejun Shi
