# ------------------------------------------------------------------------
# Copyright (c) 2022 megvii-research. All Rights Reserved.
# ------------------------------------------------------------------------


import argparse
from glob import glob
from subprocess import run


parser = argparse.ArgumentParser()
parser.add_argument('src')
parser.add_argument('dst')
args = parser.parse_args()


for src in glob(args.src+'/*/*.py') + glob(args.src+'/*.py'):
    dst = src.replace(args.src, args.dst)
    if run(['diff', src, dst]).returncode != 0:
        print('code --diff', src, dst)
