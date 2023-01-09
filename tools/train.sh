#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Copyright (c) 2022 megvii-research. All Rights Reserved.
# ------------------------------------------------------------------------


set -x

PY_ARGS=${@:2}

set -o pipefail

OUTPUT_BASE=$(echo $1 | sed -e "s/configs/exps/g" | sed -e "s/.args$//g")
mkdir -p $OUTPUT_BASE

for RUN in $(seq 100); do
  ls $OUTPUT_BASE | grep run$RUN && continue
  OUTPUT_DIR=$OUTPUT_BASE/run$RUN
  mkdir $OUTPUT_DIR && break
done

# clean up *.pyc files
rmpyc() {
  rm -rf $(find -name __pycache__)
  rm -rf $(find -name "*.pyc")
}

# run backup
echo "Backing up to log dir: $OUTPUT_DIR"
rmpyc && cp -r models datasets util main.py engine.py submit_dance.py $1 $OUTPUT_DIR
echo " ...Done"

# tar src to avoid future editing
cleanup() {
  echo "Packing source code"
  rmpyc
  # tar -zcf models datasets util main.py engine.py eval.py submit.py --remove-files
  echo " ...Done"
}

args=$(cat $1)

pushd $OUTPUT_DIR
trap cleanup EXIT

# log git status
echo "Logging git status"
git status > git_status
git rev-parse HEAD > git_tag
git diff > git_diff
echo $PY_ARGS > desc
echo " ...Done"

python -m torch.distributed.launch --nproc_per_node=8 --use_env main.py ${args} --output_dir . |& tee -a output.log
