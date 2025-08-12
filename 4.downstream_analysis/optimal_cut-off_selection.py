import matplotlib
matplotlib.use('Agg') 
import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import f1_score, precision_score, recall_score
import os
import glob
import math

#The results of each tool were organized into a standard format:
#id label score coverage motif
#ENSMUST00000000001.4_63 1 0.478300 27 AGACC

files = glob.glob("./*_m6A_with_labels_converted.txt")
with open('best_thresholds_precision_recall_retrain.txt', 'w') as out_file:
    out_file.write("Model\tBest Threshold\tPrecision\tRecall\tF1 Score\n")  

    for file in files:
        
        file_prefix = os.path.basename(file).split('_')[0]  
        
        plt.figure(figsize=[8,6])  

        Y, X = [], []
        with open(file, "r") as f:
            for i in f:
                ele = i.rstrip().split()
                Y.append(float(ele[1]))  
                
                if file in ["Differr", "ELIGOS", "ELIGOS_diff", "DRUMMER", "xPore","Nanocompore"]:
                    p_value = float(ele[2])  
                    if p_value == 0:
                        X.append(1000)  
                    else:            
                        X.append(-math.log10(p_value))
                else:
                    X.append(float(ele[2]))  

        y_true = np.array(Y)
        y_pred_scores = np.array(X)

        max_score = max(y_pred_scores)
        thresholds = np.linspace(0, max(max_score, 1), 100)  

        f1_scores = []
        precisions = []
        recalls = []

        for threshold in thresholds:
            y_pred = [1 if score >= threshold else 0 for score in y_pred_scores]
            f1 = f1_score(y_true, y_pred)
            precision = precision_score(y_true, y_pred, zero_division=0)
            recall = recall_score(y_true, y_pred, zero_division=0)
            
            f1_scores.append(f1)
            precisions.append(precision)
            recalls.append(recall)

        best_f1_index = np.argmax(f1_scores)
        best_threshold = thresholds[best_f1_index]
        best_f1 = f1_scores[best_f1_index]
        best_precision = precisions[best_f1_index]
        best_recall = recalls[best_f1_index]

        out_file.write(f"{file_prefix}\t{best_threshold:.2f}\t{best_precision:.2f}\t{best_recall:.2f}\t{best_f1:.2f}\n")

        plt.plot(thresholds, f1_scores, label='F1score', color='red')

        if file in ["Differr", "ELIGOS", "ELIGOS_diff", "DRUMMER", "xPore","Nanocompore"]:
            plt.xlim(0, 200)  
        else:
            plt.xlim(0, 1) 

        plt.title(f'{file_prefix}')
        plt.xlabel('Threshold ')
        plt.ylabel('F1 Score')
        plt.legend(loc='best')
        plt.grid(True)

        plt.tight_layout()
        plt.savefig(f"./F1_plots/{file_prefix}_F1_score_vs_threshold.pdf")
        plt.close()

#output tsv format
#Label  Best Threshold   Precision   Recall  F1 Score
#m6Anet 0.81	0.46	0.51	0.48
