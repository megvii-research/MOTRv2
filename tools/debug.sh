#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Copyright (c) 2022 megvii-research. All Rights Reserved.
# ------------------------------------------------------------------------


set -x

args=$(cat $1)

export CUDA_LAUNCH_BLOCKING=1
python main.py ${args} --output_dir /tmp/clip_mot_v2
