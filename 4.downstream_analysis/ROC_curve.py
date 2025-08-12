import numpy as np
import math
from sklearn import metrics
import matplotlib
matplotlib.use('Agg')
from matplotlib import pyplot as plt
import glob
import os

#The results of each tool were organized into a standard format:
#id label score coverage motif
#ENSMUST00000000001.4_63 1 0.478300 27 AGACC

files = glob.glob("./*_m6A_with_labels_converted.txt")
colors = ["red", "orange", "yellow", "green", "blue", "purple", "pink", "brown","gold"]
labels = [os.path.basename(file).split('_')[0] for file in files]

plt.figure(figsize=[6.4,6.4])
for idx, file in enumerate(files):
    Y, X = [], []
    with open(file, "r") as f:
        for i in f:
            ele = i.rstrip().split()
            Y.append(int(ele[1])) 
            if file in ["Differr", "ELIGOS", "ELIGOS_diff", "DRUMMER", "xPore","Nanocompore"]:
                p_value = float(ele[2])  
                if p_value == 0:
                    X.append(1000)  
                else:
                    X.append(-math.log10(p_value))
            else:
                X.append(float(ele[2])) 

    y = np.array(Y)
    x = np.array(X)
    
    fpr, tpr, _ = metrics.roc_curve(y, x)
    auc = metrics.auc(fpr, tpr)
    
    plt.plot(fpr, tpr, color=colors[idx % len(colors)], label=f'{labels[idx]} (AUC = {auc:.2f})')

plt.plot([0, 1], [0, 1], 'k--')
plt.title('ROC curve')
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.legend(fontsize="small", frameon=False)
plt.savefig("./ROC.pdf")

plt.figure(figsize=[6.4,6.4])
for idx, file in enumerate(files):
    Y, X = [], []
    with open(file, "r") as f:
        for i in f:
            ele = i.rstrip().split()
            Y.append(int(ele[1]))  
            
            
            if file in ["Differr", "ELIGOS", "ELIGOS_diff", "DRUMMER", "xPore","Nanocompore"]:
                p_value = float(ele[2])  
                
                if p_value == 0:
                    X.append(1000)  
                else:
                    X.append(-math.log10(p_value))
            else:
                X.append(float(ele[2]))  

    y = np.array(Y)
    x = np.array(X)
    
    
    precision, recall, _ = metrics.precision_recall_curve(y, x)
    pr_auc = metrics.auc(recall, precision)
    

    plt.plot(recall, precision, color=colors[idx % len(colors)], label=f'{labels[idx]} (AUC = {pr_auc:.2f})')

plt.title('PR curve')
plt.xlabel('Recall')
plt.ylabel('Precision')
plt.legend(fontsize="small", frameon=False)
plt.savefig("./PR.pdf")
