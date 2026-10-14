# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 10:48:58 2023

@author: fellipe.alcantara
"""


import numpy as np

# Function to Subset a dataframe
def subset_dataframe(dataframe, percentage):
    num_rows = int(len(dataframe) * percentage / 100)
    subset_indices = np.random.choice(dataframe.index, num_rows, replace=False)
    subset = dataframe.loc[subset_indices]
    return subset

# Define percentage to subset
subset_percentage = 1

# Subsetting 
subset = subset_dataframe('INSERT DATAFRAME HERE', subset_percentage)