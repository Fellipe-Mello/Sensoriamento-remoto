# -*- coding: utf-8 -*-
"""
Created on Mon Jun 26 08:51:44 2023

@author: fellipe.alcantara
"""

import argparse
import os
import sys

def get_args():

    parser = argparse.ArgumentParser()

    parser.add_argument('--file-path',
        help="Redis connection string.",
        type=str, required=True)

    args = parser.parse_args()

    return args


def main():
    
    args = get_args()
    
    file_path = args.file_path
    
    print(file_path)
    
    if os.path.exists(file_path):
        print('O caminho Existe')
        sys.exit(0)
    else:
        print('O caminho Não Existe :(')
        sys.exit(1)
    
    
if __name__ == '__main__':
    
    main()